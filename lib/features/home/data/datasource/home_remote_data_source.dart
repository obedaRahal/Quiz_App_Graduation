import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/home/data/models/recommended_interests_response_model.dart';
import 'package:quiz_app_grad/features/home/data/models/recommended_users_response_model.dart';

import '../models/recommended_tests_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<RecommendedTestsResponseModel> getRecommendedTests({
    required String tab,
  });
  Future<RecommendedInterestsResponseModel> getRecommendedInterests();
  Future<RecommendedUsersResponseModel> getRecommendedUsers();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer api;

  const HomeRemoteDataSourceImpl({required this.api});

  @override
  Future<RecommendedTestsResponseModel> getRecommendedTests({
    required String tab,
  }) async {
    final response = await api.get(
      EndPoints.recommendedTests,
      queryParameters: {'tab': tab},
    );

    return RecommendedTestsResponseModel.fromJson(response);
  }

  @override
  Future<RecommendedInterestsResponseModel> getRecommendedInterests() async {
    final response = await api.get(EndPoints.recommendedInterests);

    return RecommendedInterestsResponseModel.fromJson(response);
  }
  @override
Future<RecommendedUsersResponseModel> getRecommendedUsers() async {
  final response = await api.get(
    EndPoints.recommendedUsers,
  );

  return RecommendedUsersResponseModel.fromJson(response);
}
}
