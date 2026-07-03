import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';

class ContentAssetViewer extends StatelessWidget {
  final ContentDetailsUiData data;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPdfPagesCountChanged;
  final VoidCallback onViewerTap;

  const ContentAssetViewer({
    super.key,
    required this.data,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onPdfPagesCountChanged,
    required this.onViewerTap,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isFile) {
      return _PdfAssetViewer(
        data: data,
        onPdfPagesCountChanged: onPdfPagesCountChanged,
        onPageChanged: onPageChanged,
        onViewerTap: onViewerTap,
      );
    }

    final assets = data.assets;

    if (assets.isEmpty) {
      return _ImageAssetPage(url: '');
    }

    return ScrollConfiguration(
      behavior: const _ContentDetailsScrollBehavior(),
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        physics: const PageScrollPhysics(),
        itemCount: assets.length,
        onPageChanged: onPageChanged,
        itemBuilder: (_, index) {
          return _ImageTapWrapper(
            onTap: onViewerTap,
            child: _ImageAssetPage(url: assets[index].url),
          );
        },
      ),
    );
  }
}

class _ImageAssetPage extends StatelessWidget {
  final String url;

  const _ImageAssetPage({required this.url});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppPalette.black : AppPalette.white,
      padding: EdgeInsets.only(
        top: SizeConfig.h(0.070),
        left: SizeConfig.w(0.020),
        right: SizeConfig.w(0.020),
        bottom: SizeConfig.h(0.11),
      ),
      child: Center(child: _RoundedContainedImage(url: url)),
    );
  }
}

class _RoundedContainedImage extends StatelessWidget {
  final String url;

  const _RoundedContainedImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider(url);

    return FutureBuilder<Size>(
      future: _getImageSize(imageProvider),
      builder: (context, snapshot) {
        final imageSize = snapshot.data;

        if (imageSize == null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: CustomAppImage(path: url, fit: BoxFit.contain),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final imageRatio = imageSize.width / imageSize.height;
            final availableRatio = constraints.maxWidth / constraints.maxHeight;

            double width;
            double height;

            if (imageRatio > availableRatio) {
              width = constraints.maxWidth;
              height = width / imageRatio;
            } else {
              height = constraints.maxHeight;
              width = height * imageRatio;
            }

            return SizedBox(
              width: width,
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: CustomAppImage(
                  path: url,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }

  ImageProvider _imageProvider(String path) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');

    if (isNetwork) {
      return NetworkImage(path);
    }

    return AssetImage(path);
  }

  Future<Size> _getImageSize(ImageProvider provider) {
    final completer = Completer<Size>();
    final stream = provider.resolve(const ImageConfiguration());

    late final ImageStreamListener listener;

    listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        final size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );

        stream.removeListener(listener);

        if (!completer.isCompleted) {
          completer.complete(size);
        }
      },
      onError: (error, stackTrace) {
        stream.removeListener(listener);

        if (!completer.isCompleted) {
          completer.complete(const Size(1, 1));
        }
      },
    );

    stream.addListener(listener);

    return completer.future;
  }
}

class _PdfAssetViewer extends StatefulWidget {
  final ContentDetailsUiData data;
  final ValueChanged<int> onPdfPagesCountChanged;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onViewerTap;

  const _PdfAssetViewer({
    required this.data,
    required this.onPdfPagesCountChanged,
    required this.onPageChanged,
    required this.onViewerTap,
  });

  @override
  State<_PdfAssetViewer> createState() => _PdfAssetViewerState();
}

class _PdfAssetViewerState extends State<_PdfAssetViewer> {
  PdfController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.data.assets.isEmpty) return;

    final pdfUrl = _resolveUrl(widget.data.assets.first.url);

    _controller = PdfController(
      document: PdfDocument.openData(
        NetworkAssetBundle(
          Uri.parse(pdfUrl),
        ).load(pdfUrl).then((data) => data.buffer.asUint8List()),
      ),
    );
  }

  String _resolveUrl(String url) {
    if (url.startsWith('http://localhost')) {
      if (!kIsWeb && Platform.isAndroid) {
        return url.replaceFirst('http://localhost', 'http://10.0.2.2');
      }
    }

    return url;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onViewerTap,
      child: Container(
        color: isDark ? AppPalette.black : AppPalette.white,
        padding: EdgeInsets.only(
          top: SizeConfig.h(0.070),
          left: SizeConfig.w(0.020),
          right: SizeConfig.w(0.020),
          bottom: SizeConfig.h(0.11),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: PdfView(
            controller: _controller!,
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            onDocumentLoaded: (document) {
              widget.onPdfPagesCountChanged(document.pagesCount);
            },
            onPageChanged: (page) {
              widget.onPageChanged((page - 1).clamp(0, page));
            },
          ),
        ),
      ),
    );
  }
}

class _ContentDetailsScrollBehavior extends MaterialScrollBehavior {
  const _ContentDetailsScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

class _ImageTapWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ImageTapWrapper({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (recognizer) {
                recognizer.onTap = onTap;
              },
            ),
      },
      child: child,
    );
  }
}
