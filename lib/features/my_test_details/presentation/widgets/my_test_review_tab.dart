import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/submit_report_params.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/review_tab_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/report_reason_bottom_sheet.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/all_reviews_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';
import 'package:quiz_app_grad/features/my_test_details/domain/entities/my_public_test_reviews_entity.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';

class MyTestReviewTab extends StatelessWidget {
  final int testId;
  final MyPublicTestReviewsEntity reviewsDetails;

  const MyTestReviewTab({
    super.key,
    required this.testId,
    required this.reviewsDetails,
  });

  @override
  Widget build(BuildContext context) {
    final summary = reviewsDetails.data.summary;
    final reviews = reviewsDetails.data.reviews;

    final selectedFilter = _filterFromRating(
      context.select(
        (MyTestDetailsCubit cubit) => cubit.state.selectedRatingFilter,
      ),
    );

    final isFilteringReviewsLoading = context.select(
      (MyTestDetailsCubit cubit) => cubit.state.isFilteringReviewsLoading,
    );

    final isReviewsLoadMoreLoading = context.select(
      (MyTestDetailsCubit cubit) => cubit.state.isReviewsLoadMoreLoading,
    );

    final isFeedbackLoading = context.select(
      (MyTestDetailsCubit cubit) => cubit.state.isReviewFeedbackLoading,
    );

    final activeFeedbackReviewId = context.select(
      (MyTestDetailsCubit cubit) => cubit.state.activeFeedbackReviewId,
    );

    return Column(
      children: [
        TestRatingSummarySection(
          averageRating: summary.averageRating,
          totalReviewsCount: summary.totalReviewsCount,
          commentsCount: summary.commentsCount,
          ratingDistribution: summary.ratingDistribution.map((item) {
            return RatingDistributionEntity(
              stars: item.stars,
              count: item.count,
              percentage: item.percentage,
            );
          }).toList(),
        ),

        CustomDivider(height: 30, thickness: 3),

        ReviewsSection(
          selectedFilter: selectedFilter,
          onFilterChanged: (filter) {
            final rating = filter.ratingValue?.toString() ?? 'all';

            context.read<MyTestDetailsCubit>().getMyPublicTestReviews(
              testId: testId,
              rating: rating,
              loadMore: false,
            );
          },
          reviews: reviews.map((review) {
            return PublicReviewUiModel(
              id: review.id,
              reviewerName: review.reviewer.name,
              avatarPath: review.reviewer.avatarUrl,
              isVerified: review.reviewer.isAcademicallyVerified,
              publishedAtText: review.createdAt,
              rating: review.rating.toDouble(),
              reviewText: review.reviewText,
              helpfulCount: review.yesCount,
              myHelpfulVote: _mapVoteToBool(review.viewerFeedback?.vote),
            );
          }).toList(),
          // onReportReview: (id) {
          //   debugPrint('report my public test review => $id');
          // },
          onReportReview: (reviewId) {
            debugPrint('report my public test review => $reviewId');

            showReportReasonDialog(
              context: context,
              cubit: context.read<DetailsOfTestCubit>(),
              title: 'الإبلاغ عن تعليق',
              reasons: const [
                ReportReasonUiModel(
                  label: 'تعليق مسيئ (أخلاقيا - دينيا - اجتماعيا)',
                ),
                ReportReasonUiModel(label: 'مضايقة او إساءة شخصية'),
                ReportReasonUiModel(
                  label: 'تعليق لا علاقة له بموضوع الاختبار (غير موضوعي)',
                ),
              ],
              descriptionHint:
                  'صف لنا المشكلة التي تواجه هذا التعليق بطريقة مختصرة وواضحة',
              onSubmit: (reason, description) {
                context.read<DetailsOfTestCubit>().submitReportCommentAndTest(
                  targetType: ReportTargetType.review,
                  targetId: reviewId,
                  reason: reason.label,
                  description: description,
                  testId: testId,
                );
              },
            );
          },
          onHelpfulYes: (reviewId) {
            debugPrint('my public helpful yes => $reviewId');

            context.read<MyTestDetailsCubit>().toggleMyPublicReviewFeedback(
              reviewId: reviewId,
              vote: true,
            );
          },
          onHelpfulNo: (reviewId) {
            debugPrint('my public helpful no => $reviewId');

            context.read<MyTestDetailsCubit>().toggleMyPublicReviewFeedback(
              reviewId: reviewId,
              vote: false,
            );
          },
          canInteractWithReviews: true,
          isFeedbackLoading: isFeedbackLoading,
          activeFeedbackReviewId: activeFeedbackReviewId,
          isLoading: isFilteringReviewsLoading,
        ),

        if (isReviewsLoadMoreLoading) ...[
          SizedBox(height: SizeConfig.h(0.018)),
          const Center(child: ReviewsSectionShimmer()),
        ],
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

  bool? _mapVoteToBool(String? vote) {
    final normalizedVote = vote?.trim().toLowerCase();

    if (normalizedVote == null || normalizedVote.isEmpty) {
      return null;
    }

    if (normalizedVote == 'yes') {
      return true;
    }

    if (normalizedVote == 'no') {
      return false;
    }

    return null;
  }
}
