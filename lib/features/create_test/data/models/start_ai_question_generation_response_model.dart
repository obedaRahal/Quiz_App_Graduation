import 'package:quiz_app_grad/features/create_test/domain/entities/start_ai_question_generation_response_entity.dart';

class StartAiQuestionGenerationResponseModel {
  final bool success;
  final String title;
  final StartAiQuestionGenerationDataModel data;
  final int statusCode;

  const StartAiQuestionGenerationResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory StartAiQuestionGenerationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StartAiQuestionGenerationResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: StartAiQuestionGenerationDataModel.fromJson(
        json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : const {},
      ),
      statusCode: int.tryParse((json['status_code'] ?? 0).toString()) ?? 0,
    );
  }

  StartAiQuestionGenerationResponseEntity toEntity() {
    return StartAiQuestionGenerationResponseEntity(
      success: success,
      title: title,
      generationRequestId: data.generationRequestId,
      status: data.status,
      reused: data.reused,
      statusCode: statusCode,
    );
  }
}

class StartAiQuestionGenerationDataModel {
  final int generationRequestId;
  final String status;
  final bool reused;

  const StartAiQuestionGenerationDataModel({
    required this.generationRequestId,
    required this.status,
    required this.reused,
  });

  factory StartAiQuestionGenerationDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StartAiQuestionGenerationDataModel(
      generationRequestId:
          int.tryParse((json['generation_request_id'] ?? 0).toString()) ?? 0,
      status: json['status']?.toString() ?? '',
      reused: json['reused'] == true,
    );
  }
}