import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';

enum SoldTestsTab { all, today, week, month }

enum SoldTestsPdfStatus { initial, loading, success, failure }

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

  final SoldTestsPdfStatus pdfStatus;

  final String? generatedSoldTestsPdfPath;

  final String? pdfErrorTitle;
  final String? pdfErrorMessage;

  const SoldTestsState({
    this.selectedTab = SoldTestsTab.all,
    this.isLoading = false,
    this.stats,
    this.sales = const [],
    this.filteredSales = const [],
    this.searchQuery = '',
    this.errorTitle,
    this.errorMessage,

    this.pdfStatus = SoldTestsPdfStatus.initial,
    this.generatedSoldTestsPdfPath,
    this.pdfErrorTitle,
    this.pdfErrorMessage,
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

  bool get isPdfLoading {
    return pdfStatus == SoldTestsPdfStatus.loading;
  }

  bool get isPdfSuccess {
    return pdfStatus == SoldTestsPdfStatus.success;
  }

  bool get isPdfFailure {
    return pdfStatus == SoldTestsPdfStatus.failure;
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

    SoldTestsPdfStatus? pdfStatus,
    String? generatedSoldTestsPdfPath,
    bool clearGeneratedSoldTestsPdfPath = false,
    String? pdfErrorTitle,
    String? pdfErrorMessage,
    bool clearPdfError = false,
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

      pdfStatus: pdfStatus ?? this.pdfStatus,
      generatedSoldTestsPdfPath: clearGeneratedSoldTestsPdfPath
          ? null
          : generatedSoldTestsPdfPath ?? this.generatedSoldTestsPdfPath,
      pdfErrorTitle: clearPdfError ? null : pdfErrorTitle ?? this.pdfErrorTitle,
      pdfErrorMessage: clearPdfError
          ? null
          : pdfErrorMessage ?? this.pdfErrorMessage,
    );
  }
}
