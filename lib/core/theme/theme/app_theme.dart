import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

import 'app_theme_colors.dart';

abstract class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppPalette.white,
      colorScheme: const ColorScheme.light(
        primary: AppPalette.primary,
        onPrimary: AppPalette.white,
        secondary: AppPalette.black,
        onSecondary: AppPalette.white,
        surface: AppPalette.white,
        onSurface: AppPalette.black,
        error: Colors.red,
        onError: AppPalette.white,
      ),
      dividerColor: AppPalette.greyLight,
      extensions: const [
        AppThemeColors.light,
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.black,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primaryDark,
        onPrimary: AppPalette.white,
        secondary: AppPalette.white,
        onSecondary: AppPalette.black,
        surface: AppPalette.black,
        onSurface: AppPalette.white,
        error: Colors.red,
        onError: AppPalette.white,
      ),
      dividerColor: AppPalette.greyMediumDark,
      extensions: const [
        AppThemeColors.dark,
      ],
    );
  }
}