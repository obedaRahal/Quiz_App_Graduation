import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class OtherProfileStatCard extends StatelessWidget {
  final FaIconData icon;
  final String value;
  final String description;

  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? backgroundColor;

  const OtherProfileStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.description,
    this.iconBackgroundColor,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.w(0.02),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: backgroundColor ?? AppPalette.greyLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              CustomBackgroundWithChild(
                backgroundColor:
                    iconBackgroundColor ?? appColors.primaryToPrimaryDark,
                borderRadius: BorderRadius.circular(4),
                childHorizontalPad: SizeConfig.w(0.01),
                childVerticalPad: SizeConfig.w(0.01),
                child: FaIcon(
                  icon,
                  color: iconColor ?? AppPalette.white,
                  size: SizeConfig.h(0.017),
                ),
              ),

              SizedBox(width: SizeConfig.w(0.02)),

              Flexible(
                child: CustomTextWidget(
                  value,
                  color: appColors.blackTogreyMedium,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.04),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.004)),

          CustomTextWidget(
            description,
            color: appColors.blackTogreyMedium,
            fontSize: SizeConfig.text(0.02),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}