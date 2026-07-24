import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool value;
  final ValueChanged<bool>? onChanged;

  final double topRadius;
  final double bottomRadius;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.value,
    required this.onChanged,

    this.topRadius = 10,
    this.bottomRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(0.01)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: AppPalette.grey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius),
          topRight: Radius.circular(topRadius),
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
        childHorizontalPad: SizeConfig.w(0.025),
        childVerticalPad: SizeConfig.h(0.012),
        child: Row(
          textDirection: TextDirection.rtl,

          children: [
            _SettingsIcon(
              icon: icon,
              iconColor: iconColor,
              backgroundColor: iconBackgroundColor,
            ),

            SizedBox(width: SizeConfig.w(0.025)),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextWidget(
                  title,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.038),
                  color: AppPalette.black,
                  textAlign: TextAlign.right,
                ),

                if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                  SizedBox(height: SizeConfig.h(0.003)),

                  CustomTextWidget(
                    subtitle!,
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.025),
                    textAlign: TextAlign.right,
                  ),
                ],
              ],
            ),
            Spacer(),

            Switch.adaptive(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _SettingsIcon({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.w(0.11),
      height: SizeConfig.w(0.11),
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      child: Icon(icon, color: iconColor, size: SizeConfig.w(0.055)),
    );
  }
}
