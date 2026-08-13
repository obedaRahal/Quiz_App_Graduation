import 'package:quiz_app_grad/features/settings/domain/entity/purchased_tests_entity.dart';

enum PurchasedTestsTab { today, month, older }

extension PurchasedTestsTabX on PurchasedTestsTab {
  String get apiValue => switch (this) {
    PurchasedTestsTab.today => 'today',
    PurchasedTestsTab.month => 'month',
    PurchasedTestsTab.older => 'older',
  };
}

class PurchasedTestsState {
  final PurchasedTestsTab selectedTab;
  final bool isLoading;
  final List<PurchasedTestEntity> tests;
  final List<PurchasedTestEntity> filteredTests;
  final String searchQuery;
  final String? errorTitle;
  final String? errorMessage;

  const PurchasedTestsState({
    this.selectedTab = PurchasedTestsTab.today,
    this.isLoading = false,
    this.tests = const [],
    this.filteredTests = const [],
    this.searchQuery = '',
    this.errorTitle,
    this.errorMessage,
  });

  bool get hasError => errorMessage?.trim().isNotEmpty == true;
  bool get isSearching => searchQuery.trim().isNotEmpty;

  PurchasedTestsState copyWith({
    PurchasedTestsTab? selectedTab,
    bool? isLoading,
    List<PurchasedTestEntity>? tests,
    List<PurchasedTestEntity>? filteredTests,
    String? searchQuery,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PurchasedTestsState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      tests: tests ?? this.tests,
      filteredTests: filteredTests ?? this.filteredTests,
      searchQuery: searchQuery ?? this.searchQuery,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
