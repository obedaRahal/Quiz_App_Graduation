
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class AnimatedOnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;
  final Duration duration;

  const AnimatedOnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 15,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              '${(progress * 100).toInt()}% مكتمل',
              fontSize: SizeConfig.text(0.05),
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                alignment: Alignment.centerRight,
                height: height,
                width: double.infinity,
                color: AppPalette.greyLight,
                child: Stack(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: progress),
                      duration: duration,
                      curve: Curves.easeInOutCubic,
                      builder: (context, value, child) {
                        return AnimatedContainer(
                          duration: duration,
                          curve: Curves.easeInOutCubic,
                          width: constraints.maxWidth * value,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                // AppPalette.primary,
                                // AppPalette.primaryDark,
                                Color(0xFF4A90E2),
                                Color(0xFF6A5AE0),
                                Color(0xFF8E6CFF),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                                color: Colors.blue.withOpacity(0.25),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextWidget(
              'خطوة : $currentStep من $totalSteps',
              fontSize: 14,
              color: AppPalette.greyMedium,
            ),
          ],
        );
      },
    );
  }
}
