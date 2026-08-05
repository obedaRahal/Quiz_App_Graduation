import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/sold_tests/sold_tests_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/sold_tests/sold_tests_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_test_sale_card.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_filter_section.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_search_field.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_stats_section.dart';

class SoldTestsViewBody extends StatefulWidget {
  const SoldTestsViewBody({super.key});

  @override
  State<SoldTestsViewBody> createState() => _SoldTestsViewBodyState();
}

class _SoldTestsViewBodyState extends State<SoldTestsViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});

    context.read<SoldTestsCubit>().search(value);
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {});

    context.read<SoldTestsCubit>().clearSearch();
  }

  void _onTabSelected(SoldTestsTab tab) {
    _searchController.clear();

    setState(() {});

    context.read<SoldTestsCubit>().changeTab(tab);
  }

  Future<void> _openGeneratedPdf(String filePath) async {
    debugPrint('============ SoldTestsViewBody._openGeneratedPdf ============');
    debugPrint('→ filePath: $filePath');

    final result = await OpenFilex.open(filePath);

    debugPrint('√ result type: ${result.type}');
    debugPrint('√ result message: ${result.message}');
    debugPrint('=================================================');
  }

  void _listenToPdfState(BuildContext context, SoldTestsState state) {
    if (state.isPdfSuccess) {
      final filePath = state.generatedSoldTestsPdfPath;

      debugPrint('============ SoldTestsViewBody PDF SUCCESS ============');
      debugPrint('√ filePath: $filePath');
      debugPrint('=================================================');

      final hasValidFilePath = filePath != null && filePath.trim().isNotEmpty;

      showValidationTopSnackBar(
        context,
        title: 'تم إنشاء التقرير',
        message: 'تم حفظ تقرير المبيعات بنجاح',
        type: AppValidationSnackBarType.success,
        actionText: hasValidFilePath ? 'فتح التقرير' : null,
        onActionTap: hasValidFilePath
            ? () {
                _openGeneratedPdf(filePath);
              }
            : null,
        displayDuration: const Duration(seconds: 6),
      );

      context.read<SoldTestsCubit>().resetSoldTestsPdfState();

      return;
    }

    if (state.isPdfFailure) {
      debugPrint('============ SoldTestsViewBody PDF FAILURE ============');
      debugPrint('✗ title: ${state.pdfErrorTitle}');
      debugPrint('✗ message: ${state.pdfErrorMessage}');
      debugPrint('=================================================');

      showValidationTopSnackBar(
        context,
        title: state.pdfErrorTitle?.trim().isNotEmpty == true
            ? state.pdfErrorTitle!
            : 'تعذر إنشاء التقرير',
        message: state.pdfErrorMessage?.trim().isNotEmpty == true
            ? state.pdfErrorMessage!
            : 'تعذر إنشاء تقرير المبيعات، حاول مرة أخرى',
        type: AppValidationSnackBarType.error,
        displayDuration: const Duration(seconds: 5),
      );

      context.read<SoldTestsCubit>().resetSoldTestsPdfState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SoldTestsCubit, SoldTestsState>(
      listenWhen: (previous, current) {
        return previous.pdfStatus != current.pdfStatus;
      },
      listener: _listenToPdfState,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SoldTestsHeader(),

              SizedBox(height: SizeConfig.h(0.012)),

              BlocBuilder<SoldTestsCubit, SoldTestsState>(
                buildWhen: (previous, current) {
                  return previous.selectedTab != current.selectedTab;
                },
                builder: (context, state) {
                  return SoldTestsFilterSection(
                    selectedTab: state.selectedTab,
                    onTabSelected: _onTabSelected,
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.015)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: SoldTestsSearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: _clearSearch,
                ),
              ),

              SizedBox(height: SizeConfig.h(0.015)),

              Expanded(
                child: BlocBuilder<SoldTestsCubit, SoldTestsState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.hasError) {
                      return _FailureBody(
                        message:
                            state.errorMessage ?? 'تعذر جلب الاختبارات المباعة',
                        onRetry: () {
                          context.read<SoldTestsCubit>().fetchInitial();
                        },
                      );
                    }

                    if (state.stats != null) {
                      return RefreshIndicator(
                        onRefresh: () {
                          return context.read<SoldTestsCubit>().refresh();
                        },
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: SoldTestsStatsSection(stats: state.stats!),
                            ),

                            SliverToBoxAdapter(
                              child: SizedBox(height: SizeConfig.h(0.018)),
                            ),

                            if (state.visibleSales.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: _EmptyBody(
                                  isSearching: state.isSearching,
                                ),
                              )
                            else
                              SliverPadding(
                                padding: EdgeInsets.only(
                                  left: SizeConfig.w(0.03),
                                  right: SizeConfig.w(0.03),
                                  bottom: SizeConfig.h(0.02),
                                ),
                                sliver: SliverList.separated(
                                  itemCount: state.visibleSales.length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: SizeConfig.h(0.014),
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final sale = state.visibleSales[index];

                                    return SoldTestSaleCard(sale: sale);
                                  },
                                ),
                              ),
                          ],
                        ),
                      );
                    }

                    return const _EmptyBody(isSearching: false);
                  },
                ),
              ),
              BlocBuilder<SoldTestsCubit, SoldTestsState>(
                buildWhen: (previous, current) {
                  return previous.pdfStatus != current.pdfStatus;
                },
                builder: (context, state) {
                  return CustomBackgroundWithChild(
                    childVerticalPad: SizeConfig.h(0.01),
                    childHorizontalPad: SizeConfig.w(0.03),
                    backgroundColor: context.appColors.whiteToblack,
                    width: double.infinity,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? AppPalette.greyMediumDark
                            : AppPalette.greyBorderCart,
                        blurRadius: 4,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    child: CustomButtonWidget(
                      width: double.infinity,
                      backgroundColor: context.appColors.primaryToPrimaryDark,
                      childHorizontalPad: SizeConfig.w(0.04),
                      childVerticalPad: SizeConfig.w(0.013),
                      borderRadius: 6,
                      onTap: state.isPdfLoading
                          ? () {}
                          : () {
                              debugPrint(
                                '============ SoldTestsViewBody.downloadPdf ============',
                              );

                              context
                                  .read<SoldTestsCubit>()
                                  .downloadSoldTestsPdf();
                            },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state.isPdfLoading
                            ? Row(
                                key: const ValueKey('pdf-loading'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.text(0.034),
                                    height: SizeConfig.text(0.034),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: context.appColors.whiteToblack,
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.w(0.025)),
                                  CustomTextWidget(
                                    'جارٍ إنشاء التقرير...',
                                    fontSize: SizeConfig.text(0.03),
                                    color: context.appColors.whiteToblack,
                                  ),
                                ],
                              )
                            : Row(
                                key: const ValueKey('pdf-download'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.download_outlined,
                                    color: context.appColors.whiteToblack,
                                    size: SizeConfig.text(0.048),
                                  ),
                                  SizedBox(width: SizeConfig.w(0.02)),
                                  CustomTextWidget(
                                    'تنزيل تقرير المبيعات',
                                    fontSize: SizeConfig.text(0.03),
                                    color: context.appColors.whiteToblack,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FailureBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FailureBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppPalette.greyMedium,
              size: SizeConfig.text(0.12),
            ),
            SizedBox(height: SizeConfig.h(0.012)),
            CustomTextWidget(
              message,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
              fontSize: SizeConfig.text(0.035),
            ),
            SizedBox(height: SizeConfig.h(0.018)),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  final bool isSearching;

  const _EmptyBody({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        child: EmptyActionBox(
          icon: isSearching
              ? Icons.search_off_rounded
              : Icons.shopping_bag_outlined,
          title: isSearching ? 'لا توجد نتائج' : 'لا توجد اختبارات مباعة',
          description: isSearching
              ? 'لم نعثر على اختبارات مباعة مطابقة لبحثك'
              : 'ستظهر هنا الاختبارات بعد إتمام أول عملية بيع',
        ),
      ),
    );
  }
}
