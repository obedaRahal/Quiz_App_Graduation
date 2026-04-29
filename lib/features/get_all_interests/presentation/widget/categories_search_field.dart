import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class CategoriesSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CategoriesSearchField({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: SizeConfig.h(0.052),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        onChanged: onChanged,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'البحث عن تصنيف',
          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.034),
            fontFamily: AppFont.elMessiriRegular,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.055),
          ),
          suffixIcon: GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.close_rounded,
              color: AppPalette.greyMedium,
              size: SizeConfig.text(0.05),
            ),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
