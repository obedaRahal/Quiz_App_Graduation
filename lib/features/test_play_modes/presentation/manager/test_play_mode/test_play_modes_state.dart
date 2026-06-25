import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

//////////////////// MCQ ////////////////////////////
//////////////////// MCQ ////////////////////////////
enum TestPlayContentStatus { initial, loading, success, failure }

enum McqQuestionPhase { idle, selected, checked }

enum TestPlaySessionStatus { playing, completed }

enum TestVoiceAssistantStatus { initial, speaking, stopped, failure }

enum McqResultPdfStatus { initial, loading, success, failure }

//////////////////// CHALLENGE ////////////////////////////
//////////////////// CHALLENGE ////////////////////////////
enum ChallengeDifficulty { easy, medium, hard }

enum ChallengeSetupPanel { none, rules, characters }

enum ChallengeBotAnswerStatus { idle, thinking, answered }

enum ChallengeAnswerResult { none, correct, wrong }

enum ChallengeBotReaction { none, thinking, correct, wrong }

enum ChallengeAnsweredBy { none, user, bot, timeout }

enum ChallengeResultPdfStatus { initial, loading, success, failure }
//////////////////// FLASHCARDS ////////////////////////////
//////////////////// FLASHCARDS ////////////////////////////

class TestPlayModesState {
  //////////////////// MCQ ////////////////////////////
  //////////////////// MCQ ////////////////////////////
  final TestPlayContentStatus contentStatus;
  final TestPlayContentEntity? content;

  final String? errorTitle;
  final String? errorMessage;

  final int currentQuestionIndex;
  final int? selectedOptionId;
  final McqQuestionPhase mcqQuestionPhase;
  final Map<int, TestPlayAnswerRecordEntity> answersByQuestionId;

  final int elapsedSeconds;
  final TestPlaySessionStatus sessionStatus;

  final TestVoiceAssistantStatus voiceStatus;
  final String? voiceErrorMessage;

  final McqResultPdfStatus mcqResultPdfStatus;
  final String? generatedMcqResultPdfPath;

  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  final ChallengeDifficulty selectedChallengeDifficulty;
  final ChallengeSetupPanel activeChallengeSetupPanel;
  final int selectedChallengeCharacterId;

  final int challengeUserScore;
  final int challengeBotScore;
  final int? challengeBotSelectedOptionId;
  final ChallengeAnswerResult challengeUserLastResult;
  final ChallengeAnswerResult challengeBotLastResult;
  final ChallengeBotAnswerStatus challengeBotAnswerStatus;
  // final bool challengeUserHasAnsweredCurrentQuestion;
  // final bool challengeBotHasAnsweredCurrentQuestion;
  final int challengeQuestionTotalSeconds;
  final int challengeQuestionRemainingSeconds;
  final ChallengeBotReaction challengeBotReaction;

  final ChallengeAnsweredBy challengeAnsweredBy;
  final bool? challengeCurrentAnswerIsCorrect;

  final ChallengeResultPdfStatus challengeResultPdfStatus;
  final String? generatedChallengeResultPdfPath;

  //////////////////// FLASHCARDS ////////////////////////////
  //////////////////// FLASHCARDS ////////////////////////////

  final bool isFlashcardFlipped;
  final List<int> flashcardQueueQuestionIds;
  final Set<int> flashcardKnownQuestionIds;
  final Set<int> flashcardUnknownQuestionIds;
  final Set<int> flashcardReviewedQuestionIds;

