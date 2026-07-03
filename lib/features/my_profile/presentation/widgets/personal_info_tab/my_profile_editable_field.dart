
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class MyProfileEditableField extends StatefulWidget {
  final String title;
  final String value;
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  final TextInputType? keyboardType;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final double? height;
  final bool readOnly;
  final VoidCallback? onTap;

  const MyProfileEditableField({
    super.key,
    required this.title,
    required this.value,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.keyboardType,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.height,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<MyProfileEditableField> createState() => _MyProfileEditableFieldState();
}

class _MyProfileEditableFieldState extends State<MyProfileEditableField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant MyProfileEditableField oldWidget) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          widget.title,
          color: appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.034),
        ),
        SizedBox(height: SizeConfig.h(0.01)),
        SizedBox(
          height: widget.height ?? SizeConfig.h(0.057),
          child: TextField(
            controller: _controller,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            keyboardType: widget.keyboardType,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: [
              if (widget.maxLength != null)
                LengthLimitingTextInputFormatter(widget.maxLength),
            ],
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: SizeConfig.text(0.038),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              fontFamily: AppFont.elMessiriRegular,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: widget.hintText,
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(
                fontSize: SizeConfig.text(0.038),
                fontWeight: FontWeight.w500,
                color: AppPalette.greyMedium,
                fontFamily: AppFont.elMessiriRegular,
              ),
              filled: true,
              fillColor: isDark
                  ? AppPalette.fieldColorNDark
                  : AppPalette.whiteToGrey,
              contentPadding: EdgeInsets.only(
                right: SizeConfig.w(0.030),
                left: SizeConfig.w(0.020),
                top: SizeConfig.h(0.012),
                bottom: SizeConfig.h(0.012),
              ),
              prefixIcon: SizedBox(
                width: SizeConfig.w(0.105),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: AppPalette.greyMedium,
                    size: SizeConfig.w(0.052),
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: isDark
                      ? AppPalette.borderFieldColorNDark
                      : AppPalette.borderFieldColorNLight,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide(
                  color: appColors.primaryToPrimaryDark,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}