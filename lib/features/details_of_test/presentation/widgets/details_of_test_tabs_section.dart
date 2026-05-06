
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_overview_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_overview_tap.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/review_tab.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tab/sample_test_tap.dart';

class DetailsOfTestTabsSection extends StatefulWidget {
  final int testId;
  final OtherTestDetailsOverviewEntity overview;

  const DetailsOfTestTabsSection({
    super.key,
    required this.overview,
    required this.testId,
  });

  @override
  State<DetailsOfTestTabsSection> createState() =>
      _DetailsOfTestTabsSectionState();
}

class _DetailsOfTestTabsSectionState extends State<DetailsOfTestTabsSection> {
  int selectedIndex = 0;

  final List<String> tabs = const [
    'نظرة عامة',
    'عينة من الاختبار',
    'المراجعات',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Divider(
                  height: 3,
                  thickness: 3,
                  color: AppPalette.greyLight,
                ),
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(tabs.length, (index) {
                    final isSelected = selectedIndex == index;
                    final selected = tabs[index];

                    return SizedBox(
                      //width: SizeConfig.w(0.2), // يثبت عرض كل تاب
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() => selectedIndex = index);
                          debugPrint(selected);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextWidget(
                              tabs[index],
                              color: isSelected
                                  ? AppPalette.black
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
                                  ? isSelected == 1
                                        ? SizeConfig.w(0.21)
                                        : SizeConfig.w(0.14)
                                  : 0,
                              decoration: BoxDecoration(
                                color: AppPalette.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.025)),

          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    final data = widget.overview.data;

    switch (selectedIndex) {
      case 0:
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
          //reviewStatus: data.extraInfo.reviewStatus,
          interests: data.extraInfo.interests.map((e) => e.name).toList(),
        );
      // case 1:
      //   return const SampleTestTab();
      case 1:
        return BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
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
        
      case 2:
        return BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
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

            return ReviewTab(reviewsDetails: reviews, testId: widget.testId);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
