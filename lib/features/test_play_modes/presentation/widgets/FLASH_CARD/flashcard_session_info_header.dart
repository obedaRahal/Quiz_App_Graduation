import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class FlashcardSessionInfoHeader extends StatelessWidget {
  final TestPlayModesState state;

  const FlashcardSessionInfoHeader({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Row(
        children: [
          CustomBackgroundWithChild(
            backgroundColor: appColors.primarySoftTogreyLightDark,
            borderRadius: BorderRadius.circular(20),
            childHorizontalPad: SizeConfig.w(0.03),
            childVerticalPad: SizeConfig.h(0.004),
            child: CustomTextWidget(
              'المتبقي ${state.flashcardRemainingCards}',
              color: appColors.primaryToPrimaryDark,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.028),
            ),
          ),

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
                  text: '${state.flashcardKnownCardsCount}',
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
