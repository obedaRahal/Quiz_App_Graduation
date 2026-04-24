import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class IntroTitle extends StatelessWidget {
  final String titleBlack;
  final String titlePrimary;

  const IntroTitle({
    super.key,
    required this.titleBlack,
    required this.titlePrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "$titleBlack\n",
              style: TextStyle(
                fontSize: SizeConfig.text(.07),
                fontFamily: AppFont.elMessiriBold,
                color: AppPalette.black,
                height: 1,
              ),
            ),
            TextSpan(
              text: titlePrimary,
              style: TextStyle(
                fontSize: SizeConfig.text(.055),
                fontFamily: AppFont.elMessiriMedium,
                color: AppPalette.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}