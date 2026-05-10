import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/all_reviews_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/rate_test_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';

class ReviewTab extends StatelessWidget {
  final int testId;
  final OtherTestDetailsReviewsEntity reviewsDetails;
  final bool isFree;
  final bool hasPurchased;

  const ReviewTab({
    super.key,
    required this.reviewsDetails,
    required this.testId,
    required this.isFree,
    required this.hasPurchased,
  });

  @override
  Widget build(BuildContext context) {
    final summary = reviewsDetails.data.summary;
    final myReview = reviewsDetails.data.myReview;
    final publicReviews = reviewsDetails.data.reviews
        .map(ReviewUiMapper.mapPublicReview)
        .toList();

    final canInteractWithReviews = isFree || hasPurchased;

    final selectedFilter = _filterFromRating(
      context.select(
        (DetailsOfTestCubit cubit) => cubit.state.selectedRatingFilter,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TestRatingSummarySection(
          averageRating: summary.averageRating,
          totalReviewsCount: summary.totalReviewsCount,
          commentsCount: summary.commentsCount,
          ratingDistribution: summary.ratingDistribution,
        ),

        CustomDivider(height: 30, thickness: 3),

        if (myReview == null) ...[
          RateTestSection(
            testId: testId,
            canSubmitReview: canInteractWithReviews,
          ),
          CustomDivider(height: 30, thickness: 3),
        ] else ...[
          MyPublishedReviewSection(
            review: ReviewUiMapper.mapMyReview(myReview),
            onEdit: () {
              debugPrint('edit my review => ${myReview.id}');
            },
            onDelete: () {
              debugPrint('delete my review => ${myReview.id}');
            },
          ),
          CustomDivider(height: 30, thickness: 3),
        ],

        ReviewsSection(
          selectedFilter: selectedFilter,
          onFilterChanged: (value) {
            final rating = value.ratingValue?.toString() ?? 'all';

            context.read<DetailsOfTestCubit>().getOtherTestDetailsReviews(
              testId: testId,
              rating: rating,
            );

            debugPrint('filter => $rating');
          },
          reviews: publicReviews,
          canInteractWithReviews: canInteractWithReviews,
          onReportReview: (reviewId) {
            debugPrint('report review => $reviewId');
          },
          onHelpfulYes: (reviewId) {
            debugPrint('helpful yes => $reviewId');
            if (!canInteractWithReviews) {
              _showPurchaseRequiredSnackBar(context);
              return;
            }
          },
          onHelpfulNo: (reviewId) {
            debugPrint('helpful no => $reviewId');
            if (!canInteractWithReviews) {
              _showPurchaseRequiredSnackBar(context);
              return;
            }
          },
        ),
      ],
    );
  }

  void _showPurchaseRequiredSnackBar(BuildContext context) {
    showValidationTopSnackBar(
      context,
      title: "تنبيه",
      message: "يجب شراء الاختبار أولًا حتى تتمكن من التفاعل مع المراجعات",
      type: AppValidationSnackBarType.hint,
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

class ReviewUiMapper {
  const ReviewUiMapper._();

  static MyPublishedReviewUiModel mapMyReview(TestReviewEntity review) {
    return MyPublishedReviewUiModel(
      reviewerName: review.user.name,
      avatarPath: review.user.avatarUrl,
      isVerified: review.user.isAcademicallyVerified,
      publishedAtText: review.createdAt,
      rating: review.rating.toDouble(),
      reviewText: review.reviewText,
      helpfulCount: review.yesCount,
    );
  }

  static PublicReviewUiModel mapPublicReview(TestReviewEntity review) {
    return PublicReviewUiModel(
      id: review.id,
      reviewerName: review.user.name,
      avatarPath: review.user.avatarUrl,
      isVerified: review.user.isAcademicallyVerified,
      publishedAtText: review.createdAt,
      rating: review.rating.toDouble(),
      reviewText: review.reviewText,
      helpfulCount: review.yesCount,
      myHelpfulVote: mapVoteToBool(review.viewerFeedback?.vote),
    );
  }

  static bool? mapVoteToBool(String? vote) {
    if (vote == null) return null;

    final normalized = vote.trim().toLowerCase();

    if (normalized == 'yes' || normalized == 'true' || normalized == '1') {
      return true;
    }

    if (normalized == 'no' || normalized == 'false' || normalized == '0') {
      return false;
    }

    return null;
  }
}
