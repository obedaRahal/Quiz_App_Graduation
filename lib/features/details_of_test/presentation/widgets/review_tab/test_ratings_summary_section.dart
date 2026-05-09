import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/other_test_details_reviews_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/display_rating_stars_row.dart';

import '../../../../../core/theme/color/app_colors.dart';

class TestRatingSummarySection extends StatelessWidget {
  final double averageRating;
  final int totalReviewsCount;
  final int commentsCount;
  final List<RatingDistributionEntity> ratingDistribution;
  const TestRatingSummarySection({
    super.key,
    required this.averageRating,
    required this.totalReviewsCount,
    required this.commentsCount,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "التقييم",
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.04),
        ),

        SizedBox(height: SizeConfig.h(0.005)),
        Row(
          textDirection: TextDirection.rtl,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _RatingScoreColumn(
                rating: averageRating,
                totalRatingsText: '$totalReviewsCount تقييم',
                totalCommentsText: '$commentsCount تعليق',
              ),
            ),

            SizedBox(width: SizeConfig.w(0.06)),

            Expanded(
              flex: 4,
              child: _RatingBarsColumn(rows: ratingDistribution),
            ),
          ],
        ),
      ],
    );
  }
}

class _RatingScoreColumn extends StatelessWidget {
  final double rating;
  final String totalRatingsText;
  final String totalCommentsText;

  const _RatingScoreColumn({
    required this.rating,
    required this.totalRatingsText,
    required this.totalCommentsText,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '5 / ',
                style: TextStyle(
                  color: appColors.blackToGreyLightDark,
                  fontSize: SizeConfig.text(0.055),
                  fontFamily: AppFont.elMessiriSemiBold,
                ),
              ),
              TextSpan(
                text: rating.toStringAsFixed(1),
                style: TextStyle(
                  color: appColors.primaryToPrimaryDark,
                  fontSize: SizeConfig.text(0.06),
                  fontFamily: AppFont.elMessiriBold,
                ),
              ),
            ],
          ),
        ),

        //SizedBox(height: SizeConfig.h(0.004)),
        CustomTextWidget(
          '$totalRatingsText  •  $totalCommentsText',
          color: AppPalette.greyMedium,
          fontSize: SizeConfig.text(0.03),
          textAlign: TextAlign.end,
        ),

        SizedBox(height: SizeConfig.h(0.015)),

        DisplayRatingStarsRow(
          rating: rating,
          emptyColor: isDark ? AppPalette.greyMedium : AppPalette.greyLight,
        ),
      ],
    );
  }
}

class _RatingBarsColumn extends StatelessWidget {
  final List<RatingDistributionEntity> rows;

  const _RatingBarsColumn({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.h(0.007)),
          child: _RatingBarRow(row: row),
        );
      }).toList(),
    );
  }
}

class _RatingBarRow extends StatelessWidget {
  final RatingDistributionEntity row;

  const _RatingBarRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final progressValue = (row.percentage / 100).clamp(0.0, 1.0);

    return GestureDetector(
      onLongPress: () {
        showValidationTopSnackBar(
          context,
          title: "توضيح",
          message: '${row.count} تقييمات بعدد ${row.stars} نجوم',
          type: AppValidationSnackBarType.success,
        );
      },
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            width: SizeConfig.w(0.11),
            child: CustomTextWidget(
              '${row.stars} نجوم',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.027),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.018)),

          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(20),
                  value: progressValue,
                  minHeight: 6,
                  backgroundColor: appColors.primarySoftTogreyLightDark,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    appColors.primaryToPrimaryDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