  const TestPlayModesState({
    this.contentStatus = TestPlayContentStatus.initial,
    this.content,
    this.errorTitle,
    this.errorMessage,
    this.currentQuestionIndex = 0,
    this.selectedOptionId,
    this.mcqQuestionPhase = McqQuestionPhase.idle,
    this.answersByQuestionId = const {},
    this.elapsedSeconds = 0,
    this.sessionStatus = TestPlaySessionStatus.playing,

    this.voiceStatus = TestVoiceAssistantStatus.initial,
    this.voiceErrorMessage,

    this.mcqResultPdfStatus = McqResultPdfStatus.initial,
    this.generatedMcqResultPdfPath,

    /////////////////////////////////////////////////////////////
    this.selectedChallengeDifficulty = ChallengeDifficulty.medium,
    this.activeChallengeSetupPanel = ChallengeSetupPanel.none,
    this.selectedChallengeCharacterId = 1,

    this.challengeUserScore = 0,
    this.challengeBotScore = 0,
    this.challengeBotSelectedOptionId,
    this.challengeBotAnswerStatus = ChallengeBotAnswerStatus.idle,
    this.challengeUserLastResult = ChallengeAnswerResult.none,
    this.challengeBotLastResult = ChallengeAnswerResult.none,
    // this.challengeUserHasAnsweredCurrentQuestion = false,
    // this.challengeBotHasAnsweredCurrentQuestion = false,
    this.challengeQuestionTotalSeconds = 0,
    this.challengeQuestionRemainingSeconds = 0,
    this.challengeBotReaction = ChallengeBotReaction.none,

    this.challengeAnsweredBy = ChallengeAnsweredBy.none,
    this.challengeCurrentAnswerIsCorrect,

    this.challengeResultPdfStatus = ChallengeResultPdfStatus.initial,
    this.generatedChallengeResultPdfPath,

    /////////////////////////////
    this.isFlashcardFlipped = false,
    this.flashcardQueueQuestionIds = const [],
    this.flashcardKnownQuestionIds = const {},
    this.flashcardUnknownQuestionIds = const {},
    this.flashcardReviewedQuestionIds = const {},
  });

  //////////////////// MCQ ////////////////////////////
  //////////////////// MCQ ////////////////////////////
  bool get isContentLoading => contentStatus == TestPlayContentStatus.loading;
  bool get isContentSuccess => contentStatus == TestPlayContentStatus.success;
  bool get isContentFailure => contentStatus == TestPlayContentStatus.failure;

  bool get isMcqIdle => mcqQuestionPhase == McqQuestionPhase.idle;
  bool get isMcqSelected => mcqQuestionPhase == McqQuestionPhase.selected;
  bool get isMcqChecked => mcqQuestionPhase == McqQuestionPhase.checked;

  bool get isCompleted => sessionStatus == TestPlaySessionStatus.completed;

  TestPlayInfoEntity? get test => content?.data.test;

  List<TestPlayQuestionEntity> get questions => test?.questions ?? const [];

  int get totalQuestions => questions.length;

  bool get isVoiceSpeaking => voiceStatus == TestVoiceAssistantStatus.speaking;
  bool get isVoiceFailure => voiceStatus == TestVoiceAssistantStatus.failure;

  bool get isMcqResultPdfLoading =>
      mcqResultPdfStatus == McqResultPdfStatus.loading;
  bool get isMcqResultPdfSuccess =>
      mcqResultPdfStatus == McqResultPdfStatus.success;
  bool get isMcqResultPdfFailure =>
      mcqResultPdfStatus == McqResultPdfStatus.failure;

  bool get hasPlayableContent => content != null && questions.isNotEmpty;

  TestPlayQuestionEntity? get currentQuestion {
    if (questions.isEmpty) return null;
    if (currentQuestionIndex < 0 || currentQuestionIndex >= questions.length) {
      return null;
    }

    return questions[currentQuestionIndex];
  }

  int get currentQuestionNumber {
    if (questions.isEmpty) return 0;
    return currentQuestionIndex + 1;
  }

  bool get canCheckCurrentAnswer =>
      selectedOptionId != null && !isMcqChecked && currentQuestion != null;

  bool get canGoNext => isMcqChecked;

  bool get hasHint {
    final hint = currentQuestion?.hintText;
    return hint != null && hint.trim().isNotEmpty;
  }

  TestPlayAnswerRecordEntity? get currentAnswerRecord {
    final questionId = currentQuestion?.questionId;
    if (questionId == null) return null;
    return answersByQuestionId[questionId];
  }

  bool? get isCurrentAnswerCorrect => currentAnswerRecord?.isCorrect;

  int? get correctOptionId => currentQuestion?.correctOption?.optionId;

