import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestsByInterestSectionTitle extends StatelessWidget {
  final String title;

  const TestsByInterestSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Row(
        children: [
          const Expanded(child: _DashedLine()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(0.035),
                vertical: SizeConfig.h(0.004),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF3FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: CustomTextWidget(
                title,
                fontSize: SizeConfig.text(0.027),
                fontWeight: FontWeight.bold,
                color: AppPalette.primary,
              ),
            ),
          ),
          const Expanded(child: _DashedLine()),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / 12).floor();

        return Row(
          children: List.generate(
            count,
            (_) => Expanded(
              child: Container(
                height: 1.6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: AppPalette.primary.withOpacity(0.55),
              ),
            ),
          ),
        );
      },
    );
  }
}
