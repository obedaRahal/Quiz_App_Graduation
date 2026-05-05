import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

import '../../../../../core/theme/color/app_colors.dart';

class TestRatingSummarySection extends StatelessWidget {
  const TestRatingSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final ratingRows = const [
      RatingDistributionUiModel(stars: 5, percentage: 0.95),
      RatingDistributionUiModel(stars: 4, percentage: 0.88),
      RatingDistributionUiModel(stars: 3, percentage: 0.50),
      RatingDistributionUiModel(stars: 2, percentage: 0.75),
      RatingDistributionUiModel(stars: 1, percentage: 0.92),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          "التقييم",
          color: AppPalette.black,
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
                rating: 4,
                totalRatingsText: '2K تقييم',
                totalCommentsText: '18 تعليق',
              ),
            ),

            SizedBox(width: SizeConfig.w(0.06)),

            Expanded(flex: 4, child: _RatingBarsColumn(rows: ratingRows)),
          ],
        ),
      ],
    );
  }
}

class RatingDistributionUiModel {
  final int stars;
  final double percentage; // من 0 إلى 1

  const RatingDistributionUiModel({
    required this.stars,
    required this.percentage,
  });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '5/',
                style: TextStyle(
                  color: AppPalette.black,
                  fontSize: SizeConfig.text(0.055),
                  fontFamily: AppFont.elMessiriSemiBold,
                ),
              ),
              TextSpan(
                text: rating.toStringAsFixed(1),
                style: TextStyle(
                  color: AppPalette.primary,
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

        DisplayRatingStarsRow(rating: rating),
      ],
    );
  }
}

class DisplayRatingStarsRow extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double? starSize;
  final Color filledColor;
  final Color emptyColor;
  final double horizontalSpacing;

  const DisplayRatingStarsRow({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.starSize,
    this.filledColor = AppPalette.yellow,
    this.emptyColor = AppPalette.greyLight,
    this.horizontalSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    final filledStars = rating.round().clamp(0, maxStars);

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(maxStars, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
          child: Icon(
            Icons.star_rounded,
            size: starSize ?? SizeConfig.h(0.035
            ),
            color: index < filledStars ? filledColor : emptyColor,
          ),
        );
      }),
    );
  }
}

class _RatingBarsColumn extends StatelessWidget {
  final List<RatingDistributionUiModel> rows;

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
  final RatingDistributionUiModel row;

  const _RatingBarRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        SizedBox(
          width: SizeConfig.w(0.11),
          child: CustomTextWidget(
            '${row.stars} نجوم',
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.027),
            textAlign: TextAlign.end,
          ),
        ),

        SizedBox(width: SizeConfig.w(0.018)),

        Directionality(
          textDirection: TextDirection.rtl,
          child: Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(20),
                value: row.percentage.clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppPalette.primarySoft,
                valueColor: AlwaysStoppedAnimation<Color>(AppPalette.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
