import 'package:quiz_app_grad/features/home/domain/repositories/home_repostory.dart';

import '../entities/recommended_tests_response_entity.dart';

class GetRecommendedTestsUseCase {
  final HomeRepository repository;

  const GetRecommendedTestsUseCase(this.repository);

  Future<RecommendedTestsResponseEntity> call({
    required String tab,
  }) {
    return repository.getRecommendedTests(tab: tab);
  }
}