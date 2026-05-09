import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/repositories/laboratory_repository.dart';

class GetLabRecommendedTestsUseCase {
  final LaboratoryRepository repository;

  const GetLabRecommendedTestsUseCase(this.repository);

  Future<LabRecommendedTestsResponseEntity> call({
    required String tab,
    required int page,
  }) {
    return repository.getLabRecommendedTests(
      tab: tab,
      page: page,
    );
  }
}