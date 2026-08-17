import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_url_resolver.dart';

class ContentAssetThumbnail extends StatelessWidget {
  final String url;
  final String type;
  final BoxFit fit;
  final bool showLoading;
  final BorderRadius? borderRadius;

  const ContentAssetThumbnail({
    super.key,
    required this.url,
    required this.type,
    this.fit = BoxFit.cover,
    this.showLoading = true,
    this.borderRadius,
  });

  bool get _isPdf =>
      Uri.tryParse(url)?.path.toLowerCase().endsWith('.pdf') == true;

  bool get _isImage {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? '';
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp'];

    return imageExtensions.any(path.endsWith) || type.trim().contains('صورة');
  }

  @override
  Widget build(BuildContext context) {
    if (_isPdf) {
      return PdfFirstPageThumbnail(url: url, fit: fit);
    }

    if (_isImage) {
      return CustomAppImage(
        path: url,
        fit: fit,
        borderRadius: borderRadius,
        showLoadingForNetwork: showLoading,
        fallback: const _FileThumbnailFallback(),
      );
    }

    return const _FileThumbnailFallback();
  }
}

class PdfFirstPageThumbnail extends StatefulWidget {
  final String url;
  final BoxFit fit;

  const PdfFirstPageThumbnail({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  State<PdfFirstPageThumbnail> createState() => _PdfFirstPageThumbnailState();
}

class _PdfFirstPageThumbnailState extends State<PdfFirstPageThumbnail> {
  static final Map<String, Future<Uint8List?>> _thumbnailCache = {};
  late Future<Uint8List?> _thumbnail;

  @override
  void initState() {
    super.initState();
    _thumbnail = _loadThumbnail(widget.url);
  }

  @override
  void didUpdateWidget(covariant PdfFirstPageThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _thumbnail = _loadThumbnail(widget.url);
    }
  }

  Future<Uint8List?> _loadThumbnail(String rawUrl) {
    final url = resolveMediaUrl(rawUrl);

    return _thumbnailCache.putIfAbsent(url, () async {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) return null;

      PdfDocument? document;
      PdfPage? page;

      try {
        final data = await NetworkAssetBundle(uri).load(url);
        document = await PdfDocument.openData(data.buffer.asUint8List());
        page = await document.getPage(1);
        final image = await page.render(
          width: 480,
          height: 640,
          format: PdfPageImageFormat.jpeg,
          quality: 75,
        );

        return image?.bytes;
      } catch (_) {
        return null;
      } finally {
        await page?.close();
        await document?.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _thumbnail,
      builder: (context, snapshot) {
        final bytes = snapshot.data;

        if (bytes != null && bytes.isNotEmpty) {
          return Image.memory(
            bytes,
            fit: widget.fit,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        return const _FileThumbnailFallback();
      },
    );
  }
}

class _FileThumbnailFallback extends StatelessWidget {
  const _FileThumbnailFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppPalette.greyLight,
      child: Center(
        child: Icon(
          Icons.picture_as_pdf_rounded,
          color: AppPalette.red,
          size: 34,
        ),
      ),
    );
  }
}
