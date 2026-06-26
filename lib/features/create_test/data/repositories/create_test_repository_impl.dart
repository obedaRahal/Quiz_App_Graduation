import 'package:quiz_app_grad/features/create_test/data/datasource/create_test_remote_data_source.dart';
import 'package:quiz_app_grad/features/create_test/data/models/create_manual_test_request_model.dart';
import 'package:quiz_app_grad/features/create_test/data/models/update_test_request_model.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_content_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_content_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/editable_test_questions_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/start_ai_question_generation_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class CreateTestRepositoryImpl implements CreateTestRepository {
  final CreateTestRemoteDataSource remoteDataSource;

  const CreateTestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ScientificClassificationsResponseEntity>
  getScientificClassifications() async {
    final response = await remoteDataSource.getScientificClassifications();

    return response.toEntity();
  }

  @override
  Future<CreateManualTestResponseEntity> createManualTest({
    required CreateManualTestParams params,
  }) async {
    final request = CreateManualTestRequestModel.fromParams(params);

    final response = await remoteDataSource.createManualTest(request: request);

    return response.toEntity();
  }

  @override
  Future<StartAiQuestionGenerationResponseEntity> startAiQuestionGeneration({
    required AiQuestionGenerationParams params,
  }) async {
    final response = await remoteDataSource.startAiQuestionGeneration(
      params: params,
    );

    return response.toEntity();
  }

  @override
  Future<AiQuestionGenerationStatusResponseEntity>
  getAiQuestionGenerationStatus({required int generationRequestId}) async {
    final response = await remoteDataSource.getAiQuestionGenerationStatus(
      generationRequestId: generationRequestId,
    );

    return response.toEntity();
  }

  @override
  Future<EditableTestQuestionsResponseEntity> getEditableTestQuestions({
    required int testId,
  }) async {
    final response = await remoteDataSource.getEditableTestQuestions(
      testId: testId,
    );

    return response.toEntity();
  }

  @override
  Future<UpdateTestResponseEntity> updateTest({
    required UpdateTestParams params,
  }) async {
    final request = UpdateTestRequestModel.fromParams(params);

    final response = await remoteDataSource.updateTest(
      testId: params.testId,
      request: request,
    );

    return response.toEntity();
  }

  @override
  Future<CreateContentResponseEntity> createContent({
    required CreateContentParams params,
  }) async {
    final response = await remoteDataSource.createContent(params: params);

    return response.toEntity();
  }
}
