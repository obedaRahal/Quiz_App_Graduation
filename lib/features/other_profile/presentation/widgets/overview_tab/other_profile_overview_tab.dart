import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/test_ratings_summary_section.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_overview_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_basic_info_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_general_stats_section.dart';

class OtherProfileOverviewTab extends StatefulWidget {
  final OtherProfileOverviewDataEntity dataEntity;
  final VoidCallback onAcademicCertificateTap;
  const OtherProfileOverviewTab({
    super.key,
    required this.dataEntity,
    required this.onAcademicCertificateTap,
  });

  @override
  State<OtherProfileOverviewTab> createState() =>
      _OtherProfileOverviewTabState();
}

class _OtherProfileOverviewTabState extends State<OtherProfileOverviewTab> {
  @override
  Widget build(BuildContext context) {
    final interestsList = widget.dataEntity.basicInfo.interests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        OtherProfileBasicInfoSection(
          educationLevel: widget.dataEntity.basicInfo.educationLevel,
          governorate: widget.dataEntity.basicInfo.governorate,
          gender: widget.dataEntity.basicInfo.gender,
          joinedAt: widget.dataEntity.basicInfo.joinedAt,
          interestsList: interestsList,
          isThereCertificate: true,
          onCertificateTap:widget.onAcademicCertificateTap ,
        ),

        CustomDivider(height: 30, thickness: 3),
        TestRatingSummarySection(
          averageRating: widget.dataEntity.reviews.averageRating,
          totalReviewsCount: widget.dataEntity.reviews.totalReviewsCount,
          commentsCount: widget.dataEntity.reviews.totalReviewsCount,
          ratingDistribution: widget.dataEntity.reviews.ratingDistribution.map((
            item,
          ) {
            return RatingDistributionEntity(
              stars: item.count,
              count: item.count,
              percentage: item.percentage.toDouble(),
            );
          }).toList(),
        ),

        CustomDivider(height: 30, thickness: 3),

        OtherProfileGeneralStatsSection(
          likesCount: '${widget.dataEntity.generalStatistics.testLikesCount}',
          commentsCount:
              '${widget.dataEntity.generalStatistics.testCommentsCount}',
          bookMarksCount:
              '${widget.dataEntity.generalStatistics.testBookmarksCount}',
        ),
      ],
    );
  }
}
