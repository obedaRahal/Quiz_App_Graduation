import 'package:quiz_app_grad/features/home/domain/entities/recommended_tests_response_entity.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_interests_response_entity.dart';
import 'package:quiz_app_grad/features/home/domain/entities/recommended_users_response_entity.dart';

class HomeState {
  final int pageIndex;
  final int filterIndex;

  final bool isRecommendedTestsLoading;
  final String? recommendedTestsError;
  final List<RecommendedTestItemEntity> recommendedTests;

  final bool isRecommendedInterestsLoading;
  final String? recommendedInterestsError;
  final List<RecommendedInterestEntity> recommendedInterests;

  final bool isRecommendedUsersLoading;
  final String? recommendedUsersError;
  final List<RecommendedUserEntity> recommendedUsers;

  const HomeState({
    this.pageIndex = 0,
    this.filterIndex = 0,
    this.isRecommendedTestsLoading = false,
    this.recommendedTestsError,
    this.recommendedTests = const [],
    this.isRecommendedInterestsLoading = false,
    this.recommendedInterestsError,
    this.recommendedInterests = const [],
    this.isRecommendedUsersLoading = false,
    this.recommendedUsersError,
    this.recommendedUsers = const [],
  });

  HomeState copyWith({
    int? pageIndex,
    int? filterIndex,
    bool? isRecommendedTestsLoading,
    String? recommendedTestsError,
    List<RecommendedTestItemEntity>? recommendedTests,
    bool? isRecommendedInterestsLoading,
    String? recommendedInterestsError,
    List<RecommendedInterestEntity>? recommendedInterests,
    bool? isRecommendedUsersLoading,
    String? recommendedUsersError,
    List<RecommendedUserEntity>? recommendedUsers,
  }) {
    return HomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      filterIndex: filterIndex ?? this.filterIndex,
      isRecommendedTestsLoading:
          isRecommendedTestsLoading ?? this.isRecommendedTestsLoading,
      recommendedTestsError: recommendedTestsError,
      recommendedTests: recommendedTests ?? this.recommendedTests,
      isRecommendedInterestsLoading:
          isRecommendedInterestsLoading ?? this.isRecommendedInterestsLoading,
      recommendedInterestsError: recommendedInterestsError,
      recommendedInterests: recommendedInterests ?? this.recommendedInterests,
      isRecommendedUsersLoading:
          isRecommendedUsersLoading ?? this.isRecommendedUsersLoading,
      recommendedUsersError: recommendedUsersError,
      recommendedUsers: recommendedUsers ?? this.recommendedUsers,
    );
  }
}
