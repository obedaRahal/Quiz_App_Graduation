import 'package:quiz_app_grad/features/laboratory/domain/entities/ai_generation_daily_limit_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';

class GetAiGenerationDailyLimitUseCase {
  final LaboratoryRepository repository;

  const GetAiGenerationDailyLimitUseCase(this.repository);

  Future<AiGenerationDailyLimitEntity> call() {
    return repository.getAiGenerationDailyLimit();
  }
}