




import 'dart:math';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;

  static late double width;
  static late double height;
  static late double diagonal;

  static late double safeWidth;
  static late double safeHeight;

  static late double shortestSide;
  static late double longestSide;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;

    diagonal = sqrt(width * width + height * height);

    final padding = _mediaQueryData.padding;
    safeWidth = width - padding.left - padding.right;
    safeHeight = height - padding.top - padding.bottom;

    shortestSide = min(width, height);
    longestSide = max(width, height);

    textScaleFactor = _mediaQueryData.textScaler.scale(1);
  }

  static double textSize(double factor) => shortestSide * factor;

  static double w(double factor) => width * factor;

  static double h(double factor) => height * factor;

  static double sw(double factor) => safeWidth * factor;
  static double sh(double factor) => safeHeight * factor;

  static double text(double factor) => shortestSide * factor;

  static bool get isSmallPhone => shortestSide < 360;
  static bool get isMediumPhone => shortestSide >= 360 && shortestSide < 400;
  static bool get isLargePhone => shortestSide >= 400;
}
