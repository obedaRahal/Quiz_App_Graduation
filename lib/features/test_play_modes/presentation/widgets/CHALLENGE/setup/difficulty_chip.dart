import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class DifficultyChip extends StatelessWidget {
  final String title;
  final ChallengeDifficulty difficulty;
  final ChallengeDifficulty selectedDifficulty;
  final ValueChanged<ChallengeDifficulty> onChanged;

  const DifficultyChip({
    super.key,
    required this.title,
    required this.difficulty,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isSelected = difficulty == selectedDifficulty;

    return Expanded(
      child: CustomButtonWidget(
        onTap: () => onChanged(difficulty),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: SizeConfig.h(0.03),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : appColors.primarySoftTogreyLightDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? appColors.primaryToPrimaryDark
                  : appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          child: CustomTextWidget(
            title,
            color: isSelected ? appColors.whiteToblack : appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.03),
          ),
        ),
      ),
    );
  }
}
