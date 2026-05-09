import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final double height ; 
  final double thickness ; 
  const CustomDivider({super.key, required this.height, required this.thickness});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      height: height,
      thickness: thickness,
      color: isDark ? AppPalette.greyMediumDark : AppPalette.whiteToGrey,
    );
  }
}
