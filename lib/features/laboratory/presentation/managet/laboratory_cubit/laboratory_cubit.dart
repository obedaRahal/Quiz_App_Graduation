import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/domain/use_case/search_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/managet/laboratory_cubit/laboratory_state.dart';

class LaboratoryCubit extends Cubit<LaboratoryState> {
  final GetTestsByInterestUseCase getTestsByInterestUseCase;
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounce;
  bool _isFetchingSearchMore = false;
  final SearchTestsByInterestUseCase searchTestsByInterestUseCase;
  bool _isFetchingMore = false;
  LaboratoryCubit({
    required this.getTestsByInterestUseCase,
    required this.searchTestsByInterestUseCase,
  }) : super(const LaboratoryState());

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    scrollController.dispose();
    return super.close();
  }

  Future<void> getInitialExamSessions({required int interestId}) async {
    emit(
      state.copyWith(
        isInitialLoading: true,
        isLoadingMore: false,
        error: null,
        examSessions: [],
        currentPage: 1,
        hasMorePages: true,
        selectedInterestId: interestId,
      ),
    );

    try {
      final response = await getTestsByInterestUseCase(
        interestId: interestId,
        page: 1,
      );
      debugPrint('INITIAL PAGE LOADED => ${response.meta.currentPage}');
      debugPrint('INITIAL ITEMS => ${response.tests.length}');
      debugPrint('HAS MORE => ${response.meta.hasMorePages}');
      emit(
        state.copyWith(
          isInitialLoading: false,
          examSessions: response.tests,
          currentPage: response.meta.currentPage,
          hasMorePages: response.meta.hasMorePages,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isInitialLoading: false, error: e.toString()));
    }
  }

  Future<void> getNextExamSessionsPage() async {
    if (_isFetchingMore) return;
    if (state.isInitialLoading || state.isLoadingMore) return;
    if (!state.hasMorePages) return;
    if (state.selectedInterestId == null) return;

    _isFetchingMore = true;

    emit(state.copyWith(isLoadingMore: true, error: null));

    try {
      final nextPage = state.currentPage + 1;

      debugPrint('LOADING PAGE => $nextPage');

      final response = await getTestsByInterestUseCase(
        interestId: state.selectedInterestId!,
        page: nextPage,
      );

      emit(
        state.copyWith(
          isLoadingMore: false,
          examSessions: [...state.examSessions, ...response.tests],
          currentPage: response.meta.currentPage,
          hasMorePages: response.meta.hasMorePages,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    } finally {
      _isFetchingMore = false;
    }
  }

  void initScrollListener() {
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final position = scrollController.position;

      if (position.pixels >= position.maxScrollExtent * 0.80) {
        if (state.isSearchMode && state.searchQuery.trim().isNotEmpty) {
          getNextSearchPage();
        } else {
          getNextExamSessionsPage();
        }
      }
    });
  }

  void enterSearchMode() {
    if (state.isSearchMode) return;

    emit(state.copyWith(isSearchMode: true, searchError: null));
  }

  Future<void> exitSearchMode() async {
    _searchDebounce?.cancel();

    emit(
      state.copyWith(
        isSearchMode: false,
        isSearchLoading: false,
        isSearchLoadingMore: false,
        searchError: null,
        searchQuery: '',
        searchResults: [],
        searchCurrentPage: 1,
        searchHasMorePages: true,
      ),
    );
  }

  void onSearchChanged(String value) {
    final query = value.trim();

    emit(
      state.copyWith(isSearchMode: true, searchQuery: query, searchError: null),
    );

    _searchDebounce?.cancel();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          isSearchMode: false,
          isSearchLoading: false,
          isSearchLoadingMore: false,
          searchResults: [],
          searchCurrentPage: 1,
          searchHasMorePages: true,
          searchError: null,
        ),
      );

      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      searchExamSessions(page: 1, reset: true);
    });
  }

  Future<void> searchExamSessions({
    required int page,
    required bool reset,
  }) async {
    // if (state.selectedInterestId == null) return;
    if (state.searchQuery.trim().isEmpty) return;

    if (reset) {
      emit(
        state.copyWith(
          isSearchLoading: true,
          isSearchLoadingMore: false,
          searchError: null,
          searchResults: [],
          searchCurrentPage: 1,
          searchHasMorePages: true,
        ),
      );
    } else {
      if (_isFetchingSearchMore) return;
      if (state.isSearchLoadingMore || !state.searchHasMorePages) return;

      _isFetchingSearchMore = true;

      emit(state.copyWith(isSearchLoadingMore: true, searchError: null));
    }

    try {
      final response = await searchTestsByInterestUseCase(
        query: state.searchQuery,
        page: page,
        perPage: 20,
      );
      debugPrint('SEARCH PAGE => ${response.meta.currentPage}');
      debugPrint('SEARCH ITEMS => ${response.tests.length}');
      debugPrint('SEARCH HAS MORE => ${response.meta.hasMorePages}');
      emit(
        state.copyWith(
          isSearchLoading: false,
          isSearchLoadingMore: false,
          searchResults: reset
              ? response.tests
              : [...state.searchResults, ...response.tests],
          searchCurrentPage: response.meta.currentPage,
          searchHasMorePages: response.meta.hasMorePages,
          searchError: null,
        ),
      );
      final totalItems = reset
          ? response.tests.length
          : state.searchResults.length + response.tests.length;

      debugPrint('TOTAL SEARCH RESULTS => $totalItems');
    } catch (e) {
      emit(
        state.copyWith(
          isSearchLoading: false,
          isSearchLoadingMore: false,
          searchError: e.toString(),
        ),
      );
    } finally {
      _isFetchingSearchMore = false;
    }
  }

  Future<void> getNextSearchPage() async {
    if (!state.isSearchMode) return;
    if (state.searchQuery.trim().isEmpty) return;
    if (!state.searchHasMorePages) return;

    await searchExamSessions(page: state.searchCurrentPage + 1, reset: false);
  }
}
