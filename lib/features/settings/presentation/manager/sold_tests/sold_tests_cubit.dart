import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/settings/data/services/sold_tests_pdf_service.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/sold_tests_entity.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/fetch_sold_tests_use_case.dart';
import 'package:quiz_app_grad/features/settings/domain/use_cases/params/fetch_sold_tests_params.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/sold_tests/sold_tests_state.dart';

class SoldTestsCubit extends Cubit<SoldTestsState> {
  final FetchSoldTestsUseCase fetchSoldTestsUseCase;

  final SoldTestsPdfService soldTestsPdfService;

  SoldTestsCubit({
    required this.fetchSoldTestsUseCase,
    required this.soldTestsPdfService,
  }) : super(const SoldTestsState()) {
    debugPrint('============ SoldTestsCubit INIT ============');
  }

  Future<void> fetchInitial() async {
    debugPrint('============ SoldTestsCubit.fetchInitial ============');
    debugPrint('→ tab: ${state.selectedTab.apiValue}');

    emit(
      state.copyWith(
        isLoading: true,
        sales: const [],
        filteredSales: const [],
        clearStats: true,
        clearError: true,
      ),
    );

    final result = await fetchSoldTestsUseCase(
      FetchSoldTestsParams(tab: state.selectedTab.apiValue),
    );

    result.fold(
      (failure) {
        debugPrint('✗ title: ${failure.title}');
        debugPrint('✗ message: ${failure.message}');

        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final filteredSales = _applySearch(
          sales: response.sales,
          query: state.searchQuery,
        );

        debugPrint('√ totalSalesCount: ${response.stats.totalSalesCount}');
        debugPrint(
          '√ totalSellerNetAmountSyp: '
          '${response.stats.totalSellerNetAmountSyp}',
        );
        debugPrint('√ sales count: ${response.sales.length}');

        emit(
          state.copyWith(
            isLoading: false,
            stats: response.stats,
            sales: response.sales,
            filteredSales: filteredSales,
            clearError: true,
          ),
        );
      },
    );

    debugPrint('=================================================');
  }

  Future<void> changeTab(SoldTestsTab tab) async {
    if (state.selectedTab == tab) return;

    debugPrint('============ SoldTestsCubit.changeTab ============');
    debugPrint('→ from: ${state.selectedTab.apiValue}');
    debugPrint('→ to: ${tab.apiValue}');

    emit(state.copyWith(selectedTab: tab, searchQuery: '', clearError: true));

    await fetchInitial();
  }

  void search(String value) {
    debugPrint('============ SoldTestsCubit.search ============');
    debugPrint('→ query: $value');

    final filteredSales = _applySearch(sales: state.sales, query: value);

    debugPrint('√ visible sales count: ${filteredSales.length}');
    debugPrint('=================================================');

    emit(state.copyWith(searchQuery: value, filteredSales: filteredSales));
  }

  void clearSearch() {
    if (state.searchQuery.isEmpty) return;

    debugPrint('============ SoldTestsCubit.clearSearch ============');

    emit(state.copyWith(searchQuery: '', filteredSales: state.sales));

    debugPrint('√ search cleared');
    debugPrint('=================================================');
  }

  Future<void> refresh() async {
    debugPrint('============ SoldTestsCubit.refresh ============');

    await fetchInitial();
  }

  List<SoldTestSaleEntity> _applySearch({
    required List<SoldTestSaleEntity> sales,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return List<SoldTestSaleEntity>.from(sales);
    }

    return sales.where((sale) {
      final buyerName = sale.purchase.buyerName.toLowerCase();

      final testTitle = sale.test.title.toLowerCase();

      final description = sale.test.description.toLowerCase();

      final targetLevel = sale.test.targetLevel.toLowerCase();

      final interests = sale.test.interests.join(' ').toLowerCase();

      return buyerName.contains(normalizedQuery) ||
          testTitle.contains(normalizedQuery) ||
          description.contains(normalizedQuery) ||
          targetLevel.contains(normalizedQuery) ||
          interests.contains(normalizedQuery);
    }).toList();
  }

  ////////////////// download sold test
  Future<void> downloadSoldTestsPdf() async {
    debugPrint('============ SoldTestsCubit.downloadSoldTestsPdf ============');

    if (state.isPdfLoading) {
      debugPrint('→ PDF generation already in progress');
      debugPrint('=================================================');
      return;
    }

    emit(
      state.copyWith(
        pdfStatus: SoldTestsPdfStatus.loading,
        clearGeneratedSoldTestsPdfPath: true,
        clearPdfError: true,
      ),
    );

    debugPrint('→ fetching all sold tests');
    debugPrint('→ tab: ${SoldTestsTab.all.apiValue}');

    final result = await fetchSoldTestsUseCase(
      FetchSoldTestsParams(tab: SoldTestsTab.all.apiValue),
    );

    await result.fold(
      (failure) async {
        debugPrint('✗ title: ${failure.title}');
        debugPrint('✗ message: ${failure.message}');

        emit(
          state.copyWith(
            pdfStatus: SoldTestsPdfStatus.failure,
            pdfErrorTitle: failure.title,
            pdfErrorMessage: failure.message,
            clearGeneratedSoldTestsPdfPath: true,
          ),
        );
      },
      (response) async {
        debugPrint('√ all sales fetched: ${response.sales.length}');

        try {
          final filePath = await soldTestsPdfService.generateSoldTestsPdf(
            report: response,
          );

          debugPrint('√ PDF generated successfully');
          debugPrint('√ filePath: $filePath');

          emit(
            state.copyWith(
              pdfStatus: SoldTestsPdfStatus.success,
              generatedSoldTestsPdfPath: filePath,
              clearPdfError: true,
            ),
          );
        } catch (error, stackTrace) {
          debugPrint('✗ generateSoldTestsPdf error: $error');
          debugPrint('✗ stackTrace: $stackTrace');

          emit(
            state.copyWith(
              pdfStatus: SoldTestsPdfStatus.failure,
              pdfErrorTitle: 'خطأ',
              pdfErrorMessage: 'تعذر إنشاء تقرير المبيعات',
              clearGeneratedSoldTestsPdfPath: true,
            ),
          );
        }
      },
    );

    debugPrint('=================================================');
  }

  void resetSoldTestsPdfState() {
    debugPrint(
      '============ SoldTestsCubit.resetSoldTestsPdfState ============',
    );

    emit(
      state.copyWith(
        pdfStatus: SoldTestsPdfStatus.initial,
        clearGeneratedSoldTestsPdfPath: true,
        clearPdfError: true,
      ),
    );

    debugPrint('√ PDF state reset');
    debugPrint('=================================================');
  }
}
