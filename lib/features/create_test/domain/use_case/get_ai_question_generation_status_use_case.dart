import 'package:quiz_app_grad/features/create_test/domain/entities/ai_question_generation_status_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class GetAiQuestionGenerationStatusUseCase {
  final CreateTestRepository repository;

  const GetAiQuestionGenerationStatusUseCase(this.repository);

  Future<AiQuestionGenerationStatusResponseEntity> call({
    required int generationRequestId,
  }) {
    return repository.getAiQuestionGenerationStatus(
      generationRequestId: generationRequestId,
    );
  }
}