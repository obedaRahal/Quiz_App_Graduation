import 'package:flutter/material.dart';

import 'custom_app_image.dart';

class ThemedAppImage extends StatelessWidget {
  final String lightPath;
  final String darkPath;

  final double? width;
  final double? height;
  final double scale;

  final BoxFit fit;
  final Alignment alignment;

  final Color? color;
  final String? package;

  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Clip clipBehavior;

  final Widget? fallback;
  final IconData fallbackIcon;
  final double? fallbackIconSize;
  final Color? fallbackIconColor;

  final bool showLoadingForSvg;

  const ThemedAppImage({
    super.key,
    required this.lightPath,
    required this.darkPath,
    this.width,
    this.height,
    this.scale = 1.0,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.package,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.clipBehavior = Clip.antiAlias,
    this.fallback,
    this.fallbackIcon = Icons.broken_image_outlined,
    this.fallbackIconSize,
    this.fallbackIconColor,
    this.showLoadingForSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // return CustomAppImage(
    //   path: isDark ? darkPath : lightPath,
    //   width: width,
    //   height: height,
    //   scale: scale,
    //   fit: fit,
    //   alignment: alignment,
    //   color: color,
    //   package: package,
    //   borderRadius: borderRadius,
    //   shape: shape,
    //   clipBehavior: clipBehavior,
    //   fallback: fallback,
    //   fallbackIcon: fallbackIcon,
    //   fallbackIconSize: fallbackIconSize,
    //   fallbackIconColor: fallbackIconColor,
    //   showLoadingForSvg: showLoadingForSvg,
    // );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: CustomAppImage(
        key: ValueKey(isDark ? darkPath : lightPath),
        path: isDark ? darkPath : lightPath,
        width: width,
        height: height,
        scale: scale,
        fit: fit,
        alignment: alignment,
        color: color,
        package: package,
        borderRadius: borderRadius,
        shape: shape,
        clipBehavior: clipBehavior,
        fallback: fallback,
        fallbackIcon: fallbackIcon,
        fallbackIconSize: fallbackIconSize,
        fallbackIconColor: fallbackIconColor,
        showLoadingForSvg: showLoadingForSvg,
      ),
    );
  }
}
