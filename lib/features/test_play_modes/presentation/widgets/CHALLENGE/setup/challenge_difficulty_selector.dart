import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/setup/difficulty_chip.dart';

class ChallengeDifficultySelector extends StatelessWidget {
  final ChallengeDifficulty selectedDifficulty;
  final ValueChanged<ChallengeDifficulty> onChanged;

  const ChallengeDifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'مستوى التحدي',
          color: appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.04),
        ),
        SizedBox(height: SizeConfig.h(0.01)),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            DifficultyChip(
              title: 'سهل',
              difficulty: ChallengeDifficulty.easy,
              selectedDifficulty: selectedDifficulty,
              onChanged: onChanged,
            ),
            SizedBox(width: SizeConfig.w(0.02)),
            DifficultyChip(
              title: 'متوسط',
              difficulty: ChallengeDifficulty.medium,
              selectedDifficulty: selectedDifficulty,
              onChanged: onChanged,
            ),
            SizedBox(width: SizeConfig.w(0.02)),
            DifficultyChip(
              title: 'صعب',
              difficulty: ChallengeDifficulty.hard,
              selectedDifficulty: selectedDifficulty,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}