  int get correctAnswersCount =>
      answersByQuestionId.values.where((answer) => answer.isCorrect).length;

  int get wrongAnswersCount =>
      answersByQuestionId.values.where((answer) => !answer.isCorrect).length;

  int get answeredQuestionsCount => answersByQuestionId.length;

  int? get totalDurationSeconds => content?.data.test.durationSeconds;
  bool get hasLimitedTime =>
      totalDurationSeconds != null && totalDurationSeconds! > 0;
  int get remainingSeconds {
    final duration = totalDurationSeconds;
    if (duration == null || duration <= 0) {
      return 0;
    }
    return (duration - elapsedSeconds).clamp(0, duration);
  }

  double get progressValue {
    if (totalQuestions == 0) return 0;
    return currentQuestionNumber / totalQuestions;
  }

  int get scorePercentage {
    if (totalQuestions == 0) return 0;
    return ((correctAnswersCount / totalQuestions) * 100).round();
  }

  bool get hasPassed {
    final passMark = test?.passMarkPercentage ?? 0;
    return scorePercentage >= passMark;
  }

  //////////////////// CHALLENGE ////////////////////////////
  //////////////////// CHALLENGE ////////////////////////////
  bool get isChallengeRulesPanelVisible =>
      activeChallengeSetupPanel == ChallengeSetupPanel.rules;
  bool get isChallengeCharactersPanelVisible =>
      activeChallengeSetupPanel == ChallengeSetupPanel.characters;

  bool get isChallengeBotIdle =>
      challengeBotAnswerStatus == ChallengeBotAnswerStatus.idle;
  bool get isChallengeBotThinking =>
      challengeBotAnswerStatus == ChallengeBotAnswerStatus.thinking;
  bool get isChallengeBotAnswered =>
      challengeBotAnswerStatus == ChallengeBotAnswerStatus.answered;
  bool get isChallengeUserLastAnswerCorrect =>
      challengeUserLastResult == ChallengeAnswerResult.correct;
  bool get isChallengeUserLastAnswerWrong =>
      challengeUserLastResult == ChallengeAnswerResult.wrong;
  bool get isChallengeBotLastAnswerCorrect =>
      challengeBotLastResult == ChallengeAnswerResult.correct;
  bool get isChallengeBotLastAnswerWrong =>
      challengeBotLastResult == ChallengeAnswerResult.wrong;

  bool get isChallengeQuestionResolved =>
      challengeAnsweredBy != ChallengeAnsweredBy.none;
  bool get canChallengeUserAnswer =>
      currentQuestion != null && !isChallengeQuestionResolved && !isCompleted;
  bool get canGoNextChallengeQuestion => isChallengeQuestionResolved;

  bool get hasChallengeWinner {
    if (!isCompleted) return false;
    return challengeUserScore != challengeBotScore;
  }

  bool get didChallengeUserWin =>
      isCompleted && challengeUserScore > challengeBotScore;
  bool get didChallengeBotWin =>
      isCompleted && challengeBotScore > challengeUserScore;
  bool get isChallengeDraw =>
      isCompleted && challengeUserScore == challengeBotScore;
  TestPlayOptionEntity? get challengeBotSelectedOption {
    final question = currentQuestion;
    if (question == null || challengeBotSelectedOptionId == null) {
      return null;
    }
    for (final option in question.options) {
      if (option.optionId == challengeBotSelectedOptionId) {
        return option;
      }
    }
    return null;
  }

  bool? get isChallengeBotCurrentAnswerCorrect =>
      challengeBotSelectedOption?.isCorrect;
  bool get isChallengeQuestionTimerRunning =>
      challengeQuestionRemainingSeconds > 0 &&
      !isChallengeQuestionResolved &&
      !isCompleted;

  bool get isChallengeBotReactionThinking =>
      challengeBotReaction == ChallengeBotReaction.thinking;
  bool get isChallengeBotReactionCorrect =>
      challengeBotReaction == ChallengeBotReaction.correct;
  bool get isChallengeBotReactionWrong =>
      challengeBotReaction == ChallengeBotReaction.wrong;
  double get challengeQuestionTimerProgress {
    if (challengeQuestionTotalSeconds <= 0) return 0;
    return challengeQuestionRemainingSeconds / challengeQuestionTotalSeconds;
  }

