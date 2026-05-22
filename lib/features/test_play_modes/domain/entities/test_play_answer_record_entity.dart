class TestPlayAnswerRecordEntity {
  final int questionId;
  final int selectedOptionId;
  final int? correctOptionId;
  final bool isCorrect;
  final int questionPosition;
  final int answeredAtElapsedSeconds;

  const TestPlayAnswerRecordEntity({
    required this.questionId,
    required this.selectedOptionId,
    required this.correctOptionId,
    required this.isCorrect,
    required this.questionPosition,
    required this.answeredAtElapsedSeconds,
  });
}