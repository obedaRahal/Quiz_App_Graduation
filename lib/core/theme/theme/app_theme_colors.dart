import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primaryToPrimaryDark;
  final Color primaryToGreyMediumDark;
  final Color whiteToPrimaryDark;
  final Color blackToGreyLightDark;
  final Color blackToGreyMedium;

  const AppThemeColors({
    required this.primaryToPrimaryDark,
    required this.primaryToGreyMediumDark,
    required this.whiteToPrimaryDark,
    required this.blackToGreyLightDark,
    required this.blackToGreyMedium,
  });

  @override
  AppThemeColors copyWith({
    Color? primaryToPrimaryDark,
    Color? primaryToGreyMediumDark,
    Color? whiteToPrimaryDark,
    Color? blackToGreyLightDark,
    Color? blackToGreyMedium,
  }) {
    return AppThemeColors(
      primaryToPrimaryDark: primaryToPrimaryDark ?? this.primaryToPrimaryDark,
      primaryToGreyMediumDark:
          primaryToGreyMediumDark ?? this.primaryToGreyMediumDark,
      whiteToPrimaryDark: whiteToPrimaryDark ?? this.whiteToPrimaryDark,
      blackToGreyLightDark: blackToGreyLightDark ?? this.blackToGreyLightDark,

      blackToGreyMedium: blackToGreyMedium ?? this.blackToGreyMedium,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      primaryToPrimaryDark: Color.lerp(
        primaryToPrimaryDark,
        other.primaryToPrimaryDark,
        t,
      )!,
      primaryToGreyMediumDark: Color.lerp(
        primaryToGreyMediumDark,
        other.primaryToGreyMediumDark,
        t,
      )!,
      whiteToPrimaryDark: Color.lerp(
        whiteToPrimaryDark,
        other.whiteToPrimaryDark,
        t,
      )!,
      blackToGreyLightDark: Color.lerp(
        blackToGreyLightDark,
        other.blackToGreyLightDark,
        t,
      )!,

      blackToGreyMedium: Color.lerp(
        blackToGreyMedium,
        other.blackToGreyMedium,
        t,
      )!,
    );
  }

  static const light = AppThemeColors(
    primaryToPrimaryDark: AppPalette.primary,
    primaryToGreyMediumDark: AppPalette.primary,
    whiteToPrimaryDark: AppPalette.white,
    blackToGreyLightDark: AppPalette.black,
    blackToGreyMedium: AppPalette.black
  );

  static const dark = AppThemeColors(
    primaryToPrimaryDark: AppPalette.primaryDark,
    primaryToGreyMediumDark: AppPalette.greyMediumDark,
    whiteToPrimaryDark: AppPalette.primaryDark,
    blackToGreyLightDark: AppPalette.greyLightDark,
    blackToGreyMedium: AppPalette.greyMedium
  );
}
