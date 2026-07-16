import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class MyProfileTestsSearchField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const MyProfileTestsSearchField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<MyProfileTestsSearchField> createState() =>
      _MyProfileTestsSearchFieldState();
}

class _MyProfileTestsSearchFieldState
    extends State<MyProfileTestsSearchField> {
  late final TextEditingController _controller;

  bool get hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.value,
    );
  }

  @override
  void didUpdateWidget(
    covariant MyProfileTestsSearchField oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(
          offset: widget.value.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: SizeConfig.h(0.055),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'ابحث في اختباراتك',
          hintTextDirection: TextDirection.rtl,

          suffixIcon: Icon(
            Icons.search_rounded,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.052),
          ),

          prefixIcon: hasText
              ? InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _clearSearch,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.text(0.05),
                  ),
                )
              : null,

          hintStyle: TextStyle(
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriRegular,
            fontSize: SizeConfig.text(0.032),
          ),

          filled: true,
          fillColor: isDark
              ? Colors.white.withOpacity(0.05)
              : AppPalette.grey,

          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.03),
            vertical: SizeConfig.h(0.012),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: appColors
                  .borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: appColors
                  .borderFieldColorNLightToborderFieldColorNDark,
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