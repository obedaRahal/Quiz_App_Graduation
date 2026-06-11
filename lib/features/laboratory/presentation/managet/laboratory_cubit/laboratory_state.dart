import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/ai_generation_daily_limit_entity.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/filter_tests_params.dart';
import 'package:quiz_app_grad/features/laboratory/domain/entities/lab_recommended_tests_response_entity.dart';
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

  final bool isLabTestsLoading;
  final bool isLabTestsLoadingMore;
  final String? labTestsError;

  final List<LabRecommendedFeaturedTestEntity> featuredTopRatedTests;
  final List<LabRecommendedTestItemEntity> labTests;

  final String selectedLabTab;
  final int labTestsCurrentPage;
  final bool labTestsHasMorePages;

  final bool isFilterInterestsLoading;
  final String? filterInterestsError;
  final List<InterestCategoryEntity> filterInterestCategories;
  final bool isFilterMode;
  final bool isFilterLoading;
  final bool isFilterLoadingMore;
  final String? filterError;
  final List<TestByInterestEntity> filterResults;
  final FilterTestsParams? activeFilterParams;
  final String? filterNextCursor;
  final bool filterHasMorePages;
  final bool isAiDailyLimitLoading;
  final String? aiDailyLimitError;
  final AiGenerationDailyLimitDataEntity? aiDailyLimitData;
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
    this.isLabTestsLoading = false,
    this.isLabTestsLoadingMore = false,
    this.labTestsError,
    this.featuredTopRatedTests = const [],
    this.labTests = const [],
    this.selectedLabTab = 'trending',
    this.labTestsCurrentPage = 1,
    this.labTestsHasMorePages = true,
    this.isFilterInterestsLoading = false,
    this.filterInterestsError,
    this.filterInterestCategories = const [],
    this.isFilterMode = false,
    this.isFilterLoading = false,
    this.isFilterLoadingMore = false,
    this.filterError,
    this.filterResults = const [],
    this.activeFilterParams,
    this.filterNextCursor,
    this.filterHasMorePages = false,
    this.isAiDailyLimitLoading = false,
    this.aiDailyLimitError,
    this.aiDailyLimitData,
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
    bool? isLabTestsLoading,
    bool? isLabTestsLoadingMore,
    String? labTestsError,
    List<LabRecommendedFeaturedTestEntity>? featuredTopRatedTests,
    List<LabRecommendedTestItemEntity>? labTests,
    String? selectedLabTab,
    int? labTestsCurrentPage,
    bool? labTestsHasMorePages,
    bool? isFilterInterestsLoading,
    String? filterInterestsError,
    List<InterestCategoryEntity>? filterInterestCategories,
    bool? isFilterMode,
    bool? isFilterLoading,
    bool? isFilterLoadingMore,
    String? filterError,
    List<TestByInterestEntity>? filterResults,
    Object? activeFilterParams = _sentinel,
    Object? filterNextCursor = _sentinel,
    bool? filterHasMorePages,
    bool? isAiDailyLimitLoading,
    String? aiDailyLimitError,
    Object? aiDailyLimitData = _sentinel,
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
      isLabTestsLoading: isLabTestsLoading ?? this.isLabTestsLoading,
      isLabTestsLoadingMore:
          isLabTestsLoadingMore ?? this.isLabTestsLoadingMore,
      labTestsError: labTestsError,
      featuredTopRatedTests:
          featuredTopRatedTests ?? this.featuredTopRatedTests,
      labTests: labTests ?? this.labTests,
      selectedLabTab: selectedLabTab ?? this.selectedLabTab,
      labTestsCurrentPage: labTestsCurrentPage ?? this.labTestsCurrentPage,
      labTestsHasMorePages: labTestsHasMorePages ?? this.labTestsHasMorePages,
      isFilterInterestsLoading:
          isFilterInterestsLoading ?? this.isFilterInterestsLoading,
      filterInterestsError: filterInterestsError,
      filterInterestCategories:
          filterInterestCategories ?? this.filterInterestCategories,
      isFilterMode: isFilterMode ?? this.isFilterMode,
      isFilterLoading: isFilterLoading ?? this.isFilterLoading,
      isFilterLoadingMore: isFilterLoadingMore ?? this.isFilterLoadingMore,
      filterError: filterError,
      filterResults: filterResults ?? this.filterResults,
      activeFilterParams: activeFilterParams == _sentinel
          ? this.activeFilterParams
          : activeFilterParams as FilterTestsParams?,
      filterNextCursor: filterNextCursor == _sentinel
          ? this.filterNextCursor
          : filterNextCursor as String?,
      filterHasMorePages: filterHasMorePages ?? this.filterHasMorePages,
      isAiDailyLimitLoading:
          isAiDailyLimitLoading ?? this.isAiDailyLimitLoading,
      aiDailyLimitError: aiDailyLimitError,
      aiDailyLimitData: aiDailyLimitData == _sentinel
          ? this.aiDailyLimitData
          : aiDailyLimitData as AiGenerationDailyLimitDataEntity?,
    );
  }

  String get aiAttemptsLabel {
    return aiDailyLimitData?.attemptsLabel ?? '-/-';
  }

  bool get hasReachedAiDailyLimit {
    return aiDailyLimitData?.hasReachedDailyLimit ?? false;
  }
}

const Object _sentinel = Object();
