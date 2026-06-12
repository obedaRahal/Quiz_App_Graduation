import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/create_manual_test_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/start_ai_question_generation_response_entity.dart';

abstract class CreateTestRepository {
  Future<ScientificClassificationsResponseEntity>
  getScientificClassifications();

  Future<CreateManualTestResponseEntity> createManualTest({
    required CreateManualTestParams params,
  });
  Future<StartAiQuestionGenerationResponseEntity> startAiQuestionGeneration({
  required AiQuestionGenerationParams params,
});

Future<AiQuestionGenerationStatusResponseEntity> getAiQuestionGenerationStatus({
  required int generationRequestId,
});
}