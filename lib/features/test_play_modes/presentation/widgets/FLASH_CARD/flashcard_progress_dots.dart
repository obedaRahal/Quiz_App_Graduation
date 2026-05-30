import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class FlashcardProgressDots extends StatelessWidget {
  final TestPlayModesState state;

  const FlashcardProgressDots({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.03),
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
        itemCount: state.questions.length,
        separatorBuilder: (_, __) => SizedBox(width: SizeConfig.w(0.018)),
        itemBuilder: (context, index) {
          final question = state.questions[index];
          final isCurrent =
              state.currentFlashcardQuestion?.questionId == question.questionId;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: isCurrent ? SizeConfig.w(0.045) : SizeConfig.w(0.035),
            height: isCurrent ? SizeConfig.w(0.045) : SizeConfig.w(0.035),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _dotColor(state, question.questionId),
              border: isCurrent
                  ? Border.all(color: AppPalette.primary, width: 2)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Color _dotColor(TestPlayModesState state, int questionId) {
    if (state.flashcardKnownQuestionIds.contains(questionId)) {
      return AppPalette.green;
    }

    if (state.flashcardUnknownQuestionIds.contains(questionId)) {
      return AppPalette.red;
    }

    return AppPalette.greyLight;
  }
}