  bool get isChallengeUserThinking =>
      !isChallengeQuestionResolved && !isCompleted;
  bool get didUserAnswerChallengeQuestion =>
      challengeAnsweredBy == ChallengeAnsweredBy.user;
  bool get didBotAnswerChallengeQuestion =>
      challengeAnsweredBy == ChallengeAnsweredBy.bot;
  bool get didChallengeQuestionTimeout =>
      challengeAnsweredBy == ChallengeAnsweredBy.timeout;

  bool get isChallengeResultPdfLoading =>
      challengeResultPdfStatus == ChallengeResultPdfStatus.loading;
  bool get isChallengeResultPdfSuccess =>
      challengeResultPdfStatus == ChallengeResultPdfStatus.success;
  bool get isChallengeResultPdfFailure =>
      challengeResultPdfStatus == ChallengeResultPdfStatus.failure;

  //////////////////// FLASHCARDS ////////////////////////////
  //////////////////// FLASHCARDS ////////////////////////////

  bool get hasFlashcardCards => flashcardQueueQuestionIds.isNotEmpty;

  TestPlayQuestionEntity? get currentFlashcardQuestion {
    if (flashcardQueueQuestionIds.isEmpty) {
      return null;
    }

    final currentQuestionId = flashcardQueueQuestionIds.first;

    try {
      return questions.firstWhere((q) => q.questionId == currentQuestionId);
    } catch (_) {
      return null;
    }
  }

  int get flashcardRemainingCards => flashcardQueueQuestionIds.length;

  int get flashcardKnownCardsCount => flashcardKnownQuestionIds.length;

  int get flashcardUnknownCardsCount => flashcardUnknownQuestionIds.length;

  int get flashcardReviewedCardsCount => flashcardReviewedQuestionIds.length;

  int get flashcardKnownImmediatelyCardsCount =>
      flashcardKnownQuestionIds.difference(flashcardReviewedQuestionIds).length;

