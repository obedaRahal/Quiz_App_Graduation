class AiQuestionGenerationStatusResponseEntity {
  final bool success;
  final String title;
  final AiQuestionGenerationStatusEntity data;
  final int statusCode;

  const AiQuestionGenerationStatusResponseEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class AiQuestionGenerationStatusEntity {
  final int id;
  final String status;
  final String sourceType;
  final int requestedQuestionCount;
  final int questionActuallyGenerated;
  final String difficultyLevel;
  final String language;
  final String provider;
  final List<GeneratedAiQuestionEntity> questions;
  final String? failure;

  const AiQuestionGenerationStatusEntity({
    required this.id,
    required this.status,
    required this.sourceType,
    required this.requestedQuestionCount,
    required this.questionActuallyGenerated,
    required this.difficultyLevel,
    required this.language,
    required this.provider,
    required this.questions,
    this.failure,
  });

  bool get isCompleted => status.toLowerCase() == 'completed';

  bool get isFailed => status.toLowerCase() == 'failed';

  bool get isProcessing {
    final normalized = status.toLowerCase();

    return normalized == 'pending' ||
        normalized == 'processing' ||
        normalized == 'in_progress';
  }
}

class GeneratedAiQuestionEntity {
  final String questionText;
  final String? hintText;
  final List<GeneratedAiQuestionOptionEntity> options;

  const GeneratedAiQuestionEntity({
    required this.questionText,
    required this.hintText,
    required this.options,
  });
}

class GeneratedAiQuestionOptionEntity {
  final String optionText;
  final bool isCorrect;

  const GeneratedAiQuestionOptionEntity({
    required this.optionText,
    required this.isCorrect,
  });
}