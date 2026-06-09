class StartAiQuestionGenerationResponseEntity {
  final bool success;
  final String title;
  final int generationRequestId;
  final String status;
  final bool reused;
  final int statusCode;

  const StartAiQuestionGenerationResponseEntity({
    required this.success,
    required this.title,
    required this.generationRequestId,
    required this.status,
    required this.reused,
    required this.statusCode,
  });
}