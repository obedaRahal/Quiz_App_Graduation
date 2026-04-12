import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class IntroNextButton extends StatelessWidget {
  final VoidCallback onTap;

  const IntroNextButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      borderRadius: 30,
      childHorizontalPad: SizeConfig.w(.03),
      childVerticalPad: SizeConfig.w(.03),
      backgroundColor: AppPalette.primary,
      onTap: onTap,
      child: const Icon(
        Icons.arrow_forward_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}