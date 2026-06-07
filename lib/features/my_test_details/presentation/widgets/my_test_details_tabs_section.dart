import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/review_tab_shimmer.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_overview_tab.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_review_tab.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_status_tab.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/show_my_test_revision_bottom_sheet.dart';

class MyTestDetailsTabsSection extends StatelessWidget {
  final int testId;
  final MyPublicTestDetailsOverviewEntity overview;

  const MyTestDetailsTabsSection({
    super.key,
    required this.testId,
    required this.overview,
  });

  static const tabs = [
    _MyTestTabItem(title: 'نظرة عامة', tab: MyTestDetailsTab.overview),
    _MyTestTabItem(title: 'سجل الحالة', tab: MyTestDetailsTab.status),
    _MyTestTabItem(title: 'المراجعات', tab: MyTestDetailsTab.reviews),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
        buildWhen: (previous, current) =>
            previous.selectedTab != current.selectedTab,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _TabsHeader(
                selectedTab: state.selectedTab,
                onTabSelected: context
                    .read<MyTestDetailsCubit>()
                    .changeSelectedTab,
              ),

              SizedBox(height: SizeConfig.h(0.025)),

              _TabContent(
                testId: testId,
                selectedTab: state.selectedTab,
                overview: overview,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MyTestTabItem {
  final String title;
  final MyTestDetailsTab tab;

  const _MyTestTabItem({required this.title, required this.tab});
}

class _TabsHeader extends StatelessWidget {
  final MyTestDetailsTab selectedTab;
  final ValueChanged<MyTestDetailsTab> onTabSelected;

  const _TabsHeader({required this.selectedTab, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomDivider(height: 3, thickness: 3),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: MyTestDetailsTabsSection.tabs.map((item) {
              final isSelected = selectedTab == item.tab;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTabSelected(item.tab),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      item.title,
                      color: isSelected
                          ? appColors.blackToGrey2Dark
                          : AppPalette.greyMedium,
                      fontFamily: isSelected
                          ? AppFont.elMessiriSemiBold
                          : AppFont.elMessiriRegular,
                      fontSize: SizeConfig.text(0.032),
                    ),
                    SizedBox(height: SizeConfig.h(0.006)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      height: 3.5,
                      width: isSelected ? SizeConfig.w(0.14) : 0,
                      decoration: BoxDecoration(
                        color: appColors.primaryToPrimaryDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TabContent extends StatelessWidget {
  final int testId;
  final MyTestDetailsTab selectedTab;
  final MyPublicTestDetailsOverviewEntity overview;

  const _TabContent({
    required this.testId,
    required this.selectedTab,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case MyTestDetailsTab.overview:
        return MyTestOverviewTab(overview: overview);
      case MyTestDetailsTab.status:
        return _StatusTabBlocContent(testId: testId);
      case MyTestDetailsTab.reviews:
        return _ReviewsTabBlocContent(testId: testId);
    }
  }
}

class _StatusTabBlocContent extends StatefulWidget {
  final int testId;

  const _StatusTabBlocContent({required this.testId});

  @override
  State<_StatusTabBlocContent> createState() => _StatusTabBlocContentState();
}

class _StatusTabBlocContentState extends State<_StatusTabBlocContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyTestDetailsCubit>().getMyPublicTestStatusHistory(
        testId: widget.testId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTestDetailsCubit, MyTestDetailsState>(
      listenWhen: (previous, current) =>
          previous.modificationsStatus != current.modificationsStatus,
      listener: (context, state) {
        if (state.isModificationsSuccess) {
          final modifications = state.modificationsDetails?.data ?? [];

          showTestModificationBottomSheet(
            context: context,
            items: modifications,
          );

          context.read<MyTestDetailsCubit>().resetMyTestModificationsState();
        }

        if (state.isModificationsFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر جلب قائمة التعديلات',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyTestDetailsCubit>().resetMyTestModificationsState();
        }
      },
      buildWhen: (previous, current) =>
          previous.statusHistoryStatus != current.statusHistoryStatus ||
          previous.statusHistoryDetails != current.statusHistoryDetails ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isStatusHistoryLoading) {
          return const _StatusHistoryLoadingView();
        }
        if (state.isStatusHistoryFailure) {
          return Center(
            child: CustomTextWidget(
              state.errorMessage ?? 'حدث خطأ أثناء جلب سجل الحالات',
              color: AppPalette.red,
              textAlign: TextAlign.center,
            ),
          );
        }
        final statusHistory = state.statusHistoryDetails;

        if (statusHistory == null || statusHistory.data.isEmpty) {
          return Center(
            child: CustomTextWidget(
              'لا يوجد سجل حالات متاح لهذا الاختبار',
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        return MyTestStatusTab(
          statusHistory: statusHistory,
          testId: widget.testId,
        );
      },
    );
  }
}

class _StatusHistoryLoadingView extends StatelessWidget {
  const _StatusHistoryLoadingView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ReviewsTabBlocContent extends StatefulWidget {
  final int testId;

  const _ReviewsTabBlocContent({required this.testId});

  @override
  State<_ReviewsTabBlocContent> createState() => _ReviewsTabBlocContentState();
}

class _ReviewsTabBlocContentState extends State<_ReviewsTabBlocContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyTestDetailsCubit>().getMyPublicTestReviews(
        testId: widget.testId,
        rating: context.read<MyTestDetailsCubit>().state.selectedRatingFilter,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTestDetailsCubit, MyTestDetailsState>(
      listenWhen: (previous, current) =>
          previous.reviewFeedbackStatus != current.reviewFeedbackStatus,
      listener: (context, state) {
        if (state.isReviewsLoadMoreFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر تحميل المزيد من المراجعات',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyTestDetailsCubit>().resetReviewsLoadMoreState();
        }
        if (state.isReviewFeedbackFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر تسجيل رأيك على المراجعة',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyTestDetailsCubit>().resetReviewFeedbackState();
        }
      },
      buildWhen: (previous, current) =>
          previous.reviewsStatus != current.reviewsStatus ||
          previous.reviewsDetails != current.reviewsDetails ||
          previous.selectedRatingFilter != current.selectedRatingFilter ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        final reviews = state.reviewsDetails;

        if (state.isInitialReviewsLoading) {
          return const ReviewTabShimmer();
        }

        if (state.isReviewsFailure && reviews == null) {
          return Center(
            child: CustomTextWidget(
              state.errorMessage ?? 'حدث خطأ أثناء جلب المراجعات',
              color: AppPalette.red,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (reviews == null) {
          return const SizedBox.shrink();
        }

        return MyTestReviewTab(testId: widget.testId, reviewsDetails: reviews);
      },
    );
  }
}
