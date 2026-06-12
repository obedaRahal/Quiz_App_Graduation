import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_basic_info_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_general_stats_section.dart';

class OtherProfileOverviewTab extends StatelessWidget {
  const OtherProfileOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final interestsList = [
      'غير مصنف',
      'علوم اساسية',
      'برمجة',
      'غير مصنف',
      'علوم اساسية',
      'برمجة',
    ];

    final mockRatingDistribution = <RatingDistributionEntity>[
      const RatingDistributionEntity(stars: 5, count: 8, percentage: 40),
      const RatingDistributionEntity(stars: 4, count: 5, percentage: 25),
      const RatingDistributionEntity(stars: 3, count: 4, percentage: 20),
      const RatingDistributionEntity(stars: 2, count: 2, percentage: 10),
      const RatingDistributionEntity(stars: 1, count: 1, percentage: 5),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        OtherProfileBasicInfoSection(
          educationLevel: 'مدرسة',
          governorate: 'لم يتم التحديد',
          gender: 'انثى',
          joinedAt: '16 May 2026',
          interestsList: interestsList,
          isThereCertificate: true,
          onCertificateTap: () {
            debugPrint('show academic certificate');
          },
        ),

        CustomDivider(height: 30, thickness: 3),
        TestRatingSummarySection(
          averageRating: 3,
          totalReviewsCount: 2,
          commentsCount: 2,
          ratingDistribution: mockRatingDistribution.map((item) {
            return RatingDistributionEntity(
              stars: item.stars,
              count: item.count,
              percentage: item.percentage,
            );
          }).toList(),
        ),

        CustomDivider(height: 30, thickness: 3),

        OtherProfileGeneralStatsSection(
          likesCount: '22K',
          commentsCount: '8K',
          bookMarksCount: '120',
        ),
      ],
    );
  }
}
