import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/create_test/data/models/ai_question_generation_status_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/create_content_response_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/create_manual_test_request_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/create_manual_test_response_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/editable_test_questions_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/scientific_classification_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/start_ai_question_generation_response_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/update_test_request_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/update_test_response_model.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_content_params.dart';
import 'package:uuid/uuid.dart';

abstract class CreateTestRemoteDataSource {
  Future<ScientificClassificationsResponseModel> getScientificClassifications();

  Future<CreateManualTestResponseModel> createManualTest({
    required CreateManualTestRequestModel request,
  });
  Future<StartAiQuestionGenerationResponseModel> startAiQuestionGeneration({
    required AiQuestionGenerationParams params,
  });

  Future<AiQuestionGenerationStatusResponseModel>
  getAiQuestionGenerationStatus({required int generationRequestId});
  Future<EditableTestQuestionsResponseModel> getEditableTestQuestions({
    required int testId,
  });
  Future<UpdateTestResponseModel> updateTest({
    required int testId,
    required UpdateTestRequestModel request,
  });
  Future<CreateContentResponseModel> createContent({
  required CreateContentParams params,
});
}

class CreateTestRemoteDataSourceImpl implements CreateTestRemoteDataSource {
  final ApiConsumer api;

  const CreateTestRemoteDataSourceImpl({required this.api});
  static const _uuid = Uuid();
  Map<String, String> _idempotencyHeaders() {
    final idempotencyKey = _uuid.v4();

    debugPrint('→ Idempotency-Key: $idempotencyKey');

    return {'Idempotency-Key': idempotencyKey};
  }

  @override
  Future<ScientificClassificationsResponseModel>
  getScientificClassifications() async {
    final response = await api.get(EndPoints.allInterests);

    return ScientificClassificationsResponseModel.fromJson(response);
  }

  @override
  Future<CreateManualTestResponseModel> createManualTest({
    required CreateManualTestRequestModel request,
  }) async {
    final response = await api.post(
      EndPoints.createManualTest,
      data: request.toJson(),
      headers: _idempotencyHeaders(),
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
          'files[]',
          await MultipartFile.fromFile(file.path!, filename: file.name),
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
        headers: {'Accept': 'application/json'},
      ),
    );

    debugPrint('AI GENERATION POST RESPONSE: $response');

    return StartAiQuestionGenerationResponseModel.fromJson(response);
  }

  @override
  Future<EditableTestQuestionsResponseModel> getEditableTestQuestions({
    required int testId,
  }) async {
    debugPrint(
      '============ CreateTestRemoteDataSourceImpl.getEditableTestQuestions ============',
    );

    final endpoint = EndPoints.getEditableTestQuestions(testId);

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: GET');
    debugPrint('→ params: {testId: $testId}');

    final response = await api.get(endpoint);

    debugPrint('← response (getEditableTestQuestions): $response');
    debugPrint('=================================================');

    return EditableTestQuestionsResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<UpdateTestResponseModel> updateTest({
    required int testId,
    required UpdateTestRequestModel request,
  }) async {
    debugPrint(
      '============ CreateTestRemoteDataSourceImpl.updateTest ============',
    );

    final endpoint = EndPoints.updateTest(testId);
    final body = request.toJson();

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: POST');
    debugPrint('→ body: $body');

    final response = await api.post(
      endpoint,
      data: body,
      headers: _idempotencyHeaders(),
    );

    debugPrint('← response (updateTest): $response');
    debugPrint('=================================================');

    return UpdateTestResponseModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<AiQuestionGenerationStatusResponseModel>
  getAiQuestionGenerationStatus({required int generationRequestId}) async {
    final response = await api.get(
      EndPoints.aiQuestionGenerationStatus(generationRequestId),
    );

    return AiQuestionGenerationStatusResponseModel.fromJson(response);
  }
@override
Future<CreateContentResponseModel> createContent({
  required CreateContentParams params,
}) async {
  debugPrint('============ CreateTestRemoteDataSourceImpl.createContent ============');

  final formData = FormData();

  formData.fields.addAll([
    MapEntry('title', params.title),
    MapEntry('description', params.description),
    MapEntry('content_kind', params.contentKind),
    MapEntry('target_level', params.targetLevel),
    MapEntry('visibility_type', params.visibilityType),
  ]);

  for (var i = 0; i < params.interestIds.length; i++) {
    formData.fields.add(
      MapEntry('interest_ids[$i]', params.interestIds[i].toString()),
    );
  }

  for (var i = 0; i < params.assets.length; i++) {
    final file = params.assets[i];

    if (file.path == null || file.path!.trim().isEmpty) {
      continue;
    }

    formData.files.add(
      MapEntry(
        'assets[$i]',
        await MultipartFile.fromFile(
          file.path!,
          filename: file.name,
        ),
      ),
    );
  }

  debugPrint('→ endpoint: ${EndPoints.createContent}');
  debugPrint('→ method: POST');
  debugPrint('→ title: ${params.title}');
  debugPrint('→ description: ${params.description}');
  debugPrint('→ content_kind: ${params.contentKind}');
  debugPrint('→ target_level: ${params.targetLevel}');
  debugPrint('→ visibility_type: ${params.visibilityType}');
  debugPrint('→ interest_ids: ${params.interestIds}');
  debugPrint('→ assets_count: ${params.assets.length}');

  final response = await api.post(
    EndPoints.createContent,
    data: formData,
    isFormData: true,
    headers: _idempotencyHeaders(),
    options: Options(
      contentType: 'multipart/form-data',
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  debugPrint('← response (createContent): $response');
  debugPrint('=================================================');

  return CreateContentResponseModel.fromJson(
    response as Map<String, dynamic>,
  );
}
}
