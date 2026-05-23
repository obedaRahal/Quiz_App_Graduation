import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

enum TestPlayContentStatus { initial, loading, success, failure }

enum McqQuestionPhase { idle, selected, checked }

enum TestPlaySessionStatus { playing, completed }

enum TestVoiceAssistantStatus { initial, speaking, stopped, failure }

enum McqResultPdfStatus { initial, loading, success, failure }

class TestPlayModesState {
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
  });

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

  int get remainingSeconds {
    final duration = test?.durationSeconds ?? 0;
    final remaining = duration - elapsedSeconds;
    return remaining < 0 ? 0 : remaining;
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

  TestPlayModesState copyWith({
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
    );
  }
}
