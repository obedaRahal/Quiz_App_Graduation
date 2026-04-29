import 'package:quiz_app_grad/features/home/domain/repositories/home_repostory.dart';

import '../entities/recommended_users_response_entity.dart';

class GetRecommendedUsersUseCase {
  final HomeRepository repository;

  const GetRecommendedUsersUseCase(this.repository);

  Future<RecommendedUsersResponseEntity> call() {
    return repository.getRecommendedUsers();
  }
}