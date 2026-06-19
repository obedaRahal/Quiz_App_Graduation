import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LibrarySearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback? onTap;
  final TextEditingController controller;

  const LibrarySearchField({
    super.key,
    required this.onChanged,
    required this.onClear,
    this.onTap,
    required this.controller,
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
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          final hasText = value.text.trim().isNotEmpty;

          return TextField(
            onTap: onTap,
            controller: controller,
            onChanged: onChanged,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            textAlignVertical: TextAlignVertical.center,
            cursorHeight: SizeConfig.text(0.050),
            cursorRadius: const Radius.circular(8),
            style: TextStyle(
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              fontSize: SizeConfig.text(0.034),
              fontFamily: AppFont.elMessiriRegular,
            ),
            decoration: InputDecoration(
              hintText: 'البحث عن محتوى',
              hintStyle: TextStyle(
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.034),
                fontFamily: AppFont.elMessiriRegular,
              ),

              prefixIcon: hasText
                  ? GestureDetector(
                      onTap: onClear,
                      child: Icon(
                        Icons.close_rounded,
                        color: AppPalette.greyMedium,
                        size: SizeConfig.text(0.055),
                      ),
                    )
                  : null,

              suffixIcon: Icon(
                Icons.search_rounded,
                color: AppPalette.greyMedium,
                size: SizeConfig.text(0.05),
              ),

              prefixIconConstraints: BoxConstraints(
                minWidth: SizeConfig.w(0.12),
                minHeight: SizeConfig.h(0.052),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: SizeConfig.w(0.12),
                minHeight: SizeConfig.h(0.052),
              ),

              border: InputBorder.none,
              isDense: false,
              contentPadding: EdgeInsets.only(
                top: SizeConfig.h(0.002),
                bottom: SizeConfig.h(0.010),
              ),
            ),
          );
        },
      ),
    );
  }
}