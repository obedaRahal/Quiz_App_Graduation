import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/arrow_back.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class CommonTopPartForgetPassword extends StatelessWidget {
  const CommonTopPartForgetPassword({
    super.key,
    required this.title,
    required this.bodyText,
    required this.img,
    required this.imgHeight,
  });

  final String title;
  final String bodyText;
  final String img;
  final double imgHeight;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomBackgroundWithChild(
      borderRadius: BorderRadius.circular(20),
      width: double.infinity,
      backgroundColor: isDark
          ? AppPalette.greyMediumDark
          : AppPalette.primarySoft,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: ArrowBack(),
            ),
          ),
          // SvgPicture.asset(img, height: imgHeight),
          CustomAppImage(path: img, height: imgHeight),

          // SizedBox(height: 24),
          CustomTextWidget(
            title,
            fontSize: SizeConfig.diagonal * .038,
            color: appColors.primaryToPrimaryDark,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: SizeConfig.height * .01),
          CustomTextWidget(
            bodyText,
            fontSize: SizeConfig.diagonal * .02,
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: SizeConfig.height * .03),
        ],
      ),
    );
  }
}
