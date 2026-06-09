import 'package:quiz_app_grad/features/create_test/domain/entities/scientific_classification_entity.dart';
import 'package:quiz_app_grad/features/create_test/domain/repositories/create_test_repository.dart';

class GetScientificClassificationsUseCase {
  final CreateTestRepository repository;

  const GetScientificClassificationsUseCase(this.repository);

  Future<ScientificClassificationsResponseEntity> call() {
    return repository.getScientificClassifications();
  }
}