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

  final bool isSearchMode;
  final bool isSearchLoading;
  final bool isSearchLoadingMore;
  final String searchQuery;
  final String? searchErrorMessage;
  final String? searchLoadMoreErrorMessage;
  final List<TestByInterestEntity> searchResults;
  final int searchCurrentPage;
  final int searchLastPage;
  final bool searchHasMorePages;

  const TestsByInterestState({
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreErrorMessage,
    this.tests = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMorePages = false,
    this.isSearchMode = false,
    this.isSearchLoading = false,
    this.isSearchLoadingMore = false,
    this.searchQuery = '',
    this.searchErrorMessage,
    this.searchLoadMoreErrorMessage,
    this.searchResults = const [],
    this.searchCurrentPage = 1,
    this.searchLastPage = 1,
    this.searchHasMorePages = false,
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
    bool? isSearchMode,
    bool? isSearchLoading,
    bool? isSearchLoadingMore,
    String? searchQuery,
    String? searchErrorMessage,
    bool clearSearchErrorMessage = false,
    String? searchLoadMoreErrorMessage,
    bool clearSearchLoadMoreErrorMessage = false,
    List<TestByInterestEntity>? searchResults,
    int? searchCurrentPage,
    int? searchLastPage,
    bool? searchHasMorePages,
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
      isSearchMode: isSearchMode ?? this.isSearchMode,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isSearchLoadingMore: isSearchLoadingMore ?? this.isSearchLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      searchErrorMessage: clearSearchErrorMessage
          ? null
          : searchErrorMessage ?? this.searchErrorMessage,
      searchLoadMoreErrorMessage: clearSearchLoadMoreErrorMessage
          ? null
          : searchLoadMoreErrorMessage ?? this.searchLoadMoreErrorMessage,
      searchResults: searchResults ?? this.searchResults,
      searchCurrentPage: searchCurrentPage ?? this.searchCurrentPage,
      searchLastPage: searchLastPage ?? this.searchLastPage,
      searchHasMorePages: searchHasMorePages ?? this.searchHasMorePages,
    );
  }
}
