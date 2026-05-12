import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestsByInterestSearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const TestsByInterestSearchField({
    super.key,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<TestsByInterestSearchField> createState() =>
      _TestsByInterestSearchFieldState();
}

class _TestsByInterestSearchFieldState
    extends State<TestsByInterestSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _clear() {
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
          fontSize: SizeConfig.text(0.032),
          fontFamily: AppFont.elMessiriRegular,
        ),
        decoration: InputDecoration(
          hintText: 'البحث عن اختبار ضمن التصنيف',
          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.032),
            fontFamily: AppFont.elMessiriRegular,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.055),
          ),
          suffixIcon: _controller.text.trim().isNotEmpty
              ? GestureDetector(
                  onTap: _clear,
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
          contentPadding: EdgeInsets.only(
            top: SizeConfig.h(0.000),
            bottom: SizeConfig.h(0.002),
          ),
        ),
      ),
    );
  }
}
