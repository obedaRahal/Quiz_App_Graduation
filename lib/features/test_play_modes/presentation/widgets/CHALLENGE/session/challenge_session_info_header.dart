import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class ChallengeSessionInfoHeader extends StatelessWidget {
  final TestPlayModesState state;

  const ChallengeSessionInfoHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Row(
        children: [
          _ChallengeTimePill(seconds: state.challengeQuestionRemainingSeconds),
          const Spacer(),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${state.totalQuestions}',
                  style: TextStyle(
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.05),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
                TextSpan(
                  text: '\\',
                  style: TextStyle(
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.06),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
                TextSpan(
                  text: '${state.currentQuestionNumber}',
                  style: TextStyle(
                    color: appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.07),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeTimePill extends StatelessWidget {
  final int seconds;

  const _ChallengeTimePill({required this.seconds});

  String get formattedTime {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              'مؤقت',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.025),
            ),
            CustomTextWidget(
              formattedTime,
              color: appColors.blackToGrey2Dark,
              fontSize: SizeConfig.text(0.032),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        SizedBox(width: SizeConfig.w(0.015)),
        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderRadius: BorderRadius.circular(30),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.01),
            vertical: SizeConfig.w(0.01),
          ),
          child: Icon(
            Icons.timer_outlined,
            size: SizeConfig.h(0.03),
            color: AppPalette.primary,
          ),
        ),
      ],
    );
  }
}
