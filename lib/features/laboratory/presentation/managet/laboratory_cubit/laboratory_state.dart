import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/test_by_interest_response_entity.dart';

class LaboratoryState {
  final bool isInitialLoading;
  final bool isLoadingMore;
  final String? error;

  final List<TestByInterestEntity> examSessions;

  final int currentPage;
  final bool hasMorePages;
  final int? selectedInterestId;

  final bool isSearchMode;
  final bool isSearchLoading;
  final bool isSearchLoadingMore;
  final String? searchError;
  final String searchQuery;
  final List<TestByInterestEntity> searchResults;
  final int searchCurrentPage;
  final bool searchHasMorePages;

  const LaboratoryState({
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.examSessions = const [],
    this.currentPage = 1,
    this.hasMorePages = true,
    this.selectedInterestId,
    this.isSearchMode = false,
    this.isSearchLoading = false,
    this.isSearchLoadingMore = false,
    this.searchError,
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchCurrentPage = 1,
    this.searchHasMorePages = true,
  });

  LaboratoryState copyWith({
    bool? isInitialLoading,
    bool? isLoadingMore,
    String? error,
    List<TestByInterestEntity>? examSessions,
    int? currentPage,
    bool? hasMorePages,
    int? selectedInterestId,
    bool? isSearchMode,
    bool? isSearchLoading,
    bool? isSearchLoadingMore,
    String? searchError,
    String? searchQuery,
    List<TestByInterestEntity>? searchResults,
    int? searchCurrentPage,
    bool? searchHasMorePages,
  }) {
    return LaboratoryState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      examSessions: examSessions ?? this.examSessions,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      selectedInterestId: selectedInterestId ?? this.selectedInterestId,
      isSearchMode: isSearchMode ?? this.isSearchMode,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isSearchLoadingMore: isSearchLoadingMore ?? this.isSearchLoadingMore,
      searchError: searchError,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      searchCurrentPage: searchCurrentPage ?? this.searchCurrentPage,
      searchHasMorePages: searchHasMorePages ?? this.searchHasMorePages,
    );
  }
}
