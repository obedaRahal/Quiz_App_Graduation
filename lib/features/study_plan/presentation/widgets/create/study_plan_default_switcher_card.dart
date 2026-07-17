import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanDefaultSwitchCard extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const StudyPlanDefaultSwitchCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03) , vertical: SizeConfig.h(0.01)),
      backgroundColor: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(
        color: isDark
            ? AppPalette.borderFieldColorNDark
            : AppPalette.borderFieldColorNLight,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          CustomAppImage(path: AppImage.earth, color: AppPalette.greyMedium),
          SizedBox(width: SizeConfig.w(0.02)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  'وضع الخطة كافتراضية',
                  fontSize: SizeConfig.text(0.032),
                  fontWeight: FontWeight.w900,
                  color: isDark
                      ? AppPalette.grey2Dark
                      : AppPalette.textColorInHome,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: SizeConfig.h(0.002)),
                CustomTextWidget(
                  'سيتم عرض هذه الخطة تلقائيًا في الصفحة الرئيسية.',
                  fontSize: SizeConfig.text(0.024),
                  fontWeight: FontWeight.w600,
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: SizeConfig.w(0.12),
            height: SizeConfig.h(0.035),
            child: Transform.scale(
              scale: 0.62,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: isDark ? AppPalette.black : AppPalette.white,
                activeTrackColor: appColors.primaryToPrimaryDark,
                inactiveThumbColor: AppPalette.white,
                inactiveTrackColor: isDark
                    ? AppPalette.greyLightDark
                    : AppPalette.greyBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
