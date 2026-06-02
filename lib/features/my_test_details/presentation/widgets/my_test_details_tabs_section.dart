import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_sample_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/all_reviews_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_overview_tab.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_status_tab.dart';

class MyTestDetailsTabsSection extends StatelessWidget {
  final int testId;
  const MyTestDetailsTabsSection({super.key, required this.testId});

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

              _TabContent(testId: testId, selectedTab: state.selectedTab),
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
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: MyTestDetailsTabsSection.tabs.map((item) {
            final isSelected = selectedTab == item.tab;
            return GestureDetector(
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
      ],
    );
  }
}

class _TabContent extends StatelessWidget {
  final int testId;
  final MyTestDetailsTab selectedTab;

  const _TabContent({required this.testId, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    final List<SampleQuestionEntity> questions = [
      SampleQuestionEntity(
        id: 1,
        position: 1,
        questionText: "ما هي اللغة الأساسية المستخدمة في Flutter؟",
        hintText: "هي لغة برمجة مطورة من Google.",
        options: [
          SampleQuestionOptionEntity(
            id: 1,
            testQuestionId: 1,
            position: 1,
            optionText: "Java",
            isCorrect: false,
          ),
          SampleQuestionOptionEntity(
            id: 2,
            testQuestionId: 1,
            position: 2,
            optionText: "Dart",
            isCorrect: true,
          ),
          SampleQuestionOptionEntity(
            id: 3,
            testQuestionId: 1,
            position: 3,
            optionText: "Kotlin",
            isCorrect: false,
          ),
        ],
      ),
      SampleQuestionEntity(
        id: 2,
        position: 2,
        questionText: "ما هو الـ Widget الأساسي لعرض نص في Flutter؟",
        hintText: "هو Widget بسيط لعرض النصوص.",
        options: [
          SampleQuestionOptionEntity(
            id: 4,
            testQuestionId: 2,
            position: 1,
            optionText: "Text",
            isCorrect: true,
          ),
          SampleQuestionOptionEntity(
            id: 5,
            testQuestionId: 2,
            position: 2,
            optionText: "Container",
            isCorrect: false,
          ),
        ],
      ),
      SampleQuestionEntity(
        id: 3,
        position: 3,
        questionText:
            "أي من الخيارات التالية يمثل الـ State Management في Flutter؟",
        hintText: "هناك العديد من الحزم المشهورة لهذا الغرض.",
        options: [
          SampleQuestionOptionEntity(
            id: 6,
            testQuestionId: 3,
            position: 1,
            optionText: "Bloc",
            isCorrect: true,
          ),
          SampleQuestionOptionEntity(
            id: 7,
            testQuestionId: 3,
            position: 2,
            optionText: "HttpClient",
            isCorrect: false,
          ),
          SampleQuestionOptionEntity(
            id: 8,
            testQuestionId: 3,
            position: 3,
            optionText: "PathProvider",
            isCorrect: false,
          ),
        ],
      ),
      SampleQuestionEntity(
        id: 4,
        position: 4,
        questionText: "أي Widget يستخدم لعرض قائمة قابلة للتمرير؟",
        hintText: "يوجد Scrollable Widget مدمج في Flutter.",
        options: [
          SampleQuestionOptionEntity(
            id: 9,
            testQuestionId: 4,
            position: 1,
            optionText: "ListView",
            isCorrect: true,
          ),
          SampleQuestionOptionEntity(
            id: 10,
            testQuestionId: 4,
            position: 2,
            optionText: "Row",
            isCorrect: false,
          ),
        ],
      ),
      SampleQuestionEntity(
        id: 5,
        position: 5,
        questionText: "ما هو الفرق بين StatelessWidget و StatefulWidget؟",
        hintText: "واحد يمكنه الاحتفاظ بالحالة والآخر لا.",
        options: [
          SampleQuestionOptionEntity(
            id: 11,
            testQuestionId: 5,
            position: 1,
            optionText: "StatelessWidget لا يحتوي على حالة متغيرة",
            isCorrect: true,
          ),
          SampleQuestionOptionEntity(
            id: 12,
            testQuestionId: 5,
            position: 2,
            optionText: "StatefulWidget لا يمكنه تحديث الواجهة",
            isCorrect: false,
          ),
          SampleQuestionOptionEntity(
            id: 13,
            testQuestionId: 5,
            position: 3,
            optionText: "StatelessWidget يمكنه تغيير الحالة",
            isCorrect: false,
          ),
        ],
      ),
    ];

    switch (selectedTab) {
      case MyTestDetailsTab.overview:
        return MyTestOverviewTab(questions: questions);
      case MyTestDetailsTab.status:
        return MyTestStatusTab();
      case MyTestDetailsTab.reviews:
        return MyTestReviewTab();
    }
  }
}

class MyTestReviewTab extends StatelessWidget {
  const MyTestReviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final averageRating = 4.5;
    final totalReviewsCount = 23;
    final commentsCount = 12;

    final ratingDistribution = [
      RatingDistributionEntity(stars: 5, count: 12, percentage: 52),
      RatingDistributionEntity(stars: 4, count: 6, percentage: 26),
      RatingDistributionEntity(stars: 3, count: 3, percentage: 13),
      RatingDistributionEntity(stars: 2, count: 1, percentage: 4),
      RatingDistributionEntity(stars: 1, count: 1, percentage: 5),
    ];

    final List<PublicReviewUiModel> reviews = [
      const PublicReviewUiModel(
        id: 1,
        reviewerName: 'أمل سمير',
        avatarPath: null,
        isVerified: true,
        publishedAtText: '2025/01/22',
        rating: 5,
        reviewText: 'هذا اختبار رائع ومفيد جدًا.',
        helpfulCount: 12,
        myHelpfulVote: null,
      ),
      const PublicReviewUiModel(
        id: 2,
        reviewerName: 'زينب أحمد',
        avatarPath: null,
        isVerified: false,
        publishedAtText: '2025/02/10',
        rating: 4,
        reviewText: 'المحتوى كان جيد ولكن يمكن تحسينه.',
        helpfulCount: 5,
        myHelpfulVote: null,
      ),
    ];

    final selectedFilter = _filterFromRating(
      context.select(
        (MyTestDetailsCubit cubit) => cubit.state.selectedRatingFilter,
      ),
    );

    return Column(
      children: [
        TestRatingSummarySection(
          averageRating: averageRating,
          totalReviewsCount: totalReviewsCount,
          commentsCount: commentsCount,
          ratingDistribution: ratingDistribution,
        ),
        CustomDivider(height: 30, thickness: 3),

        ReviewsSection(
          selectedFilter: selectedFilter,
          onFilterChanged: (filter) {
            context.read<MyTestDetailsCubit>().changeSelectedRatingFilter(
              filter.ratingValue?.toString() ?? 'all',
            );
            // إعادة بناء الواجهة سيتم تلقائياً عبر BlocBuilder
          },
          reviews: reviews,
          onReportReview: (id) {},
          onHelpfulYes: (id) {},
          onHelpfulNo: (id) {},
          canInteractWithReviews: true,
          isFeedbackLoading: false,
          activeFeedbackReviewId: null,
          isLoading: false,
        ),
      ],
    );
  }

  ReviewRatingFilter _filterFromRating(String rating) {
    switch (rating) {
      case '5':
        return ReviewRatingFilter.five;
      case '4':
        return ReviewRatingFilter.four;
      case '3':
        return ReviewRatingFilter.three;
      case '2':
        return ReviewRatingFilter.two;
      case '1':
        return ReviewRatingFilter.one;
      case 'all':
      default:
        return ReviewRatingFilter.all;
    }
  }
}
