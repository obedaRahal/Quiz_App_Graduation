import 'package:quiz_app_grad/features/tests_by_interest/domain/entities/tests_by_interest_response_entity.dart';

class TestsByInterestState {
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? loadMoreErrorMessage;

  final List<TestByInterestEntity> tests;

  final int currentPage;
  final int lastPage;
  final bool hasMorePages;

  const TestsByInterestState({
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreErrorMessage,
    this.tests = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMorePages = false,
  });

  TestsByInterestState copyWith({
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? loadMoreErrorMessage,
    bool clearLoadMoreErrorMessage = false,
    List<TestByInterestEntity>? tests,
    int? currentPage,
    int? lastPage,
    bool? hasMorePages,
  }) {
    return TestsByInterestState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      loadMoreErrorMessage: clearLoadMoreErrorMessage
          ? null
          : loadMoreErrorMessage ?? this.loadMoreErrorMessage,
      tests: tests ?? this.tests,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}