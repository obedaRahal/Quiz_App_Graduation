import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';

class AiQuestionGenerationStatusResponseModel {
  final bool success;
  final String title;
  final AiQuestionGenerationStatusModel data;
  final int statusCode;

  const AiQuestionGenerationStatusResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory AiQuestionGenerationStatusResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiQuestionGenerationStatusResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: AiQuestionGenerationStatusModel.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : const {},
      ),
      statusCode: int.tryParse((json['status_code'] ?? 0).toString()) ?? 0,
    );
  }

  AiQuestionGenerationStatusResponseEntity toEntity() {
    return AiQuestionGenerationStatusResponseEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class AiQuestionGenerationStatusModel {
  final int id;
  final String status;
  final String sourceType;
  final int requestedQuestionCount;
  final int questionActuallyGenerated;
  final String difficultyLevel;
  final String language;
  final String provider;
  final List<GeneratedAiQuestionModel> questions;
  final String? failure;

  const AiQuestionGenerationStatusModel({
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

  factory AiQuestionGenerationStatusModel.fromJson(Map<String, dynamic> json) {
    return AiQuestionGenerationStatusModel(
      id: int.tryParse((json['id'] ?? 0).toString()) ?? 0,
      status: json['status']?.toString() ?? '',
      sourceType: json['source_type']?.toString() ?? '',
      requestedQuestionCount:
          int.tryParse((json['requested_question_count'] ?? 0).toString()) ?? 0,
      questionActuallyGenerated:
          int.tryParse((json['question_actually_generated'] ?? 0).toString()) ??
          0,
      difficultyLevel: json['difficulty_level']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      provider: json['provider']?.toString() ?? '',
      questions: (json['questions'] as List? ?? []).map((item) {
        if (item is Map<String, dynamic>) {
          return GeneratedAiQuestionModel.fromJson(item);
        }

        return GeneratedAiQuestionModel.fromJson(const {});
      }).toList(),
      failure: _parseFailure(json['failure']),
    );
  }
  static String? _parseFailure(dynamic failure) {
    if (failure == null) return null;

    if (failure is String) {
      return failure.trim().isEmpty ? null : failure;
    }

    if (failure is Map<String, dynamic>) {
      final message = failure['message']?.toString();
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }

      final code = failure['code']?.toString();
      if (code != null && code.trim().isNotEmpty) {
        return code;
      }
    }

    return failure.toString();
  }

  AiQuestionGenerationStatusEntity toEntity() {
    return AiQuestionGenerationStatusEntity(
      id: id,
      status: status,
      sourceType: sourceType,
      requestedQuestionCount: requestedQuestionCount,
      questionActuallyGenerated: questionActuallyGenerated,
      difficultyLevel: difficultyLevel,
      language: language,
      provider: provider,
      questions: questions.map((item) => item.toEntity()).toList(),
      failure: failure,
    );
  }
}

class GeneratedAiQuestionModel {
  final String questionText;
  final String? hintText;
  final List<GeneratedAiQuestionOptionModel> options;

  const GeneratedAiQuestionModel({
    required this.questionText,
    required this.hintText,
    required this.options,
  });

  factory GeneratedAiQuestionModel.fromJson(Map<String, dynamic> json) {
    return GeneratedAiQuestionModel(
      questionText: json['question_text']?.toString() ?? '',
      hintText: json['hint_text']?.toString(),
      options: (json['options'] as List? ?? []).map((item) {
        if (item is Map<String, dynamic>) {
          return GeneratedAiQuestionOptionModel.fromJson(item);
        }

        return GeneratedAiQuestionOptionModel.fromJson(const {});
      }).toList(),
    );
  }

  GeneratedAiQuestionEntity toEntity() {
    return GeneratedAiQuestionEntity(
      questionText: questionText,
      hintText: hintText,
      options: options.map((item) => item.toEntity()).toList(),
    );
  }
}

class GeneratedAiQuestionOptionModel {
  final String optionText;
  final bool isCorrect;

  const GeneratedAiQuestionOptionModel({
    required this.optionText,
    required this.isCorrect,
  });

  factory GeneratedAiQuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return GeneratedAiQuestionOptionModel(
      optionText: json['option_text']?.toString() ?? '',
      isCorrect: json['is_correct'] == true,
    );
  }

  GeneratedAiQuestionOptionEntity toEntity() {
    return GeneratedAiQuestionOptionEntity(
      optionText: optionText,
      isCorrect: isCorrect,
    );
  }
}
