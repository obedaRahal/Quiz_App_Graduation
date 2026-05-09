import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class PlayModeCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final Color shadowColor;
  final VoidCallback onTap;

  const PlayModeCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.backgroundColor,
    required this.shadowColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    double cardWidth = SizeConfig.w(0.21);
    double cardHeight = SizeConfig.h(0.15);
    final borderRadius = BorderRadius.circular(8);

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        children: [
          IgnorePointer(
            child: CustomBackgroundWithChild(
              height: cardHeight,
              width: cardWidth,
              childVerticalPad: SizeConfig.h(0.01),
              childHorizontalPad: SizeConfig.w(0.019),
              borderRadius: borderRadius,
              border: Border.all(color: AppPalette.whiteSoft, width: 3),
              boxShadow: [BoxShadow(color: shadowColor, blurRadius: 8)],
              alignment: Alignment.topRight,
              backgroundColor: backgroundColor,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: CustomTextWidget(
                      "اللعب بنمط",
                      color: AppPalette.white,
                      fontSize: SizeConfig.text(0.023),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SvgPicture.asset(
                      iconPath,
                      height: SizeConfig.h(0.06),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: SizeConfig.h(0.035),
                    child: SizedBox(
                      width: SizeConfig.w(0.16),
                      child: CustomTextWidget(
                        title,
                        textAlign: TextAlign.start,
                        color: AppPalette.white,
                        fontFamily: AppFont.elMessiriSemiBold,
                        fontSize: SizeConfig.text(0.03),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onTap,
                splashColor: Colors.white.withOpacity(0.12),
                highlightColor: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
