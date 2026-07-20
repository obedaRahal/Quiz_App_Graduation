import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyTaskAddSubtaskButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const StudyTaskAddSubtaskButton({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.008)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              Icons.add_circle_rounded,
              size: SizeConfig.text(0.050),
              color: enabled
                  ? appColors.primaryToPrimaryDark
                  : AppPalette.greyMedium,
            ),

            SizedBox(width: SizeConfig.w(0.018)),

            CustomTextWidget(
              enabled ? 'إضافة مهمة فرعية جديدة' : 'تم الوصول إلى الحد الأقصى',
              fontSize: SizeConfig.text(0.033),
              fontWeight: FontWeight.w700,
              color: enabled
                  ? appColors.primaryToPrimaryDark
                  : AppPalette.greyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
