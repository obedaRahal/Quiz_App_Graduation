import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';

class IntroPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const IntroPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      onDotClicked: (index) {
        controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      },
      effect: CustomizableEffect(
        spacing: 8,
        inActiveColorOverride: (_) => AppPalette.greyLight,
        dotDecoration: DotDecoration(
          width: 8,
          height: 8,
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        activeDotDecoration: DotDecoration(
          width: 10,
          height: 10,
          color: AppPalette.greyMedium,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}