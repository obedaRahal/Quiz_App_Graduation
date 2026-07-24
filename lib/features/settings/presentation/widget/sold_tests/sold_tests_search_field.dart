import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SoldTestsSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const SoldTestsSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
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
          hintText: 'ابحث في الاختبارات المباعة',
          hintTextDirection: TextDirection.rtl,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.055),
          ),
          suffixIcon: controller.text.trim().isEmpty
              ? null
              : IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.text(0.05),
                  ),
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
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: appColors.primaryToPrimaryDark),
          ),
        ),
      ),
    );
  }
}
