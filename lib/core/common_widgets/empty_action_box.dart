import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class EmptyActionBox extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;
  final IconData icon;

  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final Color? descriptionColor;

  const EmptyActionBox({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    this.icon = Icons.add_circle_outline_rounded,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.descriptionColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor:
            backgroundColor ??
            (isDark ? Colors.white.withOpacity(0.05) : AppPalette.grey),
        borderRadius: BorderRadius.circular(10),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.035),
          vertical: SizeConfig.h(0.018),
        ),
        border: Border.all(
          color:
              borderColor ??
              appColors.borderFieldColorNLightToborderFieldColorNDark,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor ?? appColors.primaryToPrimaryDark,
              size: SizeConfig.w(0.09),
            ),
            SizedBox(height: SizeConfig.h(0.008)),
            CustomTextWidget(
              title,
              color: titleColor ?? appColors.blackToGrey2Dark,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.034),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.h(0.004)),
            CustomTextWidget(
              description,
              color: descriptionColor ?? AppPalette.greyMedium,
              textAlign: TextAlign.center,
              fontSize: SizeConfig.text(0.027),
            ),
          ],
        ),
      ),
    );
  }
}
