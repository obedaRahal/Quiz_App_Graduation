import 'package:flutter/material.dart';

import 'app_theme_colors.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  AppThemeColors get appColors => theme.extension<AppThemeColors>()!;
}