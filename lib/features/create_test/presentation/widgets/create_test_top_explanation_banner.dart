import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

OverlayEntry? _currentTopBannerEntry;
Timer? _topBannerTimer;

void showTopExplanationBanner({
  required BuildContext context,
  required String message,
  String title = 'الشرح',
  Duration duration = const Duration(seconds: 4),
}) {
  _currentTopBannerEntry?.remove();
  _currentTopBannerEntry = null;
  _topBannerTimer?.cancel();

  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder: (_) => _TopExplanationBannerOverlay(
      title: title,
      message: message,
    ),
  );

  _currentTopBannerEntry = entry;
  overlay.insert(entry);

  _topBannerTimer = Timer(duration, () {
    _currentTopBannerEntry?.remove();
    _currentTopBannerEntry = null;
    _topBannerTimer?.cancel();
    _topBannerTimer = null;
  });
}

class _TopExplanationBannerOverlay extends StatelessWidget {
  final String title;
  final String message;

  const _TopExplanationBannerOverlay({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appColors = context.appColors;

    return Positioned(
      top: MediaQuery.of(context).padding.top + SizeConfig.h(0.012),
      left: SizeConfig.w(0.035),
      right: SizeConfig.w(0.035),
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(
            begin: const Offset(0, -0.35),
            end: Offset.zero,
          ),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: Offset(0, offset.dy * 120),
              child: child,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.030),
              vertical: SizeConfig.h(0.014),
            ),
            decoration: BoxDecoration(
              color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark
                    ? AppPalette.borderFieldColorNDark
                    : AppPalette.borderFieldColorNLight,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.24 : 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.w(0.115),
                  height: SizeConfig.w(0.115),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppPalette.greyMediumDark
                        : AppPalette.primarySoft,
                    border: Border.all(
                      color: appColors.primaryToPrimaryDark.withOpacity(0.35),
                    ),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline_rounded,
                    size: SizeConfig.text(0.052),
                    color: appColors.primaryToPrimaryDark,
                  ),
                ),

                SizedBox(width: SizeConfig.w(0.025)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomTextWidget(
                        title,
                        fontSize: SizeConfig.text(0.033),
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? AppPalette.textWhiteINDark
                            : AppPalette.textColorInHome,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                      ),

                      SizedBox(height: SizeConfig.h(0.004)),

                      CustomTextWidget(
                        message,
                        fontSize: SizeConfig.text(0.028),
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppPalette.titleWhiteINDark
                            : AppPalette.greyMedium,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}