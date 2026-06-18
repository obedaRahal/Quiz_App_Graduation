import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ChallengeNextButton extends StatelessWidget {
  final void Function()? onNextQuestion;
  const ChallengeNextButton({super.key, required this.onNextQuestion});

  @override
  Widget build(BuildContext context) {
        final appColors = context.appColors;

    return GestureDetector(
      onTap: onNextQuestion,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        height: SizeConfig.h(0.05),
        alignment: Alignment.center,
        backgroundColor: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(16),
        child: CustomTextWidget(
          'التالي',
          color: appColors.primaryToPrimaryDark,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.035),
        ),
      ),
    );
  }
}
