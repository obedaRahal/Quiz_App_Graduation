import 'package:quiz_app_grad/features/home/domain/repositories/home_repostory.dart';

import '../entities/recommended_interests_response_entity.dart';

class GetRecommendedInterestsUseCase {
  final HomeRepository repository;

  const GetRecommendedInterestsUseCase(this.repository);

  Future<RecommendedInterestsResponseEntity> call() {
    return repository.getRecommendedInterests();
  }
}