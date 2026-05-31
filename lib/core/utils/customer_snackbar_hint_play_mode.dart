import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import '../theme/assets/fonts.dart';
import '../theme/color/app_colors.dart';
import 'media_query_config.dart';

OverlayEntry? _currentCustomerSnackBarHintPlayMode;

void showCustomerSnackBarHintPlayMode(
  BuildContext context, {
  String title = 'السبب',
  required String message,
  IconData? icon,
  Color? iconColor,
  Duration displayDuration = const Duration(seconds: 4),
}) {
  _currentCustomerSnackBarHintPlayMode?.remove();
  _currentCustomerSnackBarHintPlayMode = null;

  final overlay = Overlay.of(context, rootOverlay: true);
  if (overlay == null) return;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => CustomerSnackBarHintPlayMode(
      title: title,
      message: message,
      icon: icon,
      iconColor: iconColor,
      displayDuration: displayDuration,
      onDismissed: () {
        entry.remove();
        if (_currentCustomerSnackBarHintPlayMode == entry) {
          _currentCustomerSnackBarHintPlayMode = null;
        }
      },
    ),
  );

  _currentCustomerSnackBarHintPlayMode = entry;
  overlay.insert(entry);
}

class CustomerSnackBarHintPlayMode extends StatefulWidget {
  final String title;
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final Duration displayDuration;
  final VoidCallback onDismissed;

  const CustomerSnackBarHintPlayMode({
    super.key,
    required this.title,
    required this.message,
    required this.displayDuration,
    required this.onDismissed,
    this.icon,
    this.iconColor,
  });

  @override
  State<CustomerSnackBarHintPlayMode> createState() =>
      _CustomerSnackBarHintPlayModeState();
}

class _CustomerSnackBarHintPlayModeState
    extends State<CustomerSnackBarHintPlayMode>
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
        Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero).animate(
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
      await _dismiss();
    });
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    _timer?.cancel();
    await _controller.reverse();
    widget.onDismissed();
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

    final iconColor = widget.iconColor ?? appHintBlue;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: SizeConfig.w(0.055),
                end: SizeConfig.w(0.055),
                top: SizeConfig.h(0.015),
              ),
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.up,
                onDismissed: (_) {
                  _dismissedBySwipe = true;
                  _timer?.cancel();
                  widget.onDismissed();
                },
                child: Material(
                  color: Colors.transparent,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: SizeConfig.h(0.065),
                      ),
                      padding: EdgeInsetsDirectional.only(
                        start: SizeConfig.w(0.028),
                        end: SizeConfig.w(0.028),
                        top: SizeConfig.h(0.02),
                        bottom: SizeConfig.h(0.02),
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteToGrey,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppPalette.greyMedium,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            spreadRadius: 0.2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _CustomerSnackBarHintIcon(
                            icon: widget.icon,
                            iconColor: iconColor,
                          ),

                          SizedBox(width: SizeConfig.w(0.022)),

                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  widget.title,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  color: AppPalette.black,
                                  fontSize: SizeConfig.text(0.032),
                                  fontFamily: AppFont.elMessiriBold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(height: SizeConfig.h(0.002)),

                                CustomTextWidget(
                                  widget.message,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  color: AppPalette.greyMedium,
                                  fontSize: SizeConfig.text(0.024),
                                  fontFamily: AppFont.elMessiriMedium,
                                  maxLines: 2,
                                  //overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
    );
  }
}

class _CustomerSnackBarHintIcon extends StatelessWidget {
  final IconData? icon;
  final Color iconColor;

  const _CustomerSnackBarHintIcon({
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.w(0.085),
      height: SizeConfig.w(0.085),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: iconColor.withOpacity(0.45), width: 1.2),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.lightbulb,
          color: iconColor,
          size: SizeConfig.w(0.045),
        ),
      ),
    );
  }
}

const Color appHintBlue = Color(0xFF7EA2FF);
