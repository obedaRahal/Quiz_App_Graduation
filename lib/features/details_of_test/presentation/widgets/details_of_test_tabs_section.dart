import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_overview_tap.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/review_tab.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tab/sample_test_tap.dart';

class DetailsOfTestTabsSection extends StatelessWidget {
  final int testId;
  final OtherTestDetailsOverviewEntity overview;

  const DetailsOfTestTabsSection({
    super.key,
    required this.overview,
    required this.testId,
  });

  static const tabs = [
    _DetailsTabItem(title: 'نظرة عامة', tab: DetailsOfTestTab.overview),
    _DetailsTabItem(title: 'عينة من الاختبار', tab: DetailsOfTestTab.sample),
    _DetailsTabItem(title: 'المراجعات', tab: DetailsOfTestTab.reviews),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _DetailsTabsHeader(
                selectedTab: state.selectedTab,
                onTabSelected: context
                    .read<DetailsOfTestCubit>()
                    .changeSelectedTab,
              ),

              SizedBox(height: SizeConfig.h(0.025)),

              _DetailsTabContent(
                testId: testId,
                overview: overview,
                selectedTab: state.selectedTab,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailsTabItem {
  final String title;
  final DetailsOfTestTab tab;

  const _DetailsTabItem({required this.title, required this.tab});
}

class _DetailsTabsHeader extends StatelessWidget {
  final DetailsOfTestTab selectedTab;
  final ValueChanged<DetailsOfTestTab> onTabSelected;

  const _DetailsTabsHeader({
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const tabs = [
    _DetailsTabItem(title: 'نظرة عامة', tab: DetailsOfTestTab.overview),
    _DetailsTabItem(title: 'عينة من الاختبار', tab: DetailsOfTestTab.sample),
    _DetailsTabItem(title: 'المراجعات', tab: DetailsOfTestTab.reviews),
  ];

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
            children: tabs.map((item) {
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
                      width: isSelected
                          ? item.tab == DetailsOfTestTab.sample
                                ? SizeConfig.w(0.25)
                                : SizeConfig.w(0.14)
                          : 0,
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

class _DetailsTabContent extends StatelessWidget {
  final int testId;
  final DetailsOfTestTab selectedTab;
  final OtherTestDetailsOverviewEntity overview;

  const _DetailsTabContent({
    required this.testId,
    required this.selectedTab,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    final data = overview.data;

    switch (selectedTab) {
      case DetailsOfTestTab.overview:
        return TestOverviewTab(
          creatorName: data.creator.name,
          creatorProfilePicture: data.creator.profilePicture,
          isCreatorVerified: data.creator.isAcademicallyVerified,
          followersCount: data.creator.followersCount,
          followingCount: data.creator.followingCount,
          publishedTestsCount: data.creator.publishedTestsCount,
          isFollowingCreator: data.extraInfo.viewerContext.isFollowingCreator,
          questionCount: data.extraInfo.questionCount,
          durationSeconds: data.extraInfo.durationSeconds,
          passMarkPercentage: data.extraInfo.passMarkPercentage,
          publishedAt: data.extraInfo.publishedAt,
          lastContentUpdatedAt: data.extraInfo.lastContentUpdatedAt,
          targetLevel: data.extraInfo.targetLevel,
          language: data.extraInfo.language,
          participantsCount: data.extraInfo.participantsCount,
          interests: data.extraInfo.interests.map((e) => e.name).toList(),
          onFollowTap: () {
            debugPrint("follow / unfollow");
            context.read<DetailsOfTestCubit>().toggleCreatorFollow(
              creatorId: data.creator.id,
            );
          },
        );

      case DetailsOfTestTab.sample:
        return const _SampleTabBlocContent();

      case DetailsOfTestTab.reviews:
        return _ReviewsTabBlocContent(
          testId: testId,
          isFree: data.extraInfo.viewerContext.isFree,
          hasPurchased: data.extraInfo.viewerContext.hasPurchased,
        );
    }
  }
}

class _SampleTabBlocContent extends StatelessWidget {
  const _SampleTabBlocContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
      buildWhen: (previous, current) =>
          previous.sampleStatus != current.sampleStatus ||
          previous.sampleDetails != current.sampleDetails ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isSampleLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isSampleFailure) {
          return Center(
            child: CustomTextWidget(
              state.errorMessage ?? 'حدث خطأ أثناء جلب عينة الاختبار',
              color: AppPalette.red,
              textAlign: TextAlign.center,
            ),
          );
        }

        final sample = state.sampleDetails;

        if (sample == null || sample.questions.isEmpty) {
          return Center(
            child: CustomTextWidget(
              'لا توجد عينة أسئلة متاحة',
              color: AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),
          );
        }

        return SampleTestTab(questions: sample.questions);
      },
    );
  }
}

class _ReviewsTabBlocContent extends StatelessWidget {
  final int testId;
  final bool isFree;
  final bool hasPurchased;

  const _ReviewsTabBlocContent({
    required this.testId,
    required this.isFree,
    required this.hasPurchased,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsOfTestCubit, DetailsOfTestState>(
      listenWhen: (previous, current) =>
          previous.updateReviewStatus != current.updateReviewStatus,
      listener: (context, state) {
        if (state.isUpdateReviewSuccess) {
          showValidationTopSnackBar(
            context,
            title: "تم بنجاح",
            message: "تم تعديل تقييمك بنجاح",
            type: AppValidationSnackBarType.success,
          );

          context.read<DetailsOfTestCubit>().resetUpdateReviewState();
        }

        if (state.isUpdateReviewFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر تعديل التقييم",
            type: AppValidationSnackBarType.error,
          );

          context.read<DetailsOfTestCubit>().resetUpdateReviewState();
        }
      },
      buildWhen: (previous, current) =>
          previous.reviewsStatus != current.reviewsStatus ||
          previous.reviewsDetails != current.reviewsDetails ||
          previous.selectedRatingFilter != current.selectedRatingFilter ||
          previous.errorMessage != current.errorMessage ||
          previous.isEditingMyReview != current.isEditingMyReview ||
          previous.updateReviewStatus != current.updateReviewStatus,
      builder: (context, state) {
        if (state.isReviewsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isReviewsFailure) {
          return Center(
            child: CustomTextWidget(
              state.errorMessage ?? 'حدث خطأ أثناء جلب المراجعات',
              color: AppPalette.red,
              textAlign: TextAlign.center,
            ),
          );
        }

        final reviews = state.reviewsDetails;

        if (reviews == null) {
          return const SizedBox.shrink();
        }

        return ReviewTab(
          reviewsDetails: reviews,
          testId: testId,
          isFree: isFree,
          hasPurchased: hasPurchased,
        );
      },
    );
  }
}
