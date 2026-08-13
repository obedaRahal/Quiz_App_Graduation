import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/purchased_tests_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/fetch_purchased_tests_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_purchased_tests_params.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/purchased_tests/purchased_tests_state.dart';

class PurchasedTestsCubit extends SafeCubit<PurchasedTestsState> {
  final FetchPurchasedTestsUseCase fetchPurchasedTestsUseCase;
  int _requestGeneration = 0;

  PurchasedTestsCubit({required this.fetchPurchasedTestsUseCase})
    : super(const PurchasedTestsState());

  Future<void> fetchInitial() async {
    final requestGeneration = ++_requestGeneration;
    final selectedTab = state.selectedTab;

    emit(
      state.copyWith(
        isLoading: true,
        tests: const [],
        filteredTests: const [],
        clearError: true,
      ),
    );

    final result = await fetchPurchasedTestsUseCase(
      FetchPurchasedTestsParams(tab: selectedTab.apiValue),
    );

    if (isClosed || requestGeneration != _requestGeneration) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final filteredTests = _applySearch(
          tests: response.tests,
          query: state.searchQuery,
        );

        emit(
          state.copyWith(
            isLoading: false,
            tests: response.tests,
            filteredTests: filteredTests,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> changeTab(PurchasedTestsTab tab) async {
    if (state.selectedTab == tab) return;

    emit(
      state.copyWith(
        selectedTab: tab,
        searchQuery: '',
        clearError: true,
      ),
    );

    await fetchInitial();
  }

  void search(String value) {
    emit(
      state.copyWith(
        searchQuery: value,
        filteredTests: _applySearch(tests: state.tests, query: value),
      ),
    );
  }

  void clearSearch() {
    if (state.searchQuery.isEmpty) return;

    emit(state.copyWith(searchQuery: '', filteredTests: state.tests));
  }

  Future<void> refresh() => fetchInitial();

  List<PurchasedTestEntity> _applySearch({
    required List<PurchasedTestEntity> tests,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return List<PurchasedTestEntity>.from(tests);

    return tests.where((test) {
      return test.title.toLowerCase().contains(normalizedQuery) ||
          test.description.toLowerCase().contains(normalizedQuery) ||
          test.interests.join(' ').toLowerCase().contains(normalizedQuery) ||
          test.difficultyLevel.toLowerCase().contains(normalizedQuery);
    }).toList();
  }
}
