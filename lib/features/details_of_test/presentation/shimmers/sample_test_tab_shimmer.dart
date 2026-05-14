import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SampleTestTabShimmer extends StatelessWidget {
  final int itemCount;

  const SampleTestTabShimmer({
    super.key,
    this.itemCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.h(0.015)),
          child: const SampleQuestionCardShimmer(),
        );
      }),
    );
  }
}


class SampleQuestionCardShimmer extends StatelessWidget {
  const SampleQuestionCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF1F2933)
        : const Color(0xFFEDEFF3);

    final highlightColor = isDark
        ? const Color(0xFF2D3742)
        : const Color(0xFFF7F8FA);

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: isDark ? AppPalette.black : AppPalette.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: appColors.borderFieldColorNLightToborderFieldColorNDark,
      ),
      childVerticalPad: SizeConfig.h(0.015),
      childHorizontalPad: SizeConfig.w(0.022),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(
                width: SizeConfig.w(0.16),
                height: SizeConfig.h(0.022),
                borderRadius: 8,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              _ShimmerBox(
                width: SizeConfig.w(0.12),
                height: SizeConfig.h(0.028),
                borderRadius: 10,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.018)),

          _ShimmerBox(
            width: double.infinity,
            height: SizeConfig.h(0.022),
            borderRadius: 8,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),

          SizedBox(height: SizeConfig.h(0.01)),

          _ShimmerBox(
            width: SizeConfig.w(0.65),
            height: SizeConfig.h(0.022),
            borderRadius: 8,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),

          SizedBox(height: SizeConfig.h(0.018)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerBox(
                width: SizeConfig.w(0.08),
                height: SizeConfig.h(0.03),
                borderRadius: 20,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              _ShimmerBox(
                width: SizeConfig.w(0.18),
                height: SizeConfig.h(0.024),
                borderRadius: 8,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          ...List.generate(4, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
              child: _ShimmerBox(
                width: double.infinity,
                height: SizeConfig.h(0.045),
                borderRadius: 6,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
            );
          }),
        ],
      ),
    );
  }
}


class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.borderRadius);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}