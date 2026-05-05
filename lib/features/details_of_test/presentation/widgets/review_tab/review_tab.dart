import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/all_reviews_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/rate_test_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';

class ReviewTab extends StatefulWidget {
  const ReviewTab({super.key});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  ReviewRatingFilter selectedFilter = ReviewRatingFilter.all;

  @override
  Widget build(BuildContext context) {
    final reviews = [
      const PublicReviewUiModel(
        id: 1,
        reviewerName: 'أمل سمير عرفة',
        avatarPath: null,
        isVerified: true,
        publishedAtText: '2025/01/22',
        rating: 3,
        reviewText:
            'اختبار رائع جدًا مليء بالمعرفة والأشياء الشيقة والرائعة التي تعطي تجربة حقيقية ورائعة للمستخدم وتجعله يذاكر بطريقة فعالة',
        helpfulCount: 2300,
        myHelpfulVote: null,
      ),

      const PublicReviewUiModel(
        id: 1,
        reviewerName: 'أمل سمير عرفة',
        avatarPath: null,
        isVerified: true,
        publishedAtText: '2025/01/22',
        rating: 3,
        reviewText:
            'اختبار رائع جدًا مليء بالمعرفة والأشياء الشيقة والرائعة التي تعطي تجربة حقيقية ورائعة للمستخدم وتجعله يذاكر بطريقة فعالة',
        helpfulCount: 2300,
        myHelpfulVote: null,
      ),

      const PublicReviewUiModel(
        id: 1,
        reviewerName: 'أمل سمير عرفة',
        avatarPath: null,
        isVerified: true,
        publishedAtText: '2025/01/22',
        rating: 3,
        reviewText:
            'اختبار رائع جدًا مليء بالمعرفة والأشياء الشيقة والرائعة التي تعطي تجربة حقيقية ورائعة للمستخدم وتجعله يذاكر بطريقة فعالة',
        helpfulCount: 2300,
        myHelpfulVote: null,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const TestRatingSummarySection(),
        Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),
        const RateTestSection(),
        Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),

        MyPublishedReviewSection(
          review: MyPublishedReviewUiModel(
            reviewerName: 'كاريس احمد بشار',
            avatarPath: AppImage.carmen,
            isVerified: true,
            publishedAtText: '2025/01/22',
            rating: 3,
            reviewText:
                'اختبار رائع جدًا مليء بالمعرفة والأشياء الشيقة والرائعة التي تمنح تجربة حقيقية ورائعة للمستخدم وتجعله يذاكر بطريقة فعالة',
          ),
          onEdit: () {
            debugPrint('edit my review');
          },
          onDelete: () {
            debugPrint('delete my review');
          },
        ),

        Divider(height: 30, thickness: 3, color: AppPalette.whiteToGrey),

        ReviewsSection(
          selectedFilter: selectedFilter,
          onFilterChanged: (value) {
            setState(() {
              selectedFilter = value;
            });
            debugPrint('filter => $value');
          },
          reviews: filterReviewsByRating(
            reviews: reviews,
            filter: selectedFilter,
          ),
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

  List<PublicReviewUiModel> filterReviewsByRating({
    required List<PublicReviewUiModel> reviews,
    required ReviewRatingFilter filter,
  }) {
    final ratingValue = filter.ratingValue;

    if (ratingValue == null) {
      return reviews;
    }

    return reviews.where((review) {
      return review.rating.round() == ratingValue;
    }).toList();
  }
}
