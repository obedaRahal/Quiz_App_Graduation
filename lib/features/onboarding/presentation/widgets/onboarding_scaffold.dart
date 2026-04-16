import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/arrow_back.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/utils/media_query_config.dart';
import 'animated_onboarding_progress_bar.dart';

class OnboardingScaffold extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  final String? title;
  final String? description;

  final Widget child;

  final VoidCallback onNext;
  final String nextButtonText;
  final bool isNextEnabled;
  final bool isSubmitting;

  final VoidCallback? onBack;

  const OnboardingScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.title,
    this.description,
    required this.child,
    required this.onNext,
    this.nextButtonText = 'التالي',
    this.isNextEnabled = true,
    this.isSubmitting = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final hasTitle = title != null && title!.trim().isNotEmpty;
    final hasDescription =
        description != null && description!.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.w(0.03),
            right: SizeConfig.w(0.03),
            bottom: SizeConfig.w(0.03),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ArrowBack(onTap: onBack),
              AnimatedOnboardingProgressBar(
                currentStep: currentStep,
                totalSteps: 5,
              ),
              //SizedBox(height: SizeConfig.h(0.025)),
              if (hasTitle) ...[
                SizedBox(height: SizeConfig.h(0.02)),
                CustomTextWidget(
                  title!,
                  textAlign: TextAlign.right,
                  fontSize: SizeConfig.text(0.045),
                  fontWeight: FontWeight.bold,
                ),
              ],

              if (hasDescription) ...[
                SizedBox(height: SizeConfig.h(0.01)),
                CustomTextWidget(
                  description!,
                  textAlign: TextAlign.right,
                  color: AppPalette.greyMedium,
                  fontSize: SizeConfig.text(0.035),
                ),
              ],
              SizedBox(height: SizeConfig.h(0.03)),
              Expanded(child: SingleChildScrollView(child: child)),
              SizedBox(height: SizeConfig.h(0.015)),
              CustomButtonWidget(
                childVerticalPad: SizeConfig.h(0.01),
                width: double.infinity,
                borderRadius: 10,
                backgroundColor: isNextEnabled
                    ? AppPalette.primary
                    : AppPalette.greyLight,
                onTap: isNextEnabled && !isSubmitting ? onNext : () {},
                child: isSubmitting
                    ? SizedBox(
                        width: SizeConfig.w(0.1),
                        height: SizeConfig.h(0.049),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : CustomTextWidget(
                        nextButtonText,
                        color: isNextEnabled
                            ? AppPalette.white
                            : AppPalette.greyMedium,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}