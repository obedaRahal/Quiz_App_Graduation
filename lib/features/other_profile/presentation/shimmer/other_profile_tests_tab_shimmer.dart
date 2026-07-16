import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/app_shimmer_box.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class OtherProfileTestsTabShimmer extends StatelessWidget {
  final int count;
  final double horizonalPadding;
  const OtherProfileTestsTabShimmer({
    super.key,
    this.count = 3,
    this.horizonalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...List.generate(
            count,
            (_) => Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.h(0.014),
                left: horizonalPadding,
                right: horizonalPadding,
              ),
              child: const OtherProfileTestCardShimmer(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestsFilterSectionShimmer extends StatelessWidget {
  const _TestsFilterSectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          textDirection: TextDirection.rtl,
          children: List.generate(
            4,
            (_) => Padding(
              padding: EdgeInsets.only(left: SizeConfig.w(0.03)),
              child: AppShimmerBox(
                width: SizeConfig.w(0.20),
                height: SizeConfig.h(0.036),
                borderRadius: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtherProfileTestCardShimmer extends StatelessWidget {
  final double? horizonMargin;

  const OtherProfileTestCardShimmer({super.key, this.horizonMargin = 0});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: SizeConfig.h(0.17),
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(horizonMargin ?? 0),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipPath(
          clipper: _ExamTicketClipper(),
          child: Container(
            color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.026),
              vertical: SizeConfig.h(0.014),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _PricePanelShimmer(isDark: isDark)),
                SizedBox(width: SizeConfig.w(0.010)),
                _DashedVerticalDividerShimmer(isDark: isDark),
                SizedBox(width: SizeConfig.w(0.010)),
                Expanded(flex: 7, child: _InfoPanelShimmer(isDark: isDark)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoPanelShimmer extends StatelessWidget {
  final bool isDark;

  const _InfoPanelShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _InnerLeftPanelClipper(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.032),
          vertical: SizeConfig.h(0.012),
        ),
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF3F6FF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.34),
                  height: SizeConfig.h(0.021),
                  borderRadius: 7,
                ),
                const Spacer(),
                AppShimmerBox(
                  width: SizeConfig.w(0.12),
                  height: SizeConfig.h(0.022),
                  borderRadius: 4,
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            AppShimmerBox(
              width: double.infinity,
              height: SizeConfig.h(0.014),
              borderRadius: 6,
            ),
            SizedBox(height: SizeConfig.h(0.007)),
            AppShimmerBox(
              width: SizeConfig.w(0.38),
              height: SizeConfig.h(0.014),
              borderRadius: 6,
            ),

            const Spacer(),

            Row(
              children: [
                AppShimmerBox(
                  width: SizeConfig.w(0.15),
                  height: SizeConfig.h(0.022),
                  borderRadius: 4,
                ),
                SizedBox(width: SizeConfig.w(0.010)),
                AppShimmerBox(
                  width: SizeConfig.w(0.13),
                  height: SizeConfig.h(0.022),
                  borderRadius: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PricePanelShimmer extends StatelessWidget {
  final bool isDark;

  const _PricePanelShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _InnerRightPanelClipper(),
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.012),
        ),
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFF7F7F7),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppShimmerBox(
                width: SizeConfig.w(0.16),
                height: SizeConfig.h(0.028),
                borderRadius: 7,
              ),
              SizedBox(height: SizeConfig.h(0.006)),
              AppShimmerBox(
                width: SizeConfig.w(0.14),
                height: SizeConfig.h(0.014),
                borderRadius: 6,
              ),
              SizedBox(height: SizeConfig.h(0.018)),
              AppShimmerBox(
                width: SizeConfig.w(0.13),
                height: SizeConfig.h(0.019),
                borderRadius: 6,
              ),
              SizedBox(height: SizeConfig.h(0.008)),
              AppShimmerBox(
                width: SizeConfig.w(0.10),
                height: SizeConfig.h(0.017),
                borderRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedVerticalDividerShimmer extends StatelessWidget {
  final bool isDark;

  const _DashedVerticalDividerShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      height: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.maxHeight / 12).floor();

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              dashCount,
              (_) => Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppPalette.borderFieldColorNDark
                      : const Color(0xFFB8BEC8),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InnerRightPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const corner = 10.0;

    final path = Path()
      ..moveTo(corner, 0)
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      )
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    path.addOval(
      Rect.fromCenter(
        center: Offset(size.width, size.height / 2),
        width: size.width * 0.45,
        height: size.height * 0.45,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _InnerLeftPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const corner = 10.0;

    final path = Path()
      ..moveTo(corner, 0)
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      )
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    path.addOval(
      Rect.fromCenter(
        center: Offset(0, size.height / 2),
        width: size.width * 0.18,
        height: size.height * 0.45,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ExamTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const corner = 10.0;
    const topCutRadius = 8.0;
    final sideCutRadius = size.height * 0.15;

    final path = Path()..moveTo(corner, 0);

    final topCuts = [0.08, 0.22, 0.36, 0.50, 0.64];

    for (final ratio in topCuts) {
      final centerX = size.width * ratio;
      path.lineTo(centerX - topCutRadius, 0);
      path.arcToPoint(
        Offset(centerX + topCutRadius, 0),
        radius: const Radius.circular(topCutRadius),
        clockwise: false,
      );
    }

    path
      ..lineTo(size.width - corner, 0)
      ..quadraticBezierTo(size.width, 0, size.width, corner)
      ..lineTo(size.width, size.height - corner)
      ..quadraticBezierTo(
        size.width,
        size.height,
        size.width - corner,
        size.height,
      );

    for (final ratio in topCuts.reversed) {
      final centerX = size.width * ratio;
      path.lineTo(centerX + topCutRadius, size.height);
      path.arcToPoint(
        Offset(centerX - topCutRadius, size.height),
        radius: const Radius.circular(topCutRadius),
        clockwise: false,
      );
    }

    path
      ..lineTo(corner, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - corner)
      ..lineTo(0, corner)
      ..quadraticBezierTo(0, 0, corner, 0)
      ..close();

    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2),
        radius: sideCutRadius,
      ),
    );

    path.addOval(
      Rect.fromCircle(
        center: Offset(0, size.height / 2),
        radius: sideCutRadius,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
