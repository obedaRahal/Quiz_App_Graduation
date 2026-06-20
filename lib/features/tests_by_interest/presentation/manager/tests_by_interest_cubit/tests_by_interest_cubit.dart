import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/use_cases/search_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/use_cases/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/manager/tests_by_interest_cubit/tests_by_interest_state.dart';

class TestsByInterestCubit extends Cubit<TestsByInterestState> {
  Timer? _searchDebounce;
  final GetTestsByInterestUseCase getTestsByInterestUseCase;
  final SearchTestsByInterestUseCase searchTestsByInterestUseCase;
 TestsByInterestCubit({
  required this.getTestsByInterestUseCase,
  required this.searchTestsByInterestUseCase,
}) : super(const TestsByInterestState());

  Future<void> getTestsByInterest({required int interestId}) async {
    emit(
      state.copyWith(
        isInitialLoading: true,
        isLoadingMore: false,
        tests: [],
        currentPage: 1,
        lastPage: 1,
        hasMorePages: false,
        clearErrorMessage: true,
        clearLoadMoreErrorMessage: true,
      ),
    );

    try {
      final response = await getTestsByInterestUseCase(
        interestId: interestId,
        page: 1,
      );
      debugPrint('interestId => $interestId');
      emit(
        state.copyWith(
          isInitialLoading: false,
          tests: response.tests,
          currentPage: response.meta.currentPage,
          lastPage: response.meta.lastPage,
          hasMorePages: response.meta.hasMorePages,
          clearErrorMessage: true,
        ),
      );
    } catch (e,stackTrace) {
      debugPrint('Get tests by interest error: $e');
  debugPrint('StackTrace: $stackTrace');

      emit(state.copyWith(isInitialLoading: false, errorMessage: e.toString()));
    }
  }

  // Future<void> loadMoreTests({required int interestId}) async {
  //   if (state.isInitialLoading || state.isLoadingMore || !state.hasMorePages) {
  //     return;
  //   }

  //   final nextPage = state.currentPage + 1;

  //   emit(state.copyWith(isLoadingMore: true, clearLoadMoreErrorMessage: true));

  //   try {
  //     final response = await getTestsByInterestUseCase(
  //       interestId: interestId,
  //       page: nextPage,
  //     );

  //     emit(
  //       state.copyWith(
  //         isLoadingMore: false,
  //         tests: [...state.tests, ...response.tests],
  //         currentPage: response.meta.currentPage,
  //         lastPage: response.meta.lastPage,
  //         hasMorePages: response.meta.hasMorePages,
  //         clearLoadMoreErrorMessage: true,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         isLoadingMore: false,
  //         loadMoreErrorMessage: e.toString(),
  //       ),
  //     );
  //   }
  // }
Future<void> loadMoreTests({required int interestId}) async {
  if (state.isSearchMode) {
    await loadMoreSearchResults(interestId: interestId);
    return;
  }

  if (state.isInitialLoading || state.isLoadingMore || !state.hasMorePages) {
    return;
  }

  final nextPage = state.currentPage + 1;

  emit(state.copyWith(isLoadingMore: true, clearLoadMoreErrorMessage: true));

  try {
    final response = await getTestsByInterestUseCase(
      interestId: interestId,
      page: nextPage,
    );

    emit(
      state.copyWith(
        isLoadingMore: false,
        tests: [...state.tests, ...response.tests],
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        hasMorePages: response.meta.hasMorePages,
        clearLoadMoreErrorMessage: true,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        isLoadingMore: false,
        loadMoreErrorMessage: e.toString(),
      ),
    );
  }
}
  Future<void> refreshTests({required int interestId}) async {
    await getTestsByInterest(interestId: interestId);
  }
  void searchTests({
  required int interestId,
  required String query,
}) {
  _searchDebounce?.cancel();

  final trimmedQuery = query.trim();

  if (trimmedQuery.isEmpty) {
    clearSearch();
    return;
  }

  emit(
    state.copyWith(
      isSearchMode: true,
      searchQuery: trimmedQuery,
      isSearchLoading: true,
      searchResults: [],
      searchCurrentPage: 1,
      searchLastPage: 1,
      searchHasMorePages: false,
      clearSearchErrorMessage: true,
      clearSearchLoadMoreErrorMessage: true,
    ),
  );

  _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
    await _performSearch(
      interestId: interestId,
      query: trimmedQuery,
      page: 1,
    );
  });
}

Future<void> _performSearch({
  required int interestId,
  required String query,
  required int page,
}) async {
  try {
    final response = await searchTestsByInterestUseCase(
      interestId: interestId,
      query: query,
      page: page,
      perPage: 10,
    );

    emit(
      state.copyWith(
        isSearchMode: true,
        isSearchLoading: false,
        searchResults: response.tests,
        searchCurrentPage: response.meta.currentPage,
        searchLastPage: response.meta.lastPage,
        searchHasMorePages: response.meta.hasMorePages,
        clearSearchErrorMessage: true,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        isSearchLoading: false,
        searchErrorMessage: e.toString(),
      ),
    );
  }
}

Future<void> loadMoreSearchResults({
  required int interestId,
}) async {
  if (!state.isSearchMode ||
      state.isSearchLoading ||
      state.isSearchLoadingMore ||
      !state.searchHasMorePages ||
      state.searchQuery.trim().isEmpty) {
    return;
  }

  final nextPage = state.searchCurrentPage + 1;

  emit(
    state.copyWith(
      isSearchLoadingMore: true,
      clearSearchLoadMoreErrorMessage: true,
    ),
  );

  try {
    final response = await searchTestsByInterestUseCase(
      interestId: interestId,
      query: state.searchQuery,
      page: nextPage,
      perPage: 10,
    );

    emit(
      state.copyWith(
        isSearchLoadingMore: false,
        searchResults: [
          ...state.searchResults,
          ...response.tests,
        ],
        searchCurrentPage: response.meta.currentPage,
        searchLastPage: response.meta.lastPage,
        searchHasMorePages: response.meta.hasMorePages,
        clearSearchLoadMoreErrorMessage: true,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        isSearchLoadingMore: false,
        searchLoadMoreErrorMessage: e.toString(),
      ),
    );
  }
}

void clearSearch() {
  _searchDebounce?.cancel();

  emit(
    state.copyWith(
      isSearchMode: false,
      isSearchLoading: false,
      isSearchLoadingMore: false,
      searchQuery: '',
      searchResults: [],
      searchCurrentPage: 1,
      searchLastPage: 1,
      searchHasMorePages: false,
      clearSearchErrorMessage: true,
      clearSearchLoadMoreErrorMessage: true,
    ),
  );
}

@override
Future<void> close() {
  _searchDebounce?.cancel();
  return super.close();
}
}
