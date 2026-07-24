import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';

enum SoldTestsTab { all, today, week, month }

extension SoldTestsTabX on SoldTestsTab {
  String get apiValue {
    switch (this) {
      case SoldTestsTab.all:
        return 'all';

      case SoldTestsTab.today:
        return 'today';

      case SoldTestsTab.week:
        return 'week';

      case SoldTestsTab.month:
        return 'month';
    }
  }

  String get title {
    switch (this) {
      case SoldTestsTab.all:
        return 'الكل';

      case SoldTestsTab.today:
        return 'اليوم';

      case SoldTestsTab.week:
        return 'منذ أسبوع';

      case SoldTestsTab.month:
        return 'منذ شهر';
    }
  }
}

class SoldTestsState {
  final SoldTestsTab selectedTab;

  final bool isLoading;

  final SoldTestsStatsEntity? stats;

  final List<SoldTestSaleEntity> sales;
  final List<SoldTestSaleEntity> filteredSales;

  final String searchQuery;

  final String? errorTitle;
  final String? errorMessage;

  const SoldTestsState({
    this.selectedTab = SoldTestsTab.all,
    this.isLoading = false,
    this.stats,
    this.sales = const [],
    this.filteredSales = const [],
    this.searchQuery = '',
    this.errorTitle,
    this.errorMessage,
  });

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  bool get isSearching {
    return searchQuery.trim().isNotEmpty;
  }

  List<SoldTestSaleEntity> get visibleSales {
    return filteredSales;
  }

  SoldTestsState copyWith({
    SoldTestsTab? selectedTab,
    bool? isLoading,
    SoldTestsStatsEntity? stats,
    bool clearStats = false,
    List<SoldTestSaleEntity>? sales,
    List<SoldTestSaleEntity>? filteredSales,
    String? searchQuery,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SoldTestsState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      stats: clearStats ? null : stats ?? this.stats,
      sales: sales ?? this.sales,
      filteredSales: filteredSales ?? this.filteredSales,
      searchQuery: searchQuery ?? this.searchQuery,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
