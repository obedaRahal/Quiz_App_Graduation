import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class McqBottomActionSection extends StatelessWidget {
  final TestPlayModesState state;
  final VoidCallback onCheckAnswer;
  final VoidCallback onNextQuestion;
  final ValueChanged<String?> onShowHint;

  const McqBottomActionSection({
    super.key,
    required this.state,
    required this.onCheckAnswer,
    required this.onNextQuestion,
    required this.onShowHint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 2600),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: state.isMcqChecked
          ? _CheckedAnswerActions(
              state: state,
              onNextQuestion: onNextQuestion,
              onShowHint: onShowHint,
            )
          : _CheckAnswerButton(state: state, onCheckAnswer: onCheckAnswer),
    );
  }
}

class _CheckAnswerButton extends StatelessWidget {
  final TestPlayModesState state;
  final VoidCallback onCheckAnswer;

  const _CheckAnswerButton({required this.state, required this.onCheckAnswer});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isEnabled = state.canCheckCurrentAnswer;

    return Padding(
      key: const ValueKey('check_button'),
      padding: EdgeInsets.all(SizeConfig.w(0.045)),
      child: GestureDetector(
        onTap: isEnabled ? onCheckAnswer : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: double.infinity,
          height: SizeConfig.h(0.055),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isEnabled
                ? appColors.primaryToPrimaryDark
                : appColors.greyToGreyMediumDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: CustomTextWidget(
            'التحقق من الإجابة',
            color: isEnabled ? AppPalette.white : AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.035),
            fontFamily: AppFont.elMessiriBold,
          ),
        ),
      ),
    );
  }
}

class _CheckedAnswerActions extends StatelessWidget {
  final TestPlayModesState state;
  final VoidCallback onNextQuestion;
  final ValueChanged<String?> onShowHint;

  const _CheckedAnswerActions({
    required this.state,
    required this.onNextQuestion,
    required this.onShowHint,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = state.isCurrentAnswerCorrect == true;
    final mainColor = isCorrect ? AppPalette.green : AppPalette.red;

    return Container(
      key: const ValueKey('checked_actions'),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.07),
        vertical: SizeConfig.w(0.025),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextWidget(
            isCorrect ? 'إجابة صحيحة ! ' : 'إجابة خاطئة ! ',
            color: mainColor,
            fontSize: SizeConfig.text(0.04),
            fontFamily: AppFont.elMessiriSemiBold,
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: SizeConfig.h(0.012)),
          Row(
            children: [
              if (state.hasHint) ...[
                Expanded(
                  child: _McqOutlineActionButton(
                    title: 'لماذا ؟',
                    color: mainColor,
                    onTap: () {
                      onShowHint(state.currentQuestion?.hintText);
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.025)),
              ],
              Expanded(
                flex: 3,
                child: _McqFilledActionButton(
                  title: 'التالي',
                  color: mainColor,
                  onTap: onNextQuestion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _McqFilledActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _McqFilledActionButton({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.h(0.05),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: CustomTextWidget(
          title,
          color: AppPalette.white,
          fontSize: SizeConfig.text(0.035),
          fontFamily: AppFont.elMessiriSemiBold,
        ),
      ),
    );
  }
}

class _McqOutlineActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _McqOutlineActionButton({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.h(0.05),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 1.2),
        ),
        child: CustomTextWidget(
          title,
          color: color,
          fontSize: SizeConfig.text(0.035),
          fontFamily: AppFont.elMessiriSemiBold,
        ),
      ),
    );
  }
}
