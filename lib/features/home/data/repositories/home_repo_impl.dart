import 'package:quiz_app_grad/features/home/data/datasource/home_remote_data_source.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_interests_response_entity.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_users_response_entity.dart';
import 'package:quiz_app_grad/features/home/domain/repositories/home_repostory.dart';

import '../../domain/entities/recommended_tests_response_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<RecommendedTestsResponseEntity> getRecommendedTests({
    required String tab,
  }) async {
    final response = await remoteDataSource.getRecommendedTests(tab: tab);
    return response.toEntity();
  }

  @override
  Future<RecommendedInterestsResponseEntity> getRecommendedInterests() async {
    final response = await remoteDataSource.getRecommendedInterests();
    return response.toEntity();
  }

  @override
  Future<RecommendedUsersResponseEntity> getRecommendedUsers() async {
    final response = await remoteDataSource.getRecommendedUsers();
    return response.toEntity();
  }
}
