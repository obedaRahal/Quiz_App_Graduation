import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';

import '../theme/assets/fonts.dart';
import '../theme/color/app_colors.dart';
import 'media_query_config.dart';

OverlayEntry? _currentValidationSnackBar;

enum AppValidationSnackBarType { success, error }

void showValidationTopSnackBar(
  BuildContext context, {
  required String title,
  required String message,
  required AppValidationSnackBarType type,
  String? assetPath,
  Duration displayDuration = const Duration(seconds: 3),
}) {
  _currentValidationSnackBar?.remove();
  _currentValidationSnackBar = null;

  final overlay = Overlay.of(context, rootOverlay: true);
  if (overlay == null) return;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _ValidationSnackBarOverlay(
      title: title,
      message: message,
      type: type,
      assetPath: assetPath,
      displayDuration: displayDuration,
      onDismissed: () {
        entry.remove();
        if (_currentValidationSnackBar == entry) {
          _currentValidationSnackBar = null;
        }
      },
    ),
  );

  _currentValidationSnackBar = entry;
  overlay.insert(entry);
}

class _ValidationSnackBarOverlay extends StatefulWidget {
  final String title;
  final String message;
  final AppValidationSnackBarType type;
  final String? assetPath;
  final Duration displayDuration;
  final VoidCallback onDismissed;

  const _ValidationSnackBarOverlay({
    required this.title,
    required this.message,
    required this.type,
    required this.assetPath,
    required this.displayDuration,
    required this.onDismissed,
  });

  @override
  State<_ValidationSnackBarOverlay> createState() =>
      _ValidationSnackBarOverlayState();
}

class _ValidationSnackBarOverlayState extends State<_ValidationSnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  Timer? _timer;
  bool _dismissedBySwipe = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 220),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.28), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    _timer = Timer(widget.displayDuration, () async {
      if (!mounted || _dismissedBySwipe) return;
      await _controller.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final style = _resolveStyle(widget.type);

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.03),
                vertical: SizeConfig.h(0.01),
              ),
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.up,
                onDismissed: (_) async {
                  _dismissedBySwipe = true;
                  _timer?.cancel();
                  widget.onDismissed();
                },
                child: Material(
                  color: Colors.transparent,
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: SizeConfig.h(0.09),
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppPalette.greyLight,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.w(0.035),
                                vertical: SizeConfig.h(0.014),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CustomTextWidget(
                                          textDirection: TextDirection.ltr,
                                          widget.title,
                                          textAlign: TextAlign.right,
                                          color: style.mainColor,
                                          fontSize: SizeConfig.text(0.034),
                                          fontFamily: AppFont.elMessiriSemiBold,
                                        ),
                                        SizedBox(height: SizeConfig.h(0.004)),
                                        CustomTextWidget(
                                          widget.message,
                                          textAlign: TextAlign.right,
                                          color: AppPalette.black,
                                          fontSize: SizeConfig.text(0.028),
                                          fontFamily: AppFont.elMessiriRegular,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: SizeConfig.w(0.025)),
                                  _SnackBarLeadingIcon(
                                    assetPath: widget.assetPath ?? style.defaultAssetPath,
                                    fallbackIcon: style.fallbackIcon,
                                    fallbackColor: style.mainColor,
                                  ),
                                  SizedBox(width: SizeConfig.w(0.01)),
                                ],
                              ),
                            ),
                            PositionedDirectional(
                              top: 0,
                              bottom: 0,
                              end: 0,
                              child: Container(
                                width: 10,
                                color: style.mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnackBarLeadingIcon extends StatelessWidget {
  final String? assetPath;
  final IconData fallbackIcon;
  final Color fallbackColor;

  const _SnackBarLeadingIcon({
    required this.assetPath,
    required this.fallbackIcon,
    required this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath == null || assetPath!.trim().isEmpty) {
      return Icon(fallbackIcon, color: fallbackColor, size: 28);
    }

    return SizedBox(
      width: 28,
      height: 28,
      child: CustomAppImage(
        path: assetPath!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        fallback: Icon(fallbackIcon, color: fallbackColor, size: 28),
      ),
    );
  }
}

class _SnackBarStyle {
  final Color mainColor;
  final IconData fallbackIcon;
  final String defaultAssetPath;

  const _SnackBarStyle({
    required this.mainColor,
    required this.fallbackIcon,
    required this.defaultAssetPath,
  });
}

_SnackBarStyle _resolveStyle(AppValidationSnackBarType type) {
  switch (type) {
    case AppValidationSnackBarType.success:
      return _SnackBarStyle(
        mainColor: Color(0xFF63D64E),
        fallbackIcon: Icons.check_circle_outline_rounded,
        defaultAssetPath: AppImage.truecheck,
      );

    case AppValidationSnackBarType.error:
      return _SnackBarStyle(
        mainColor: Color(0xFFFF5C5C),
        fallbackIcon: Icons.error_outline_rounded,
        defaultAssetPath: AppImage.falsecheck,
      );
  }
}
