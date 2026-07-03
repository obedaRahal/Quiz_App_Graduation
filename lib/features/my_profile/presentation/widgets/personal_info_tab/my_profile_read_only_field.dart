import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class MyProfileReadOnlyField extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const MyProfileReadOnlyField({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _FieldContainer(
      title: title,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.011),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //textDirection: TextDirection.rtl,
          children: [
            Icon(icon, color: AppPalette.greyMedium, size: SizeConfig.w(0.052)),
            //SizedBox(width: SizeConfig.w(0.02)),
            Spacer(),
            Expanded(
              child: CustomTextWidget(
                value,
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.031),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const _FieldContainer({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          title,
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.034),
        ),
        SizedBox(height: SizeConfig.h(0.006)),
        CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: isDark
              ? AppPalette.greyMediumDark.withOpacity(0.35)
              : AppPalette.greyLight.withOpacity(0.55),
          borderRadius: BorderRadius.circular(8),
          childHorizontalPad: 0,
          childVerticalPad: 0,
          child: child,
        ),
      ],
    );
  }
}
