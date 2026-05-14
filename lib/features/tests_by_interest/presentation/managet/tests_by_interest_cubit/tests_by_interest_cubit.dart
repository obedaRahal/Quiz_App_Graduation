import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/tests_by_interest/domain/use_cases/get_tests_by_interest_use_case.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/managet/tests_by_interest_cubit/tests_by_interest_state.dart';

class TestsByInterestCubit extends Cubit<TestsByInterestState> {
  final GetTestsByInterestUseCase getTestsByInterestUseCase;

  TestsByInterestCubit({required this.getTestsByInterestUseCase})
    : super(const TestsByInterestState());

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

  Future<void> loadMoreTests({required int interestId}) async {
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
}
