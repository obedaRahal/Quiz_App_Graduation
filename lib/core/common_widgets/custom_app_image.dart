import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppImage extends StatelessWidget {
  final String path;

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

  /// اختياري: إذا أردت تخصيص شكل الخطأ في حالة خاصة فقط
  final Widget? fallback;

  /// الشكل الافتراضي عند فشل تحميل الصورة
  final IconData fallbackIcon;
  final double? fallbackIconSize;
  final Color? fallbackIconColor;

  final bool showLoadingForSvg;

  const CustomAppImage({
    super.key,
    required this.path,
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

  bool get _isSvg => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isSvg ? _buildSvg(context) : _buildRaster(context);

    if (shape == BoxShape.circle) {
      return ClipOval(child: imageWidget);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        clipBehavior: clipBehavior,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildRaster(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      scale: scale,
      package: package,
      color: color,
      errorBuilder: (_, __, ___) => _buildFallback(context),
    );
  }

  // Widget _buildSvg(BuildContext context) {
  //   return SvgPicture.asset(
  //     path,
  //     width: width,
  //     height: height,
  //     fit: fit,
  //     alignment: alignment,
  //     colorFilter: color == null
  //         ? null
  //         : ColorFilter.mode(color!, BlendMode.srcIn),
  //     placeholderBuilder: (_) {
  //       if (!showLoadingForSvg) {
  //         return SizedBox(width: width, height: height);
  //       }

  //       return SizedBox(
  //         width: width,
  //         height: height,
  //         child: const Center(
  //           child: SizedBox(
  //             width: 18,
  //             height: 18,
  //             child: CircularProgressIndicator(strokeWidth: 2),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildSvg(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Transform.scale(
          scale: scale,
          alignment: alignment,
          child: SvgPicture.asset(
            path,
            width: width,
            height: height,
            fit: fit,
            alignment: alignment,
            colorFilter: color == null
                ? null
                : ColorFilter.mode(color!, BlendMode.srcIn),
            placeholderBuilder: (_) {
              if (!showLoadingForSvg) {
                return SizedBox(width: width, height: height);
              }

              return SizedBox(
                width: width,
                height: height,
                child: const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    if (fallback != null) return fallback!;

    final resolvedColor =
        fallbackIconColor ?? Theme.of(context).colorScheme.outline;

    final resolvedSize =
        fallbackIconSize ??
        ((width != null && height != null)
            ? ((width! < height! ? width! : height!) * 0.45)
            : 28);

    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Icon(fallbackIcon, size: resolvedSize, color: resolvedColor),
      ),
    );
  }
}
