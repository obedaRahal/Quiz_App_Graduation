import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

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
            size: starSize ?? SizeConfig.h(0.035),
            color: index < filledStars ? filledColor : emptyColor,
          ),
        );
      }),
    );
  }
}
