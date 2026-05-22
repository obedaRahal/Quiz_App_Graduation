import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/services/accessibility/test_voice_assistant_service.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class TestPlayModesCubit extends Cubit<TestPlayModesState> {
  Timer? _sessionTimer;
  final TestVoiceAssistantService voiceAssistantService;
  Timer? _voiceAutoStopTimer;

  TestPlayModesCubit({required this.voiceAssistantService})
    : super(const TestPlayModesState()) {
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
    debugPrint("→ correct answers: ${state.correctAnswersCount}");
    debugPrint("→ wrong answers: ${state.wrongAnswersCount}");
    debugPrint("→ score: ${state.scorePercentage}%");
    debugPrint("=================================================");
  }

  void resetSession() {
    debugPrint("============ TestPlayModesCubit.resetSession ============");

    _stopSessionTimer();

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

            TestPlayQuestionEntity(
              questionId: 4,
              position: 4,
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

            TestPlayQuestionEntity(
              questionId: 5,
              position: 5,
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

  void _scheduleVoiceAutoStop(String text) {
    _voiceAutoStopTimer?.cancel();

    final wordsCount = text.trim().split(RegExp(r'\s+')).length;

    final estimatedSeconds = (wordsCount / 2.2).ceil().clamp(4, 45);

    debugPrint("============ Voice Auto Stop Scheduled ============");
    debugPrint("→ wordsCount: $wordsCount");
    debugPrint("→ estimatedSeconds: $estimatedSeconds");
    debugPrint("===================================================");

    _voiceAutoStopTimer = Timer(Duration(seconds: estimatedSeconds), () {
      if (isClosed) return;

      emit(
        state.copyWith(
          voiceStatus: TestVoiceAssistantStatus.stopped,
          clearVoiceError: true,
        ),
      );
    });
  }

  Future<void> stopVoiceAssistant() async {
    debugPrint(
      "============ TestPlayModesCubit.stopVoiceAssistant ============",
    );
    try {
      _voiceAutoStopTimer?.cancel();
      _voiceAutoStopTimer = null;
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

  @override
  Future<void> close() async {
    debugPrint("============ TestPlayModesCubit CLOSE ============");
    _stopSessionTimer();
    _voiceAutoStopTimer?.cancel();

    voiceAssistantService.onCompleted = null;
    voiceAssistantService.onCancelled = null;
    voiceAssistantService.onError = null;
    await voiceAssistantService.dispose();
    return super.close();
  }
}
