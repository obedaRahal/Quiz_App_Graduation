// import 'dart:math';

// import 'package:flutter/widgets.dart';

// class SizeConfig {
//   static late MediaQueryData _mediaQueryData;
//   static late double width;
//   static late double height;
//   static late double diagonal;

//   static void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     width = _mediaQueryData.size.width;
//     height = _mediaQueryData.size.height;
//     diagonal = sqrt(width * width + height * height);
//   }

//   static double textSize(double factor) => diagonal * factor;
// }

import 'dart:math';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;

  // Full screen dimensions
  static late double width;
  static late double height;
  static late double diagonal;

  // Safe area dimensions
  static late double safeWidth;
  static late double safeHeight;

  // Extra helpers
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

  // Old compatibility method
  static double textSize(double factor) => shortestSide * factor;

  // Width-based sizing
  static double w(double factor) => width * factor;

  // Height-based sizing
  static double h(double factor) => height * factor;

  // Safe area sizing
  static double sw(double factor) => safeWidth * factor;
  static double sh(double factor) => safeHeight * factor;

  // Text sizing
  static double text(double factor) => shortestSide * factor;

  // Optional helpers
  static bool get isSmallPhone => shortestSide < 360;
  static bool get isMediumPhone =>
      shortestSide >= 360 && shortestSide < 400;
  static bool get isLargePhone => shortestSide >= 400;
}