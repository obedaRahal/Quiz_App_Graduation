import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/services/accessibility/test_voice_assistant_service.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/services/mcq_result_pdf_service.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/get_test_play_content_use_case.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/use_cases/params/get_test_play_content_params.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class TestPlayModesCubit extends Cubit<TestPlayModesState> {
  Timer? _sessionTimer;
  final TestVoiceAssistantService voiceAssistantService;
  final McqResultPdfService mcqResultPdfService;
  final GetTestPlayContentUseCase getTestPlayContentUseCase;

  //////////////////////////////
  //////////////////////////////
  //////////////////////////////
  //////////////////////////////
  //////////////////////////////
  Timer? _challengeBotTimer;
  Timer? _challengeQuestionTimer;

  TestPlayModesCubit({
    required this.voiceAssistantService,
    required this.mcqResultPdfService,
    required this.getTestPlayContentUseCase,
  }) : super(const TestPlayModesState()) {
    debugPrint("============ TestPlayModesCubit INIT ============");
    voiceAssistantService.onCompleted = _handleVoiceCompleted;
    voiceAssistantService.onCancelled = _handleVoiceStopped;
    voiceAssistantService.onError = _handleVoiceError;
  }

  void loadMockTestContent() {
    debugPrint(
      "============ TestPlayModesCubit.loadMockTestContent ============",
    );

    emit(
      state.copyWith(
        contentStatus: TestPlayContentStatus.loading,
        clearError: true,
      ),
    );

    final mockContent = _buildMockContent();

    emit(
      state.copyWith(
        contentStatus: TestPlayContentStatus.success,
        content: mockContent,
        currentQuestionIndex: 0,
        clearSelectedOption: true,
        mcqQuestionPhase: McqQuestionPhase.idle,
        answersByQuestionId: {},
        elapsedSeconds: 0,
        sessionStatus: TestPlaySessionStatus.playing,
        clearError: true,
      ),
    );

    _startSessionTimer();

    debugPrint("✓ mock test content loaded");
    debugPrint("→ questions count: ${mockContent.data.test.questions.length}");
    debugPrint("=================================================");
  }

  void selectMcqOption({required int optionId}) {
    debugPrint("============ TestPlayModesCubit.selectMcqOption ============");
    debugPrint("→ optionId: $optionId");

    if (state.currentQuestion == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    if (state.isMcqChecked) {
      debugPrint("✗ answer already checked, selection is locked");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        selectedOptionId: optionId,
        mcqQuestionPhase: McqQuestionPhase.selected,
        clearError: true,
      ),
    );

    debugPrint("✓ option selected");
    debugPrint("=================================================");
  }

  void checkCurrentMcqAnswer() {
    debugPrint(
      "============ TestPlayModesCubit.checkCurrentMcqAnswer ============",
    );

    final question = state.currentQuestion;
    final selectedOptionId = state.selectedOptionId;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    if (selectedOptionId == null) {
      debugPrint("✗ no option selected");
      emit(
        state.copyWith(errorTitle: "تنبيه", errorMessage: "اختر إجابة أولًا"),
      );
      debugPrint("=================================================");
      return;
    }

    if (state.isMcqChecked) {
      debugPrint("✗ answer already checked");
      debugPrint("=================================================");
      return;
    }

    final correctOption = question.correctOption;
    final isCorrect = selectedOptionId == correctOption?.optionId;

    final updatedAnswers = Map<int, TestPlayAnswerRecordEntity>.from(
      state.answersByQuestionId,
    );

    updatedAnswers[question.questionId] = TestPlayAnswerRecordEntity(
      questionId: question.questionId,
      selectedOptionId: selectedOptionId,
      correctOptionId: correctOption?.optionId,
      isCorrect: isCorrect,
      questionPosition: question.position,
      answeredAtElapsedSeconds: state.elapsedSeconds,
      answeredBy: TestPlayAnswerOwner.user,
    );

    emit(
      state.copyWith(
        mcqQuestionPhase: McqQuestionPhase.checked,
        answersByQuestionId: updatedAnswers,
        clearError: true,
      ),
    );

    debugPrint("✓ answer checked");
    debugPrint("→ isCorrect: $isCorrect");
    debugPrint("=================================================");
  }

  void goToNextMcqQuestion() {
    debugPrint(
      "============ TestPlayModesCubit.goToNextMcqQuestion ============",
    );

    if (!state.canGoNext) {
      debugPrint("✗ cannot go next before checking answer");
      debugPrint("=================================================");
      return;
    }

    final nextIndex = state.currentQuestionIndex + 1;
    final isLastQuestion = nextIndex >= state.totalQuestions;

    if (isLastQuestion) {
      completeSession();
      debugPrint("✓ last question reached, session completed");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        currentQuestionIndex: nextIndex,
        clearSelectedOption: true,
        mcqQuestionPhase: McqQuestionPhase.idle,
        clearError: true,
      ),
    );

    debugPrint("✓ moved to next question");
    debugPrint("→ currentQuestionIndex: $nextIndex");
    debugPrint("=================================================");
  }

  void completeSession() {
    debugPrint("============ TestPlayModesCubit.completeSession ============");

    _stopSessionTimer();

    emit(
      state.copyWith(
        sessionStatus: TestPlaySessionStatus.completed,
        clearSelectedOption: true,
        clearError: true,
      ),
    );

    debugPrint("✓ session completed");
    // debugPrint("→ correct answers: ${state.correctAnswersCount}");
    // debugPrint("→ wrong answers: ${state.wrongAnswersCount}");
    // debugPrint("→ score: ${state.scorePercentage}%");
    debugPrint("→ answered questions: ${state.answeredQuestionsCount}");
    debugPrint("=================================================");
  }

  void resetSession() {
    debugPrint("============ TestPlayModesCubit.resetSession ============");

    _stopSessionTimer();
    _stopChallengeBotTimer();
    _stopChallengeQuestionTimer();

    emit(const TestPlayModesState());

    debugPrint("✓ session reset");
    debugPrint("=================================================");
  }

  void _startSessionTimer() {
    _stopSessionTimer();

    debugPrint(
      "============ TestPlayModesCubit._startSessionTimer ============",
    );

    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remainingSeconds = state.remainingSeconds;

      if (state.isCompleted) {
        _stopSessionTimer();
        return;
      }

      if (remainingSeconds <= 0) {
        completeSession();
        return;
      }

      emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
    });

    debugPrint("✓ timer started");
    debugPrint("=================================================");
  }

  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  TestPlayContentEntity _buildMockContent() {
    return const TestPlayContentEntity(
      success: true,
      title: "! تم جلب محتوى الاختبار بنجاح",
      statusCode: 200,
      data: TestPlayDataEntity(
        viewer: TestPlayViewerEntity(
          userId: 801,
          name: "محمد منصور",
          avatarUrl: "http://localhost/storage/defaults/default-avatar.svg",
        ),
        test: TestPlayInfoEntity(
          testId: 1,
          title: "اختبار توصية 001 - الذكاء الاصطناعي",
          questionCount: 3,
          durationSeconds: 1200,
          passMarkPercentage: 51,
          questions: [
            TestPlayQuestionEntity(
              questionId: 1,
              position: 1,
              questionText:
                  "أي عبارة تعبّر بدقة أكبر عن best practice المرتبطة بـ الذكاء الاصطناعي لهذه الفئة الدراسية؟",
              hintText:
                  "ابدأ بالفكرة الأساسية في الذكاء الاصطناعي ثم استبعد الخيارات التي تركز على تفاصيل جانبية.",
              options: [
                TestPlayOptionEntity(
                  optionId: 1,
                  position: 1,
                  optionText:
                      "اختيار أول إجابة تبدو مألوفة حتى لو لم ترتبط بسياق السؤال.",
                  isCorrect: false,
                ),
                TestPlayOptionEntity(
                  optionId: 2,
                  position: 2,
                  optionText:
                      "الاعتماد على حفظ المصطلح فقط دون فهم طريقة استخدامه.",
                  isCorrect: false,
                ),
                TestPlayOptionEntity(
                  optionId: 3,
                  position: 3,
                  optionText:
                      "مقارنة الخيارات وفق المعنى العملي للمفهوم وليس وفق الكلمات المتشابهة فقط.",
                  isCorrect: true,
                ),
                TestPlayOptionEntity(
                  optionId: 4,
                  position: 4,
                  optionText:
                      "مقارنة الخيارات وفق المعنى العملي للمفهوم وليس وفق الكلمات المتشابهة فقط.",
                  isCorrect: false,
                ),
                TestPlayOptionEntity(
                  optionId: 5,
                  position: 5,
                  optionText:
                      "مقارنة الخيارات وفق المعنى العملي للمفهوم وليس وفق الكلمات المتشابهة فقط.",
                  isCorrect: false,
                ),
              ],
            ),
            TestPlayQuestionEntity(
              questionId: 2,
              position: 2,
              questionText:
                  "عند حل مسألة ضمن الذكاء الاصطناعي، ما التصرف الأنسب الذي يعكس فهمًا عمليًا للمحتوى؟",
              hintText: null,
              options: [
                TestPlayOptionEntity(
                  optionId: 4,
                  position: 1,
                  optionText:
                      "البدء بفهم الفكرة المركزية ثم تطبيقها على مثال واضح.",
                  isCorrect: true,
                ),
                TestPlayOptionEntity(
                  optionId: 5,
                  position: 2,
                  optionText:
                      "اختيار الإجابة الأطول على افتراض أنها الأدق دائمًا.",
                  isCorrect: false,
                ),
                TestPlayOptionEntity(
                  optionId: 6,
                  position: 3,
                  optionText: "تبديل الخطوات المنطقية والاكتفاء بتخمين سريع.",
                  isCorrect: false,
                ),
              ],
            ),
            TestPlayQuestionEntity(
              questionId: 3,
              position: 3,
              questionText:
                  "ما الهدف الأساسي من توظيف الذكاء الاصطناعي في سؤال موجه بدرجة صعب؟",
              hintText:
                  "فكّر بالهدف التعليمي وليس فقط بالكلمات الموجودة في السؤال.",
              options: [
                TestPlayOptionEntity(
                  optionId: 7,
                  position: 1,
                  optionText:
                      "تحليل المعطيات أولًا ثم اختيار الإجراء الذي يحقق الهدف التعليمي بدقة.",
                  isCorrect: true,
                ),
                TestPlayOptionEntity(
                  optionId: 8,
                  position: 2,
                  optionText:
                      "تجاهل المعطيات الأساسية والتركيز على كلمة واحدة.",
                  isCorrect: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> toggleVoiceAssistantForCurrentQuestion() async {
    debugPrint(
      "============ TestPlayModesCubit.toggleVoiceAssistantForCurrentQuestion ============",
    );

    if (state.isVoiceSpeaking) {
      await stopVoiceAssistant();
      debugPrint("✓ voice stopped");
      debugPrint("=================================================");
      return;
    }

    await speakCurrentQuestion();
  }

  Future<void> speakCurrentQuestion() async {
    debugPrint(
      "============ TestPlayModesCubit.speakCurrentQuestion ============",
    );

    final question = state.currentQuestion;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    try {
      emit(
        state.copyWith(
          voiceStatus: TestVoiceAssistantStatus.speaking,
          clearVoiceError: true,
        ),
      );

      final text = _buildCurrentQuestionVoiceText();

      await voiceAssistantService.speak(text);
      debugPrint("✓ current question speaking started");

      //_scheduleVoiceAutoStop(text);

      // emit(
      //   state.copyWith(
      //     voiceStatus: TestVoiceAssistantStatus.stopped,
      //     clearVoiceError: true,
      //   ),
      // );

      debugPrint("✓ current question spoken");
    } catch (error) {
      debugPrint("✗ speakCurrentQuestion error: $error");

      emit(
        state.copyWith(
          voiceStatus: TestVoiceAssistantStatus.failure,
          voiceErrorMessage: "تعذر تشغيل المساعد الصوتي",
        ),
      );
    }

    debugPrint("=================================================");
  }

  Future<void> stopVoiceAssistant() async {
    debugPrint(
      "============ TestPlayModesCubit.stopVoiceAssistant ============",
    );
    try {
      await voiceAssistantService.stop();

      emit(
        state.copyWith(
          voiceStatus: TestVoiceAssistantStatus.stopped,
          clearVoiceError: true,
        ),
      );
    } catch (error) {
      debugPrint("✗ stopVoiceAssistant error: $error");

      emit(
        state.copyWith(
          voiceStatus: TestVoiceAssistantStatus.failure,
          voiceErrorMessage: "تعذر إيقاف المساعد الصوتي",
        ),
      );
    }

    debugPrint("=================================================");
  }

  String _buildCurrentQuestionVoiceText() {
    final question = state.currentQuestion;
    if (question == null) return '';

    final buffer = StringBuffer();

    buffer.writeln(
      'السؤال رقم ${state.currentQuestionNumber} من ${state.totalQuestions}.',
    );
    buffer.writeln(question.questionText);

    for (final option in question.options) {
      buffer.writeln(
        '${_arabicOptionName(option.position)}. ${option.optionText}',
      );
    }

    if (state.selectedOptionId != null && !state.isMcqChecked) {
      TestPlayOptionEntity? selectedOption;

      for (final option in question.options) {
        if (option.optionId == state.selectedOptionId) {
          selectedOption = option;
          break;
        }
      }

      if (selectedOption != null) {
        buffer.writeln(
          'لقد اخترت ${_arabicOptionName(selectedOption.position)}.',
        );
        buffer.writeln('اضغط على زر التحقق لمعرفة النتيجة.');
      }
    }

    if (state.isMcqChecked) {
      final record = state.currentAnswerRecord;

      if (record?.isCorrect == true) {
        buffer.writeln('إجابة صحيحة.');
      } else {
        final correctOption = question.correctOption;
        buffer.writeln('إجابة خاطئة.');

        if (correctOption != null) {
          buffer.writeln(
            'الإجابة الصحيحة هي ${_arabicOptionName(correctOption.position)}. ${correctOption.optionText}',
          );
        }
      }

      if (state.hasHint) {
        buffer.writeln('يمكنك الضغط على زر لماذا لسماع التوضيح.');
      }

      buffer.writeln('اضغط التالي للانتقال إلى السؤال التالي.');
    }

    return buffer.toString();
  }

  String _arabicOptionName(int position) {
    switch (position) {
      case 1:
        return 'الخيار الأول';
      case 2:
        return 'الخيار الثاني';
      case 3:
        return 'الخيار الثالث';
      case 4:
        return 'الخيار الرابع';
      case 5:
        return 'الخيار الخامس';
      default:
        return 'الخيار رقم $position';
    }
  }

  void _handleVoiceCompleted() {
    if (isClosed) return;

    emit(
      state.copyWith(
        voiceStatus: TestVoiceAssistantStatus.stopped,
        clearVoiceError: true,
      ),
    );
  }

  void _handleVoiceStopped() {
    if (isClosed) return;

    emit(
      state.copyWith(
        voiceStatus: TestVoiceAssistantStatus.stopped,
        clearVoiceError: true,
      ),
    );
  }

  void _handleVoiceError() {
    if (isClosed) return;

    emit(
      state.copyWith(
        voiceStatus: TestVoiceAssistantStatus.failure,
        voiceErrorMessage: 'تعذر تشغيل المساعد الصوتي',
      ),
    );
  }

  Future<void> downloadMcqResultPdf() async {
    debugPrint(
      "============ TestPlayModesCubit.downloadMcqResultPdf ============",
    );

    final test = state.test;

    if (test == null) {
      debugPrint("✗ test is null, cannot generate pdf");

      emit(
        state.copyWith(
          mcqResultPdfStatus: McqResultPdfStatus.failure,
          errorTitle: "خطأ",
          errorMessage: "لا توجد بيانات كافية لإنشاء ملف النتيجة",
          clearGeneratedMcqResultPdfPath: true,
        ),
      );

      return;
    }

    if (state.isMcqResultPdfLoading) {
      debugPrint("✗ pdf generation already loading");
      debugPrint("=================================================");
      return;
    }

    emit(
      state.copyWith(
        mcqResultPdfStatus: McqResultPdfStatus.loading,
        clearGeneratedMcqResultPdfPath: true,
        clearError: true,
      ),
    );

    try {
      final filePath = await mcqResultPdfService.generateMcqResultPdf(
        test: test,
        answersByQuestionId: state.answersByQuestionId,
        correctAnswersCount: state.correctAnswersCount,
        wrongAnswersCount: state.wrongAnswersCount,
        scorePercentage: state.scorePercentage,
        elapsedSeconds: state.elapsedSeconds,
        hasPassed: state.hasPassed,
      );

      debugPrint("✓ mcq result pdf generated");
      debugPrint("→ filePath: $filePath");

      emit(
        state.copyWith(
          mcqResultPdfStatus: McqResultPdfStatus.success,
          generatedMcqResultPdfPath: filePath,
          clearError: true,
        ),
      );
    } catch (error) {
      debugPrint("✗ downloadMcqResultPdf error: $error");

      emit(
        state.copyWith(
          mcqResultPdfStatus: McqResultPdfStatus.failure,
          errorTitle: "خطأ",
          errorMessage: "تعذر إنشاء ملف نتيجة الاختبار",
          clearGeneratedMcqResultPdfPath: true,
        ),
      );
    }

    debugPrint("=================================================");
  }

  void resetMcqResultPdfState() {
    emit(
      state.copyWith(
        mcqResultPdfStatus: McqResultPdfStatus.initial,
        clearGeneratedMcqResultPdfPath: true,
        clearError: true,
      ),
    );
  }

  Future<void> getTestPlayContent({required int testId}) async {
    debugPrint(
      "============ TestPlayModesCubit.getTestPlayContent ============",
    );
    debugPrint("→ params: {testId: $testId}");

    _stopSessionTimer();
    await stopVoiceAssistant();

    emit(
      state.copyWith(
        contentStatus: TestPlayContentStatus.loading,
        clearError: true,
        clearSelectedOption: true,
        answersByQuestionId: {},
        elapsedSeconds: 0,
        currentQuestionIndex: 0,
        mcqQuestionPhase: McqQuestionPhase.idle,
        sessionStatus: TestPlaySessionStatus.playing,
      ),
    );

    final result = await getTestPlayContentUseCase(
      GetTestPlayContentParams(testId: testId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ getTestPlayContent failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            contentStatus: TestPlayContentStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ getTestPlayContent success");
        debugPrint("→ title: ${response.title}");
        debugPrint("→ test title: ${response.data.test.title}");
        debugPrint("→ questions count: ${response.data.test.questions.length}");

        emit(
          state.copyWith(
            contentStatus: TestPlayContentStatus.success,
            content: response,
            currentQuestionIndex: 0,
            clearSelectedOption: true,
            mcqQuestionPhase: McqQuestionPhase.idle,
            answersByQuestionId: {},
            elapsedSeconds: 0,
            sessionStatus: TestPlaySessionStatus.playing,
            clearError: true,
          ),
        );

        _startSessionTimer();

        debugPrint("=================================================");
      },
    );
  }

  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  void toggleChallengeRulesPanel() {
    debugPrint(
      "============ TestPlayModesCubit.toggleChallengeRulesPanel ============",
    );

    final nextPanel = state.isChallengeRulesPanelVisible
        ? ChallengeSetupPanel.none
        : ChallengeSetupPanel.rules;

    emit(
      state.copyWith(activeChallengeSetupPanel: nextPanel, clearError: true),
    );

    debugPrint("→ activeChallengeSetupPanel: $nextPanel");
    debugPrint("=================================================");
  }

  void toggleChallengeCharactersPanel() {
    debugPrint(
      "============ TestPlayModesCubit.toggleChallengeCharactersPanel ============",
    );

    final nextPanel = state.isChallengeCharactersPanelVisible
        ? ChallengeSetupPanel.none
        : ChallengeSetupPanel.characters;

    emit(
      state.copyWith(activeChallengeSetupPanel: nextPanel, clearError: true),
    );

    debugPrint("→ activeChallengeSetupPanel: $nextPanel");
    debugPrint("=================================================");
  }

  void changeChallengeDifficulty(ChallengeDifficulty difficulty) {
    debugPrint(
      "============ TestPlayModesCubit.changeChallengeDifficulty ============",
    );
    debugPrint("→ difficulty: $difficulty");

    emit(
      state.copyWith(selectedChallengeDifficulty: difficulty, clearError: true),
    );

    debugPrint("=================================================");
  }

  void selectChallengeCharacter(int characterId) {
    debugPrint(
      "============ TestPlayModesCubit.selectChallengeCharacter ============",
    );
    debugPrint("→ characterId: $characterId");

    emit(
      state.copyWith(
        selectedChallengeCharacterId: characterId,
        activeChallengeSetupPanel: ChallengeSetupPanel.none,
        clearError: true,
      ),
    );

    debugPrint("✓ challenge character selected");
    debugPrint("=================================================");
  }

  void closeChallengeSetupPanel() {
    debugPrint(
      "============ TestPlayModesCubit.closeChallengeSetupPanel ============",
    );

    emit(
      state.copyWith(
        activeChallengeSetupPanel: ChallengeSetupPanel.none,
        clearError: true,
      ),
    );

    debugPrint("✓ challenge setup panel closed");
    debugPrint("=================================================");
  }

  void startChallengeSession() {
    debugPrint(
      "============ TestPlayModesCubit.startChallengeSession ============",
    );

    if (!state.hasPlayableContent) {
      debugPrint("✗ no playable content");
      debugPrint("=================================================");
      return;
    }

    _stopSessionTimer();
    _stopChallengeBotTimer();

    emit(
      state.copyWith(
        currentQuestionIndex: 0,
        clearSelectedOption: true,
        mcqQuestionPhase: McqQuestionPhase.idle,
        answersByQuestionId: {},
        elapsedSeconds: 0,
        sessionStatus: TestPlaySessionStatus.playing,
        challengeUserScore: 0,
        challengeBotScore: 0,
        challengeBotSelectedOptionId: null,
        challengeBotAnswerStatus: ChallengeBotAnswerStatus.thinking,
        challengeUserLastResult: ChallengeAnswerResult.none,
        challengeBotLastResult: ChallengeAnswerResult.none,
        // challengeUserHasAnsweredCurrentQuestion: false,
        // challengeBotHasAnsweredCurrentQuestion: false,
        activeChallengeSetupPanel: ChallengeSetupPanel.none,
        clearError: true,
        challengeAnsweredBy: ChallengeAnsweredBy.none,
        clearChallengeCurrentAnswerIsCorrect: true,
        challengeBotReaction: ChallengeBotReaction.thinking,
      ),
    );

    _startSessionTimer();

    final questionSeconds = _getBotReactionSeconds();

    _startChallengeQuestionTimer(totalSeconds: questionSeconds);
    _scheduleBotAnswerForCurrentQuestion(reactionSeconds: questionSeconds);

    debugPrint("✓ challenge session started");
    debugPrint("=================================================");
  }

  void selectChallengeAnswer({required int optionId}) {
    debugPrint(
      "============ TestPlayModesCubit.selectChallengeAnswer ============",
    );
    debugPrint("→ optionId: $optionId");

    final question = state.currentQuestion;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    if (!state.canChallengeUserAnswer) {
      debugPrint("✗ user cannot answer now");
      debugPrint("=================================================");
      return;
    }

    final selectedOption = _findOptionById(question, optionId);

    if (selectedOption == null) {
      debugPrint("✗ selected option not found");
      debugPrint("=================================================");
      return;
    }

    final updatedAnswers = Map<int, TestPlayAnswerRecordEntity>.from(
      state.answersByQuestionId,
    );

    updatedAnswers[question.questionId] = TestPlayAnswerRecordEntity(
      questionId: question.questionId,
      selectedOptionId: optionId,
      correctOptionId: question.correctOption?.optionId,
      isCorrect: selectedOption.isCorrect,
      questionPosition: question.position,
      answeredAtElapsedSeconds: state.elapsedSeconds,
      answeredBy: TestPlayAnswerOwner.user,
    );

    emit(
      state.copyWith(
        selectedOptionId: optionId,
        answersByQuestionId: updatedAnswers,
        clearError: true,
      ),
    );

    _resolveChallengeQuestion(
      answeredBy: ChallengeAnsweredBy.user,
      selectedOptionId: optionId,
    );

    debugPrint("✓ user answered first");
    debugPrint("→ isCorrect: ${selectedOption.isCorrect}");
    debugPrint("=================================================");
  }

  void _scheduleBotAnswerForCurrentQuestion({required int reactionSeconds}) {
    debugPrint(
      "============ TestPlayModesCubit._scheduleBotAnswerForCurrentQuestion ============",
    );

    final question = state.currentQuestion;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    _stopChallengeBotTimer();

    //final reactionSeconds = _getBotReactionSeconds();

    emit(
      state.copyWith(
        challengeBotAnswerStatus: ChallengeBotAnswerStatus.thinking,
        challengeBotSelectedOptionId: null,
        challengeBotLastResult: ChallengeAnswerResult.none,
        //challengeBotHasAnsweredCurrentQuestion: false,
        challengeBotReaction: ChallengeBotReaction.thinking,
      ),
    );

    _challengeBotTimer = Timer(Duration(seconds: reactionSeconds), () {
      _answerCurrentQuestionByBot();
    });

    debugPrint("✓ bot answer scheduled");
    debugPrint("→ reactionSeconds: $reactionSeconds");
    debugPrint("=================================================");
  }

  void _answerCurrentQuestionByBot() {
    debugPrint(
      "============ TestPlayModesCubit._answerCurrentQuestionByBot ============",
    );

    final question = state.currentQuestion;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    if (state.isChallengeQuestionResolved) {
      debugPrint("✗ challenge question already resolved");
      debugPrint("=================================================");
      return;
    }

    final selectedOption = _pickBotOption(question);

    final updatedAnswers = Map<int, TestPlayAnswerRecordEntity>.from(
      state.answersByQuestionId,
    );

    updatedAnswers[question.questionId] = TestPlayAnswerRecordEntity(
      questionId: question.questionId,
      selectedOptionId: selectedOption.optionId,
      correctOptionId: question.correctOption?.optionId,
      isCorrect: selectedOption.isCorrect,
      questionPosition: question.position,
      answeredAtElapsedSeconds: state.elapsedSeconds,
      answeredBy: TestPlayAnswerOwner.bot,
    );

    emit(
      state.copyWith(
        challengeBotSelectedOptionId: selectedOption.optionId,
        challengeBotAnswerStatus: ChallengeBotAnswerStatus.answered,
        answersByQuestionId: updatedAnswers,
        clearError: true,
      ),
    );

    _resolveChallengeQuestion(
      answeredBy: ChallengeAnsweredBy.bot,
      selectedOptionId: selectedOption.optionId,
    );

    debugPrint("✓ bot answered first");
    debugPrint("→ optionId: ${selectedOption.optionId}");
    debugPrint("→ isCorrect: ${selectedOption.isCorrect}");
    debugPrint("=================================================");
  }

  TestPlayOptionEntity? _findOptionById(
    TestPlayQuestionEntity question,
    int? optionId,
  ) {
    if (optionId == null) return null;

    for (final option in question.options) {
      if (option.optionId == optionId) {
        return option;
      }
    }

    return null;
  }

  TestPlayOptionEntity _pickBotOption(TestPlayQuestionEntity question) {
    final random = Random();

    final accuracy = _getBotAccuracyPercentage();
    final willAnswerCorrect = random.nextInt(100) < accuracy;

    if (willAnswerCorrect && question.correctOption != null) {
      return question.correctOption!;
    }

    final wrongOptions = question.options
        .where((option) => !option.isCorrect)
        .toList();

    if (wrongOptions.isEmpty) {
      return question.correctOption ?? question.options.first;
    }

    return wrongOptions[random.nextInt(wrongOptions.length)];
  }

  int _getBotAccuracyPercentage() {
    switch (state.selectedChallengeDifficulty) {
      case ChallengeDifficulty.easy:
        return 55;
      case ChallengeDifficulty.medium:
        return 72;
      case ChallengeDifficulty.hard:
        return 90;
    }
  }

  int _getBotReactionSeconds() {
    final random = Random();

    switch (state.selectedChallengeDifficulty) {
      case ChallengeDifficulty.easy:
        return 5 + random.nextInt(5); // 5 - 9
      case ChallengeDifficulty.medium:
        return 3 + random.nextInt(4); // 3 - 6
      case ChallengeDifficulty.hard:
        return 1 + random.nextInt(3); // 1 - 3
    }
  }

  void goToNextChallengeQuestion() {
    debugPrint(
      "============ TestPlayModesCubit.goToNextChallengeQuestion ============",
    );

    if (!state.canGoNextChallengeQuestion) {
      debugPrint("✗ cannot go next before both answered");
      debugPrint("=================================================");
      return;
    }

    _stopChallengeQuestionTimer();

    final nextIndex = state.currentQuestionIndex + 1;
    final isLastQuestion = nextIndex >= state.totalQuestions;

    if (isLastQuestion) {
      completeSession();
      _stopChallengeBotTimer();
      _stopChallengeQuestionTimer();

      debugPrint("✓ challenge completed");
      debugPrint("=================================================");
      return;
    }

    final questionSeconds = _getBotReactionSeconds();

    emit(
      state.copyWith(
        currentQuestionIndex: nextIndex,
        clearSelectedOption: true,
        mcqQuestionPhase: McqQuestionPhase.idle,
        challengeQuestionTotalSeconds: questionSeconds,
        challengeQuestionRemainingSeconds: questionSeconds,
        clearError: true,
        challengeAnsweredBy: ChallengeAnsweredBy.none,
        clearChallengeCurrentAnswerIsCorrect: true,
        challengeBotReaction: ChallengeBotReaction.thinking,
        challengeBotAnswerStatus: ChallengeBotAnswerStatus.thinking,
        challengeBotSelectedOptionId: null,
        challengeUserLastResult: ChallengeAnswerResult.none,
        challengeBotLastResult: ChallengeAnswerResult.none,
        // challengeUserHasAnsweredCurrentQuestion: false,
        // challengeBotHasAnsweredCurrentQuestion: false,
      ),
    );

    _startChallengeQuestionTimer(totalSeconds: questionSeconds);
    _scheduleBotAnswerForCurrentQuestion(reactionSeconds: questionSeconds);

    debugPrint("✓ moved to next challenge question");
    debugPrint("→ currentQuestionIndex: $nextIndex");
    debugPrint("→ questionSeconds: $questionSeconds");
    debugPrint("=================================================");
  }

  void _stopChallengeBotTimer() {
    _challengeBotTimer?.cancel();
    _challengeBotTimer = null;
  }

  void _stopChallengeQuestionTimer() {
    _challengeQuestionTimer?.cancel();
    _challengeQuestionTimer = null;
  }

  void _startChallengeQuestionTimer({required int totalSeconds}) {
    debugPrint(
      "============ TestPlayModesCubit._startChallengeQuestionTimer ============",
    );
    debugPrint("→ totalSeconds: $totalSeconds");

    _stopChallengeQuestionTimer();

    emit(
      state.copyWith(
        challengeQuestionTotalSeconds: totalSeconds,
        challengeQuestionRemainingSeconds: totalSeconds,
      ),
    );

    _challengeQuestionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = state.challengeQuestionRemainingSeconds;

      if (state.isChallengeQuestionResolved || state.isCompleted) {
        _stopChallengeQuestionTimer();
        return;
      }

      if (remaining <= 1) {
        _stopChallengeQuestionTimer();
        _markChallengeUserAsTimeout();
        return;
      }

      emit(state.copyWith(challengeQuestionRemainingSeconds: remaining - 1));
    });

    debugPrint("✓ challenge question timer started");
    debugPrint("=================================================");
  }

  void _markChallengeUserAsTimeout() {
    debugPrint(
      "============ TestPlayModesCubit._markChallengeUserAsTimeout ============",
    );

    final question = state.currentQuestion;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    final updatedAnswers = Map<int, TestPlayAnswerRecordEntity>.from(
      state.answersByQuestionId,
    );

    if (state.isChallengeQuestionResolved) {
      debugPrint("✗ challenge question already resolved");
      debugPrint("=================================================");
      return;
    }

    updatedAnswers[question.questionId] = TestPlayAnswerRecordEntity(
      questionId: question.questionId,
      selectedOptionId: null,
      correctOptionId: question.correctOption?.optionId,
      isCorrect: false,
      questionPosition: question.position,
      answeredAtElapsedSeconds: state.elapsedSeconds,
      answeredBy: TestPlayAnswerOwner.timeout,
    );

    emit(state.copyWith(answersByQuestionId: updatedAnswers, clearError: true));

    _resolveChallengeQuestion(
      answeredBy: ChallengeAnsweredBy.timeout,
      selectedOptionId: null,
    );

    debugPrint("✓ timeout resolved");
    debugPrint("=================================================");
  }

  //// fixes
  void _resolveChallengeQuestion({
    required ChallengeAnsweredBy answeredBy,
    required int? selectedOptionId,
  }) {
    debugPrint(
      "============ TestPlayModesCubit._resolveChallengeQuestion ============",
    );
    debugPrint("→ answeredBy: $answeredBy");
    debugPrint("→ selectedOptionId: $selectedOptionId");

    final question = state.currentQuestion;

    if (question == null) {
      debugPrint("✗ currentQuestion is null");
      debugPrint("=================================================");
      return;
    }

    if (state.isChallengeQuestionResolved) {
      debugPrint("✗ challenge question already resolved");
      debugPrint("=================================================");
      return;
    }

    _stopChallengeQuestionTimer();
    _stopChallengeBotTimer();

    final selectedOption = _findOptionById(question, selectedOptionId);

    final isCorrect = selectedOption?.isCorrect == true;

    int userScore = state.challengeUserScore;
    int botScore = state.challengeBotScore;

    ChallengeAnswerResult userResult = ChallengeAnswerResult.none;
    ChallengeAnswerResult botResult = ChallengeAnswerResult.none;

    ChallengeBotReaction botReaction = ChallengeBotReaction.none;

    if (answeredBy == ChallengeAnsweredBy.user) {
      if (isCorrect) {
        userScore++;
        userResult = ChallengeAnswerResult.correct;
        botResult = ChallengeAnswerResult.wrong;
        botReaction = ChallengeBotReaction.wrong;
      } else {
        botScore++;
        userResult = ChallengeAnswerResult.wrong;
        botResult = ChallengeAnswerResult.correct;
        botReaction = ChallengeBotReaction.correct;
      }
    }

    if (answeredBy == ChallengeAnsweredBy.bot) {
      if (isCorrect) {
        botScore++;
        botResult = ChallengeAnswerResult.correct;
        userResult = ChallengeAnswerResult.wrong;
        botReaction = ChallengeBotReaction.correct;
      } else {
        userScore++;
        botResult = ChallengeAnswerResult.wrong;
        userResult = ChallengeAnswerResult.correct;
        botReaction = ChallengeBotReaction.wrong;
      }
    }

    if (answeredBy == ChallengeAnsweredBy.timeout) {
      botScore++;
      userResult = ChallengeAnswerResult.wrong;
      botResult = ChallengeAnswerResult.correct;
      botReaction = ChallengeBotReaction.correct;
    }

    emit(
      state.copyWith(
        challengeAnsweredBy: answeredBy,
        challengeCurrentAnswerIsCorrect: isCorrect,
        challengeUserScore: userScore,
        challengeBotScore: botScore,
        challengeUserLastResult: userResult,
        challengeBotLastResult: botResult,
        challengeBotReaction: botReaction,
        // challengeUserHasAnsweredCurrentQuestion:
        //     answeredBy == ChallengeAnsweredBy.user ||
        //     answeredBy == ChallengeAnsweredBy.timeout,
        // challengeBotHasAnsweredCurrentQuestion:
        //     answeredBy == ChallengeAnsweredBy.bot ||
        //     answeredBy == ChallengeAnsweredBy.timeout,
        clearError: true,
      ),
    );

    debugPrint("✓ challenge question resolved");
    debugPrint("→ isCorrect: $isCorrect");
    debugPrint("→ userScore: $userScore");
    debugPrint("→ botScore: $botScore");
    debugPrint("=================================================");
  }

  @override
  Future<void> close() async {
    debugPrint("============ TestPlayModesCubit CLOSE ============");
    _stopSessionTimer();
    voiceAssistantService.onCompleted = null;
    voiceAssistantService.onCancelled = null;
    voiceAssistantService.onError = null;
    await voiceAssistantService.dispose();

    _stopChallengeBotTimer();
    _stopChallengeQuestionTimer();
    return super.close();
  }
}
