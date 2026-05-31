import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

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
  final Color? fallbackBackgroundColor;

  final bool showLoadingForSvg;
  final bool showLoadingForNetwork;

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
    this.fallbackBackgroundColor,
    this.showLoadingForSvg = false,
    this.showLoadingForNetwork = true,
  });

  bool get _isSvg => path.toLowerCase().endsWith('.svg');

  bool get _isNetwork =>
      path.startsWith('http://') || path.startsWith('https://');

  // String get _resolvedPath {
  //   if (path.startsWith('http://localhost')) {
  //     return path.replaceFirst('http://localhost', 'http://10.0.2.2');
  //   }

  //   return path;
  // }

  bool get _isLottie => path.toLowerCase().endsWith('.json');

  bool get _isGif => path.toLowerCase().endsWith('.gif');

  String get _resolvedPath => path;

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isLottie
        ? _buildLottie(context)
        : _isSvg
        ? _buildSvg(context)
        : _buildRaster(context);
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

  Widget _buildLottie(BuildContext context) {
    if (_isNetwork) {
      return Lottie.network(
        _resolvedPath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _buildFallback(context),
      );
    }

    return Lottie.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      errorBuilder: (_, __, ___) => _buildFallback(context),
    );
  }

  Widget _buildRaster(BuildContext context) {
    if (_isNetwork) {
      return Image.network(
        _resolvedPath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        errorBuilder: (_, __, ___) => _buildFallback(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          if (!showLoadingForNetwork) {
            return SizedBox(width: width, height: height);
          }

          return _buildLoading();
        },
      );
    }

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

  Widget _buildSvg(BuildContext context) {
    if (_isNetwork) {
      return SvgPicture.network(
        _resolvedPath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
        placeholderBuilder: (_) => _buildSvgPlaceholder(),
        errorBuilder: (_, __, ___) => _buildFallback(context),
      );
    }

    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
      placeholderBuilder: (_) => _buildSvgPlaceholder(),
    );
  }

  Widget _buildSvgPlaceholder() {
    if (!showLoadingForSvg) {
      return SizedBox(width: width, height: height);
    }

    return _buildLoading();
  }

  Widget _buildLoading() {
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

    return Container(
      width: width,
      height: height,
      color:
          fallbackBackgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(fallbackIcon, size: resolvedSize, color: resolvedColor),
      ),
    );
  }
}
