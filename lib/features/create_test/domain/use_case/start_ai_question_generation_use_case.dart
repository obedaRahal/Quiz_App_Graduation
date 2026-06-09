import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_params.dart';
import 'package:quiz_app_grad/features/create_test/domain/entities/start_ai_question_generation_response_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class StartAiQuestionGenerationUseCase {
  final CreateTestRepository repository;

  const StartAiQuestionGenerationUseCase(this.repository);

  Future<StartAiQuestionGenerationResponseEntity> call({
    required AiQuestionGenerationParams params,
  }) {
    return repository.startAiQuestionGeneration(params: params);
  }
}