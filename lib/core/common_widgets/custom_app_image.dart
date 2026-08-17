import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app_grad/core/utils/media_url_resolver.dart';

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

  final Widget? fallback;

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

  bool get _isLottie => path.toLowerCase().endsWith('.json');

  String get _resolvedPath => resolveMediaUrl(path);

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
      return _SafeNetworkSvg(
        url: _resolvedPath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
        placeholder: _buildSvgPlaceholder(),
        fallback: _buildFallback(context),
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

    final resolvedSize = _resolveFallbackIconSize();

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

  double _resolveFallbackIconSize() {
    final explicitSize = fallbackIconSize;
    if (explicitSize != null &&
        explicitSize.isFinite &&
        explicitSize >= 0) {
      return explicitSize;
    }

    final finiteDimensions = <double>[
      if (width != null && width!.isFinite && width! > 0) width!,
      if (height != null && height!.isFinite && height! > 0) height!,
    ];

    if (finiteDimensions.isEmpty) return 28;

    final smallestDimension = finiteDimensions.reduce(
      (first, second) => first < second ? first : second,
    );
    final calculatedSize = smallestDimension * 0.45;

    return calculatedSize.clamp(12.0, 72.0).toDouble();
  }
}

class _SafeNetworkSvg extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final ColorFilter? colorFilter;
  final Widget placeholder;
  final Widget fallback;

  const _SafeNetworkSvg({
    required this.url,
    required this.width,
    required this.height,
    required this.fit,
    required this.alignment,
    required this.colorFilter,
    required this.placeholder,
    required this.fallback,
  });

  @override
  State<_SafeNetworkSvg> createState() => _SafeNetworkSvgState();
}

class _SafeNetworkSvgState extends State<_SafeNetworkSvg> {
  late Future<Uint8List> _svgBytesFuture;

  @override
  void initState() {
    super.initState();
    _svgBytesFuture = _loadSvgBytes(widget.url);
  }

  @override
  void didUpdateWidget(covariant _SafeNetworkSvg oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _svgBytesFuture = _loadSvgBytes(widget.url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _svgBytesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.placeholder;
        }

        final bytes = snapshot.data;
        if (snapshot.hasError || bytes == null || bytes.isEmpty) {
          return widget.fallback;
        }

        return SvgPicture.memory(
          bytes,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
          colorFilter: widget.colorFilter,
          errorBuilder: (_, __, ___) => widget.fallback,
        );
      },
    );
  }
}

Future<Uint8List> _loadSvgBytes(String rawUrl) async {
  final uri = Uri.tryParse(rawUrl);

  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
    throw const FormatException('Invalid network SVG URL.');
  }

  final data = await NetworkAssetBundle(uri).load(uri.toString());
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  if (!_hasSvgRoot(bytes)) {
    throw const FormatException('Network response is not an SVG document.');
  }

  return bytes;
}

bool _hasSvgRoot(Uint8List bytes) {
  var content = utf8.decode(bytes, allowMalformed: true).trimLeft();

  if (content.startsWith('\uFEFF')) {
    content = content.substring(1).trimLeft();
  }

  while (content.startsWith('<?xml') || content.startsWith('<!--')) {
    final closingToken = content.startsWith('<?xml') ? '?>' : '-->';
    final closingIndex = content.indexOf(closingToken);

    if (closingIndex < 0) {
      return false;
    }

    content = content.substring(closingIndex + closingToken.length).trimLeft();
  }

  if (content.toLowerCase().startsWith('<!doctype')) {
    final closingIndex = content.indexOf('>');
    if (closingIndex < 0) {
      return false;
    }
    content = content.substring(closingIndex + 1).trimLeft();
  }

  final normalized = content.toLowerCase();
  if (!normalized.startsWith('<svg') || normalized.length == 4) {
    return false;
  }

  final nextCharacter = normalized[4];
  return nextCharacter == '>' ||
      nextCharacter == ' ' ||
      nextCharacter == '\n' ||
      nextCharacter == '\r' ||
      nextCharacter == '\t';
}
