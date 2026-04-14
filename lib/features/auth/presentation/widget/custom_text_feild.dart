import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.hint,
    this.suffixIcon,
    this.prefixIcon,
    this.iconData,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.borderRadius = 10,
    this.hintFontSize = 16,
    this.onChanged,
    this.validator,
    this.onSuffixTap,
    this.onIconTap,
    this.initialText,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final IconData? iconData;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final double borderRadius;
  final double hintFontSize;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onIconTap;
  final String? initialText;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      //height: 50,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          key: initialText != null ? ValueKey(initialText) : null,
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          style: TextStyle(
            fontFamily: AppFont.elMessiriRegular,

            fontSize: 16,
            color: colorScheme.onSurface,
          ),
          maxLines: obscureText ? 1 : maxLines,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            //labelText: label,
            hintText: hint,
            counterText: "",
            hintStyle: TextStyle(
              color: AppPalette.greyMedium,
              fontFamily: AppFont.elMessiriRegular,
              fontSize: hintFontSize,
            ),

            suffixIcon: suffixIcon == null
                ? null
                : IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(suffixIcon, size: 24),
                  ),
            icon: iconData == null
                ? null
                : IconButton(
                    onPressed: onIconTap,
                    icon: Icon(iconData, size: 20),
                  ),
            prefix: prefixIcon == null
                ? null
                : IconButton(
                    onPressed: onSuffixTap,
                    icon: Icon(prefixIcon, size: 20),
                  ),
            suffixIconColor: Color(0xffACACAC),
            filled: true,
            fillColor: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.borderFieldColorNLight,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: appColors.primaryToPrimaryDark),
            ),
          ),
        ),
      ),
    );
  }
}
