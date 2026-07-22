import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
class UserSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const UserSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.055),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'ابحث عن مستخدم',
          hintTextDirection: TextDirection.rtl,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.055),
          ),
          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.036),
          ),
          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppPalette.grey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color:
                  appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color:
                  appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: appColors.primaryToPrimaryDark,
            ),
          ),
        ),
      ),
    );
  }
}
