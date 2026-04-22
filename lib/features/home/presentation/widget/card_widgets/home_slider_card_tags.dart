import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomeSliderCardTags extends StatelessWidget {
  final bool isDark;

  const HomeSliderCardTags({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double firstItemWidth = SizeConfig.w(0.35);
          double remainingWidth = maxWidth - firstItemWidth;
          bool showSecondFull = remainingWidth > SizeConfig.w(0.25);

          return Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: firstItemWidth,
                ),
                child: CustomBackgroundWithChild(
                  backgroundColor: isDark
                      ? AppPalette.greyLightDark
                      : AppPalette.primarySoft,
                  borderRadius: BorderRadius.circular(6),
                  childHorizontalPad: 8,
                  childVerticalPad: 4,
                  child: CustomTextWidget(
                    '# علوم اساسية',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: SizeConfig.text(0.032),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.w(0.02)),
              Flexible(
                child: CustomBackgroundWithChild(
                  backgroundColor: isDark
                      ? AppPalette.greyLightDark
                      : AppPalette.primarySoft,
                  borderRadius: BorderRadius.circular(6),
                  childHorizontalPad: 8,
                  childVerticalPad: 4,
                  child: CustomTextWidget(
                    showSecondFull ? '# علوم' : '...',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    fontSize: SizeConfig.text(0.032),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}