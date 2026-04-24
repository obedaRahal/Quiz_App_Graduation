import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class HomeSliderCardFooter extends StatelessWidget {
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;

  const HomeSliderCardFooter({
    super.key,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.03),
        vertical: SizeConfig.h(0.010),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: SizeConfig.w(0.3)),
                child: CustomButtonWidget(
                  backgroundColor: appColors.primaryToPrimaryDark,
                  childHorizontalPad: 16,
                  childVerticalPad: 5,
                  borderRadius: 8,
                  onTap: () {},
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomTextWidget(
                      "معاينة",
                      fontSize: SizeConfig.text(0.038),
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomTextWidget(
                "180",
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
              ),
              CustomTextWidget(
                "ليرة سورية",
                fontSize: SizeConfig.text(0.023),
                color: AppPalette.greyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
