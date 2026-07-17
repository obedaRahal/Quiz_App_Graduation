import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ManageStudyPlansSearchField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const ManageStudyPlansSearchField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<ManageStudyPlansSearchField> createState() =>
      _ManageStudyPlansSearchFieldState();
}

class _ManageStudyPlansSearchFieldState
    extends State<ManageStudyPlansSearchField> {
  late final TextEditingController _controller;

  bool get hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant ManageStudyPlansSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.055),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'ابحث عن خطة',
          hintTextDirection: TextDirection.rtl,

          suffixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.055),
          ),

          prefixIcon: hasText
              ? InkWell(
                  onTap: _clear,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.text(0.052),
                  ),
                )
              : null,

          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.034),
          ),

          filled: true,
          fillColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppPalette.grey,

          contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),

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
