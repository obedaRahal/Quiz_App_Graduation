import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/all_reviews_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/rate_test_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';

class ReviewTab extends StatefulWidget {
  final int testId;

  final OtherTestDetailsReviewsEntity reviewsDetails;

  const ReviewTab({
    super.key,
    required this.reviewsDetails,
    required this.testId,
  });

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  ReviewRatingFilter selectedFilter = ReviewRatingFilter.all;

  @override
  Widget build(BuildContext context) {
    final summary = widget.reviewsDetails.data.summary;
    final myReview = widget.reviewsDetails.data.myReview;
    final publicReviews = widget.reviewsDetails.data.reviews
        .map(_mapPublicReview)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TestRatingSummarySection(
          averageRating: summary.averageRating,
          totalReviewsCount: summary.totalReviewsCount,
          commentsCount: summary.commentsCount,
          ratingDistribution: summary.ratingDistribution,
        ),

        Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),

        if (myReview == null) ...[
          const RateTestSection(),
          Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),
        ] else ...[
          MyPublishedReviewSection(
            review: _mapMyReview(myReview),
            onEdit: () {
              debugPrint('edit my review => ${myReview.id}');
            },
            onDelete: () {
              debugPrint('delete my review => ${myReview.id}');
            },
          ),
          Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),
        ],

        ReviewsSection(
          selectedFilter: selectedFilter,
          onFilterChanged: (value) {
            setState(() => selectedFilter = value);

            final rating = value.ratingValue?.toString() ?? 'all';

            context.read<DetailsOfTestCubit>().getOtherTestDetailsReviews(
              testId: widget.testId,
              rating: rating,
            );

            debugPrint('filter => $rating');
          },
          reviews: publicReviews,
          onReportReview: (reviewId) {
            debugPrint('report review => $reviewId');
          },
          onHelpfulYes: (reviewId) {
            debugPrint('helpful yes => $reviewId');
          },
          onHelpfulNo: (reviewId) {
            debugPrint('helpful no => $reviewId');
          },
        ),
      ],
    );
  }

  MyPublishedReviewUiModel _mapMyReview(TestReviewEntity review) {
    return MyPublishedReviewUiModel(
      reviewerName: review.user.name,
      avatarPath: review.user.avatarUrl,
      isVerified: review.user.isAcademicallyVerified,
      publishedAtText: review.createdAt,
      rating: review.rating.toDouble(),
      reviewText: review.reviewText,
      //helpfulCount: review.yesCount,
    );
  }

  PublicReviewUiModel _mapPublicReview(TestReviewEntity review) {
    return PublicReviewUiModel(
      id: review.id,
      reviewerName: review.user.name,
      avatarPath: review.user.avatarUrl,
      isVerified: review.user.isAcademicallyVerified,
      publishedAtText: review.createdAt,
      rating: review.rating.toDouble(),
      reviewText: review.reviewText,
      helpfulCount: review.yesCount,
      myHelpfulVote: _mapVoteToBool(review.viewerFeedback?.vote),
    );
  }

  bool? _mapVoteToBool(String? vote) {
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
