import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyTaskBottomActions extends StatelessWidget {
  final VoidCallback onStatusTap;
  final VoidCallback onDeleteTap;

  const StudyTaskBottomActions({
    super.key,
    required this.onStatusTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.035),
        vertical: SizeConfig.h(0.012),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.black : AppPalette.white,
        boxShadow: [
          BoxShadow(
            color: AppPalette.greyMedium.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomActionButton(
              title: "تعديل المهمة",
              backgroundColor: AppPalette.primary,
              onTap: onStatusTap,
            ),
          ),

          SizedBox(width: SizeConfig.w(0.025)),

          Expanded(
            child: _BottomActionButton(
              title: 'حذف المهمة',
              backgroundColor: AppPalette.red,
              onTap: onDeleteTap,
            ),
          ),
        ],
      ),
    );
  }

}

class _BottomActionButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      width: double.infinity,
      backgroundColor: backgroundColor,
      borderRadius: 6,
      childHorizontalPad: SizeConfig.w(0.025),
      childVerticalPad: SizeConfig.w(0.013),
      onTap: onTap,
      child: CustomTextWidget(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        color: AppPalette.white,
        fontFamily: AppFont.elMessiriSemiBold,
        fontSize: SizeConfig.text(0.03),
      ),
    );
  }
}
