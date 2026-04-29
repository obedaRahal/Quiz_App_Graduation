import 'package:quiz_app_grad/features/home/domain/entities/recommended_interests_response_entity.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_users_response_entity.dart';

import '../entities/recommended_tests_response_entity.dart';

abstract class HomeRepository {
  Future<RecommendedTestsResponseEntity> getRecommendedTests({
    required String tab,
  });
  Future<RecommendedInterestsResponseEntity> getRecommendedInterests();
  Future<RecommendedUsersResponseEntity> getRecommendedUsers();
}