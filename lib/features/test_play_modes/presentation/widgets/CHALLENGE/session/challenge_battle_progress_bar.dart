import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class ChallengeBattleProgressBar extends StatelessWidget {
  final TestPlayModesState state;

  const ChallengeBattleProgressBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalScore = state.challengeUserScore + state.challengeBotScore;
    final userRatio = totalScore == 0
        ? 0.5
        : state.challengeUserScore / totalScore;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: SizeConfig.h(0.014),
          width: double.infinity,
          color: AppPalette.greyLight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * (1 - userRatio),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB657FF), Color(0xFFD46BFF)],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * userRatio,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF6A5AE0)],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}