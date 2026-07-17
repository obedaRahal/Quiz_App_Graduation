import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanSelectionBox extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const StudyPlanSelectionBox({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.value,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: double.infinity,
        //minHeight: SizeConfig.h(0.058),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.012),
        ),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isDark
                ? AppPalette.borderFieldColorNDark
                : AppPalette.borderFieldColorNLight,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppPalette.greyMedium,
              size: SizeConfig.text(0.055),
            ),
            SizedBox(width: SizeConfig.w(0.02)),
            Expanded(
              child: CustomTextWidget(
                value?.trim().isNotEmpty == true ? value! : title,
                fontSize: SizeConfig.text(0.032),
                fontWeight: FontWeight.w700,
                color: value?.trim().isNotEmpty == true
                    ? context.appColors.blackToGrey2Dark
                    : AppPalette.greyMedium,
                textAlign: TextAlign.right,
              ),
            ),
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: SizeConfig.text(0.04),
              color: AppPalette.greyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
