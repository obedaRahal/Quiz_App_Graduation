import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primaryToPrimaryDark;
  final Color primaryToGreyMediumDark;
  final Color whiteToPrimaryDark;
  final Color blackToGreyLightDark;
  final Color blackTogreyMedium;
  final Color greyToGreyMediumDark;
  final Color whiteToblack;
  final Color greyMediumTogrey;
  final Color borderFieldColorNLightToborderFieldColorNDark;
  final Color primarySoftTogreyLightDark;

  const AppThemeColors({
    required this.primaryToPrimaryDark,
    required this.primaryToGreyMediumDark,
    required this.whiteToPrimaryDark,
    required this.blackToGreyLightDark,
    required this.blackTogreyMedium,
    required this.greyToGreyMediumDark,
    required this.whiteToblack,
    required this.greyMediumTogrey,
    required this.borderFieldColorNLightToborderFieldColorNDark,
    required this.primarySoftTogreyLightDark,
  });

  @override
  AppThemeColors copyWith({
    Color? primaryToPrimaryDark,
    Color? primaryToGreyMediumDark,
    Color? whiteToPrimaryDark,
    Color? blackToGreyLightDark,
    Color? blackToGreyMedium,
    Color? greyLightToGreyMediumDark,
    Color? whiteToblack,
    Color? greyMediumTogrey,
    Color? borderFieldColorNLightToborderFieldColorNDark,
    Color? primarySoftTogreyLightDark,
  }) {
    return AppThemeColors(
      primaryToPrimaryDark: primaryToPrimaryDark ?? this.primaryToPrimaryDark,
      primaryToGreyMediumDark:
          primaryToGreyMediumDark ?? this.primaryToGreyMediumDark,
      whiteToPrimaryDark: whiteToPrimaryDark ?? this.whiteToPrimaryDark,
      blackToGreyLightDark: blackToGreyLightDark ?? this.blackToGreyLightDark,

      blackTogreyMedium: blackToGreyMedium ?? this.blackTogreyMedium,

      greyToGreyMediumDark:
          greyLightToGreyMediumDark ?? this.greyToGreyMediumDark,
      whiteToblack: whiteToblack ?? this.whiteToblack,
      greyMediumTogrey: greyMediumTogrey ?? this.greyMediumTogrey,
      borderFieldColorNLightToborderFieldColorNDark:
          borderFieldColorNLightToborderFieldColorNDark ??
          this.borderFieldColorNLightToborderFieldColorNDark,

      primarySoftTogreyLightDark:
          primarySoftTogreyLightDark ??
          this.primarySoftTogreyLightDark,
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

      blackTogreyMedium: Color.lerp(
        blackTogreyMedium,
        other.blackTogreyMedium,
        t,
      )!,

      greyToGreyMediumDark: Color.lerp(
        greyToGreyMediumDark,
        other.greyToGreyMediumDark,
        t,
      )!,

      whiteToblack: Color.lerp(whiteToblack, other.whiteToblack, t)!,

      greyMediumTogrey: Color.lerp(
        greyMediumTogrey,
        other.greyMediumTogrey,
        t,
      )!,
      
      borderFieldColorNLightToborderFieldColorNDark: Color.lerp(
        borderFieldColorNLightToborderFieldColorNDark,
        other.borderFieldColorNLightToborderFieldColorNDark,
        t,
      )!,

      primarySoftTogreyLightDark: Color.lerp(
        primarySoftTogreyLightDark,
        other.primarySoftTogreyLightDark,
        t,
      )!,
    );
  }

  static const light = AppThemeColors(
    primaryToPrimaryDark: AppPalette.primary,
    primaryToGreyMediumDark: AppPalette.primary,
    whiteToPrimaryDark: AppPalette.white,
    blackToGreyLightDark: AppPalette.black,
    blackTogreyMedium: AppPalette.black,
    greyToGreyMediumDark: AppPalette.grey,
    whiteToblack: AppPalette.white,
    greyMediumTogrey: AppPalette.greyMedium,
    borderFieldColorNLightToborderFieldColorNDark:
        AppPalette.borderFieldColorNLight,
    primarySoftTogreyLightDark:
        AppPalette.primarySoft,
  );

  static const dark = AppThemeColors(
    primaryToPrimaryDark: AppPalette.primaryDark,
    primaryToGreyMediumDark: AppPalette.greyMediumDark,
    whiteToPrimaryDark: AppPalette.primaryDark,
    blackToGreyLightDark: AppPalette.greyLightDark,
    blackTogreyMedium: AppPalette.greyMedium,
    greyToGreyMediumDark: AppPalette.greyMediumDark,
    whiteToblack: AppPalette.black,
    greyMediumTogrey: AppPalette.grey,
    borderFieldColorNLightToborderFieldColorNDark:
        AppPalette.borderFieldColorNDark,
    primarySoftTogreyLightDark:
        AppPalette.greyLightDark,
  );
}