  TestPlayModesState copyWith({
    //////////////////// MCQ ////////////////////////////
    //////////////////// MCQ ////////////////////////////
    TestPlayContentStatus? contentStatus,
    TestPlayContentEntity? content,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    int? currentQuestionIndex,
    int? selectedOptionId,
    bool clearSelectedOption = false,
    McqQuestionPhase? mcqQuestionPhase,
    Map<int, TestPlayAnswerRecordEntity>? answersByQuestionId,

    int? elapsedSeconds,
    TestPlaySessionStatus? sessionStatus,

    TestVoiceAssistantStatus? voiceStatus,
    String? voiceErrorMessage,
    bool clearVoiceError = false,

    McqResultPdfStatus? mcqResultPdfStatus,
    String? generatedMcqResultPdfPath,
    bool clearGeneratedMcqResultPdfPath = false,

    //////////////////// CHALLENGE ////////////////////////////
    //////////////////// CHALLENGE ////////////////////////////
    ChallengeDifficulty? selectedChallengeDifficulty,
    ChallengeSetupPanel? activeChallengeSetupPanel,
    int? selectedChallengeCharacterId,

    int? challengeUserScore,
    int? challengeBotScore,
    int? challengeBotSelectedOptionId,
    ChallengeBotAnswerStatus? challengeBotAnswerStatus,
    ChallengeAnswerResult? challengeUserLastResult,
    ChallengeAnswerResult? challengeBotLastResult,
    //bool? challengeUserHasAnsweredCurrentQuestion,
    //bool? challengeBotHasAnsweredCurrentQuestion,
    int? challengeQuestionTotalSeconds,
    int? challengeQuestionRemainingSeconds,
    ChallengeBotReaction? challengeBotReaction,

    ChallengeAnsweredBy? challengeAnsweredBy,
    bool? challengeCurrentAnswerIsCorrect,
    bool clearChallengeCurrentAnswerIsCorrect = false,

    ChallengeResultPdfStatus? challengeResultPdfStatus,
    String? generatedChallengeResultPdfPath,
    bool clearGeneratedChallengeResultPdfPath = false,

    //////////////////// FLASH CARD ////////////////////////////
    //////////////////// FLASH CARD ////////////////////////////
    bool? isFlashcardFlipped,
    List<int>? flashcardQueueQuestionIds,
    Set<int>? flashcardKnownQuestionIds,
    Set<int>? flashcardUnknownQuestionIds,
    Set<int>? flashcardReviewedQuestionIds,
  }) {
    return TestPlayModesState(
      contentStatus: contentStatus ?? this.contentStatus,
      content: content ?? this.content,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptionId: clearSelectedOption
          ? null
          : selectedOptionId ?? this.selectedOptionId,
      mcqQuestionPhase: mcqQuestionPhase ?? this.mcqQuestionPhase,
      answersByQuestionId: answersByQuestionId ?? this.answersByQuestionId,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      sessionStatus: sessionStatus ?? this.sessionStatus,

      voiceStatus: voiceStatus ?? this.voiceStatus,
      voiceErrorMessage: clearVoiceError
          ? null
          : voiceErrorMessage ?? this.voiceErrorMessage,

      mcqResultPdfStatus: mcqResultPdfStatus ?? this.mcqResultPdfStatus,
      generatedMcqResultPdfPath: clearGeneratedMcqResultPdfPath
          ? null
          : generatedMcqResultPdfPath ?? this.generatedMcqResultPdfPath,

      ///////////////////////////////////
      selectedChallengeDifficulty:
          selectedChallengeDifficulty ?? this.selectedChallengeDifficulty,
      activeChallengeSetupPanel:
          activeChallengeSetupPanel ?? this.activeChallengeSetupPanel,
      selectedChallengeCharacterId:
          selectedChallengeCharacterId ?? this.selectedChallengeCharacterId,

      challengeUserScore: challengeUserScore ?? this.challengeUserScore,
      challengeBotScore: challengeBotScore ?? this.challengeBotScore,
      challengeBotSelectedOptionId:
          challengeBotSelectedOptionId ?? this.challengeBotSelectedOptionId,
      challengeBotAnswerStatus:
          challengeBotAnswerStatus ?? this.challengeBotAnswerStatus,
      challengeUserLastResult:
          challengeUserLastResult ?? this.challengeUserLastResult,
      challengeBotLastResult:
          challengeBotLastResult ?? this.challengeBotLastResult,

      challengeQuestionTotalSeconds:
          challengeQuestionTotalSeconds ?? this.challengeQuestionTotalSeconds,
      challengeQuestionRemainingSeconds:
          challengeQuestionRemainingSeconds ??
          this.challengeQuestionRemainingSeconds,
      challengeBotReaction: challengeBotReaction ?? this.challengeBotReaction,

      challengeAnsweredBy: challengeAnsweredBy ?? this.challengeAnsweredBy,
      challengeCurrentAnswerIsCorrect: clearChallengeCurrentAnswerIsCorrect
          ? null
          : challengeCurrentAnswerIsCorrect ??
                this.challengeCurrentAnswerIsCorrect,

      challengeResultPdfStatus:
          challengeResultPdfStatus ?? this.challengeResultPdfStatus,
      generatedChallengeResultPdfPath: clearGeneratedChallengeResultPdfPath
          ? null
          : generatedChallengeResultPdfPath ??
                this.generatedChallengeResultPdfPath,

      /////////////////////////////
      isFlashcardFlipped: isFlashcardFlipped ?? this.isFlashcardFlipped,
      flashcardQueueQuestionIds:
          flashcardQueueQuestionIds ?? this.flashcardQueueQuestionIds,
      flashcardKnownQuestionIds:
          flashcardKnownQuestionIds ?? this.flashcardKnownQuestionIds,
      flashcardUnknownQuestionIds:
          flashcardUnknownQuestionIds ?? this.flashcardUnknownQuestionIds,
      flashcardReviewedQuestionIds:
          flashcardReviewedQuestionIds ?? this.flashcardReviewedQuestionIds,
    );
  }
}
