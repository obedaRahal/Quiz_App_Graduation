import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ResultPlayerItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final int score;
  final bool isWinner;

  const ResultPlayerItem({
    super.key,
    required this.name,
    required this.imagePath,
    required this.score,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            if (isWinner) ...[
              Positioned(
                top: -SizeConfig.h(0.05),
                left: -SizeConfig.h(0.08),
                child: CustomAppImage(
                  path: AppImage.winnerLottie,
                  width: SizeConfig.w(0.2),
                  height: SizeConfig.w(0.2),
                  fit: BoxFit.contain,
                ),
              ),
            ],
            CustomAppImage(
              path: imagePath,
              width: SizeConfig.h(0.07),
              height: SizeConfig.h(0.07),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.h(0.008)),

        SizedBox(
          width: SizeConfig.w(0.1),
          child: CustomTextWidget(
            name,
            color: AppPalette.white,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.03),
            maxLines: 2,
          ),
        ),
        CustomBackgroundWithChild(
          backgroundColor: Colors.transparent,
          border: Border.all(color: AppPalette.white),
          childHorizontalPad: SizeConfig.w(0.025),
          borderRadius: BorderRadius.circular(4),
          child: CustomTextWidget(
            '$score',
            color: AppPalette.white,
            fontFamily: AppFont.elMessiriMedium,
            fontSize: SizeConfig.text(0.026),
          ),
        ),
      ],
    );
  }
}
