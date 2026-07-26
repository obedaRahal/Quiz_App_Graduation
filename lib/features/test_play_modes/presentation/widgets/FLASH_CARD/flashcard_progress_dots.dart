import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class FlashcardProgressDots extends StatelessWidget {
  static const int _maximumDotsCount = 20;

  final TestPlayModesState state;

  const FlashcardProgressDots({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final totalQuestions = state.totalQuestions;

    if (totalQuestions == 0) {
      return SizedBox(height: SizeConfig.h(0.03));
    }

    final isAggregated = totalQuestions > _maximumDotsCount;
    final colors = isAggregated
        ? _buildAggregatedColors(appColors)
        : state.questions
              .map(
                (question) => _questionDotColor(question.questionId, appColors),
              )
              .toList(growable: false);

    return SizedBox(
      height: SizeConfig.h(0.03),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final slotWidth = availableWidth / colors.length;
            final maximumDotSize = slotWidth * 0.62;
            final dotSize = maximumDotSize < 6
                ? maximumDotSize
                : SizeConfig.w(0.035).clamp(6.0, maximumDotSize).toDouble();

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: List.generate(colors.length, (index) {
                final questionId = isAggregated
                    ? null
                    : state.questions[index].questionId;
                final isCurrent =
                    questionId != null &&
                    state.currentFlashcardQuestion?.questionId == questionId;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index],
                    border: isCurrent
                        ? Border.all(
                            color: appColors.primaryToPrimaryDark,
                            width: 2,
                          )
                        : null,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Color _questionDotColor(int questionId, AppThemeColors appColors) {
    if (state.flashcardKnownQuestionIds.contains(questionId)) {
      return AppPalette.green;
    }

    if (state.flashcardUnknownQuestionIds.contains(questionId)) {
      return AppPalette.red;
    }

    return appColors.greyToGreyMediumDark;
  }

  List<Color> _buildAggregatedColors(AppThemeColors appColors) {
    final total = state.totalQuestions;
    final known = state.flashcardKnownQuestionIds.length
        .clamp(0, total)
        .toInt();
    final unknown = state.flashcardUnknownQuestionIds.length
        .clamp(0, total - known)
        .toInt();
    final remaining = total - known - unknown;

    final counts = [known, unknown, remaining];
    final exactSlots = counts
        .map((count) => count * _maximumDotsCount / total)
        .toList(growable: false);
    final slots = exactSlots.map((value) => value.floor()).toList();

    var unassignedSlots =
        _maximumDotsCount - slots.fold<int>(0, (a, b) => a + b);
    final remainderOrder = List<int>.generate(counts.length, (index) => index)
      ..sort((a, b) {
        final aRemainder = exactSlots[a] - slots[a];
        final bRemainder = exactSlots[b] - slots[b];
        return bRemainder.compareTo(aRemainder);
      });

    for (var index = 0; unassignedSlots > 0; index++) {
      slots[remainderOrder[index % remainderOrder.length]]++;
      unassignedSlots--;
    }

    return [
      ...List<Color>.filled(slots[0], AppPalette.green),
      ...List<Color>.filled(slots[1], AppPalette.red),
      ...List<Color>.filled(slots[2], appColors.greyToGreyMediumDark),
    ];
  }
}
