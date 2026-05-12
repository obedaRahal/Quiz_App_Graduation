import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class CategoriesSearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CategoriesSearchField({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<CategoriesSearchField> createState() => _CategoriesSearchFieldState();
}

class _CategoriesSearchFieldState extends State<CategoriesSearchField> {
  final TextEditingController _controller = TextEditingController();

  bool get _hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        controller: _controller,
        onChanged: widget.onChanged,
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
          hintText: 'البحث عن اختصاص',
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
          suffixIcon: _hasText
              ? GestureDetector(
                  onTap: _clearSearch,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.text(0.05),
                  ),
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: SizeConfig.w(0.12),
            minHeight: SizeConfig.h(0.052),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: SizeConfig.w(0.12),
            minHeight: SizeConfig.h(0.052),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 0, bottom: SizeConfig.h(0.001)),
        ),
      ),
    );
  }
}
