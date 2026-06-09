import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/create_test/data/models/ai_question_generation_status_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/create_manual_test_request_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/create_manual_test_response_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/scientific_classification_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/start_ai_question_generation_response_model.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';

abstract class CreateTestRemoteDataSource {
  Future<ScientificClassificationsResponseModel>
  getScientificClassifications();

  Future<CreateManualTestResponseModel> createManualTest({
    required CreateManualTestRequestModel request,
  });
  Future<StartAiQuestionGenerationResponseModel> startAiQuestionGeneration({
  required AiQuestionGenerationParams params,
});

Future<AiQuestionGenerationStatusResponseModel> getAiQuestionGenerationStatus({
  required int generationRequestId,
});
}

class CreateTestRemoteDataSourceImpl implements CreateTestRemoteDataSource {
  final ApiConsumer api;

  const CreateTestRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<ScientificClassificationsResponseModel>
  getScientificClassifications() async {
    final response = await api.get(
      EndPoints.allInterests,
    );

    return ScientificClassificationsResponseModel.fromJson(response);
  }

  @override
  Future<CreateManualTestResponseModel> createManualTest({
    required CreateManualTestRequestModel request,
  }) async {
    final response = await api.post(
      EndPoints.createManualTest,
      data: request.toJson(),
    );

    return CreateManualTestResponseModel.fromJson(response);
  }
  @override
Future<StartAiQuestionGenerationResponseModel> startAiQuestionGeneration({
  required AiQuestionGenerationParams params,
}) async {
  final formData = FormData();

  formData.fields.addAll([
    MapEntry('source_type', params.sourceType),
    MapEntry('question_count', params.questionCount.toString()),
    MapEntry('difficulty_level', params.difficultyLevel),
    MapEntry('language', params.language),
  ]);

  for (final file in params.files) {
    if (file.path == null || file.path!.trim().isEmpty) {
      continue;
    }

    formData.files.add(
      MapEntry(
        'files[]', // مهم: طابق Postman
        await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      ),
    );
  }

  debugPrint('========== AI GENERATION POST ==========');
  debugPrint('endpoint: ${EndPoints.aiQuestionGenerations}');
  debugPrint('source_type: ${params.sourceType}');
  debugPrint('question_count: ${params.questionCount}');
  debugPrint('difficulty_level: ${params.difficultyLevel}');
  debugPrint('language: ${params.language}');
  debugPrint('files_count: ${params.files.length}');
  for (final file in params.files) {
    debugPrint('file_name: ${file.name}');
    debugPrint('file_path: ${file.path}');
    debugPrint('file_size: ${file.size}');
    debugPrint('file_extension: ${file.extension}');
  }
  debugPrint('========================================');

  final response = await api.post(
    EndPoints.aiQuestionGenerations,
    data: formData,
    isFormData: true,
    options: Options(
      contentType: 'multipart/form-data',
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  debugPrint('AI GENERATION POST RESPONSE: $response');

  return StartAiQuestionGenerationResponseModel.fromJson(response);
}
//   @override
// Future<StartAiQuestionGenerationResponseModel> startAiQuestionGeneration({
//   required AiQuestionGenerationParams params,
// }) async {
//   final formData = FormData();

//   formData.fields.addAll([
//     MapEntry('source_type', params.sourceType),
//     MapEntry('question_count', params.questionCount.toString()),
//     MapEntry('difficulty_level', params.difficultyLevel),
//     MapEntry('language', params.language),
//   ]);

//   for (int i = 0; i < params.files.length; i++) {
//     final file = params.files[i];

//     if (file.path == null || file.path!.trim().isEmpty) {
//       continue;
//     }

//     formData.files.add(
//       MapEntry(
//         'files[$i]',
//         await MultipartFile.fromFile(
//           file.path!,
//           filename: file.name,
//         ),
//       ),
//     );
//   }

//   final response = await api.post(
//     EndPoints.aiQuestionGenerations,
//     data: formData,
//     isFormData: true,
//   );

//   return StartAiQuestionGenerationResponseModel.fromJson(response);
// }

@override
Future<AiQuestionGenerationStatusResponseModel> getAiQuestionGenerationStatus({
  required int generationRequestId,
}) async {
  final response = await api.get(
    EndPoints.aiQuestionGenerationStatus(generationRequestId),
  );

  return AiQuestionGenerationStatusResponseModel.fromJson(response);
}
}