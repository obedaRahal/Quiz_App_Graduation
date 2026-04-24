import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/custom_text_feild.dart';

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({
    super.key,
    required this.label,
    this.controller,
    required this.hint,
    this.suffixIcon,
    this.iconData,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSuffixTap,
    this.onIconTap,
    this.maxLines,
    this.maxLength,
    this.prefixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String hint;
  final int? maxLines;
  final int? maxLength;
  final IconData? suffixIcon;
  final IconData? iconData;

  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  final VoidCallback? onSuffixTap;
  final VoidCallback? onIconTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          label,
          fontSize: SizeConfig.text(0.05),
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: SizeConfig.height * .01),
        CustomTextField(
          controller: controller,
          onChanged: onChanged,
          prefixIcon: prefixIcon,
          hint: hint,
          suffixIcon: suffixIcon,
          iconData: iconData,
          onSuffixTap: onSuffixTap,
          validator: validator,
          obscureText: obscureText,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
