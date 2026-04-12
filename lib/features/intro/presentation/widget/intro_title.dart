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
                fontSize: SizeConfig.text(.075),
                fontFamily: AppFont.elMessiriBold,
                color: AppPalette.black,
                height: 1.5,
              ),
            ),
            TextSpan(
              text: titlePrimary,
              style: TextStyle(
                fontSize: SizeConfig.text(.06),
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