import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class McqQuestionCard extends StatelessWidget {
  final TestPlayModesState state;
  final ValueChanged<int> onOptionTap;

  const McqQuestionCard({
    super.key,
    required this.state,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final question = state.currentQuestion!;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -SizeConfig.h(0.05),
          left: SizeConfig.w(0.09),
          right: SizeConfig.w(0.09),
          child: const _McqStackedCardLayer(opacity: 0.22),
        ),
        Positioned(
          bottom: -SizeConfig.h(0.025),
          left: SizeConfig.w(0.045),
          right: SizeConfig.w(0.045),
          child: const _McqStackedCardLayer(opacity: 0.34),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slideAnimation, child: child),
            );
          },
          child: CustomBackgroundWithChild(
            key: ValueKey(question.questionId), // أو question.position
            width: double.infinity,
            backgroundColor: appColors.whiteToblack,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: _cardBorderColor(context), width: 2.2),
            padding: EdgeInsetsDirectional.only(
              start: SizeConfig.w(0.022),
              end: SizeConfig.w(0.022),
              top: SizeConfig.h(0.025),
              bottom: SizeConfig.h(0.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _McqQuestionHeader(number: question.position),

                SizedBox(height: SizeConfig.h(0.008)),

                CustomTextWidget(
                  question.questionText,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.rtl,
                  color: appColors.blackToGrey2Dark,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.035),
                ),

                SizedBox(height: SizeConfig.h(0.014)),

                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBackgroundWithChild(
                    backgroundColor: appColors.primarySoftTogreyLightDark,
                    childHorizontalPad: SizeConfig.w(0.015),
                    childVerticalPad: SizeConfig.h(0.002),
                    borderRadius: BorderRadius.circular(20),
                    child: CustomTextWidget(
                      "الخيارات",
                      fontFamily: AppFont.elMessiriSemiBold,
                      fontSize: SizeConfig.text(0.03),
                      color: appColors.primaryToPrimaryDark,
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.008)),

                ...question.options.map((option) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
                    child: _McqOptionItem(
                      optionId: option.optionId,
                      optionPosition: option.position,
                      optionText: option.optionText,
                      isCorrectOption: option.isCorrect,
                      state: state,
                      onTap: onOptionTap,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // AnimatedContainer(
        //   duration: const Duration(milliseconds: 2600),
        //   curve: Curves.easeOutCubic,
        //   child: CustomBackgroundWithChild(
        //     width: double.infinity,
        //     backgroundColor: isDark ? AppPalette.black : AppPalette.white,
        //     borderRadius: BorderRadius.circular(30),
        //     border: Border.all(color: _cardBorderColor(context), width: 2.2),
        //     padding: EdgeInsetsDirectional.only(
        //       start: SizeConfig.w(0.022),
        //       end: SizeConfig.w(0.022),
        //       top: SizeConfig.h(0.025),
        //       bottom: SizeConfig.h(0.04),
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         _McqQuestionHeader(number: question.position),

        //         SizedBox(height: SizeConfig.h(0.008)),

        //         CustomTextWidget(
        //           question.questionText,
        //           textAlign: TextAlign.start,
        //           textDirection: TextDirection.rtl,
        //           color: appColors.blackToGrey2Dark,
        //           fontFamily: AppFont.elMessiriBold,
        //           fontSize: SizeConfig.text(0.035),
        //         ),

        //         SizedBox(height: SizeConfig.h(0.014)),

        //         Align(
        //           alignment: Alignment.centerRight,
        //           child: CustomBackgroundWithChild(
        //             backgroundColor: AppPalette.primarySoft,
        //             childHorizontalPad: SizeConfig.w(0.015),
        //             childVerticalPad: SizeConfig.h(0.002),
        //             borderRadius: BorderRadius.circular(20),
        //             child: CustomTextWidget(
        //               "الخيارات",
        //               fontFamily: AppFont.elMessiriSemiBold,
        //               fontSize: SizeConfig.text(0.03),
        //               color: appColors.primaryToPrimaryDark,
        //             ),
        //           ),
        //         ),

        //         SizedBox(height: SizeConfig.h(0.008)),

        //         ...question.options.map((option) {
        //           return Padding(
        //             padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
        //             child: _McqOptionItem(
        //               optionId: option.optionId,
        //               optionPosition: option.position,
        //               optionText: option.optionText,
        //               isCorrectOption: option.isCorrect,
        //               state: state,
        //               onTap: onOptionTap,
        //             ),
        //           );
        //         }),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Color _cardBorderColor(BuildContext context) {
    final appColors = context.appColors;

    if (!state.isMcqChecked) {
      return appColors.borderFieldColorNLightToborderFieldColorNDark;
    }

    return state.isCurrentAnswerCorrect == true
        ? AppPalette.green
        : AppPalette.red;
  }
}

class _McqQuestionHeader extends StatelessWidget {
  final int number;

  const _McqQuestionHeader({required this.number});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          childHorizontalPad: SizeConfig.w(0.015),
          childVerticalPad: SizeConfig.h(0.002),
          borderRadius: BorderRadius.circular(20),
          child: CustomTextWidget(
            "السؤال",
            color: appColors.primaryToPrimaryDark,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.03),
          ),
        ),
        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          childHorizontalPad: SizeConfig.w(.022),
          childVerticalPad: SizeConfig.h(.004),
          borderRadius: BorderRadius.circular(10),
          child: CustomTextWidget(
            "#$number",
            color: appColors.primaryToPrimaryDark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.035),
          ),
        ),
      ],
    );
  }
}

class _McqStackedCardLayer extends StatelessWidget {
  final double opacity;

  const _McqStackedCardLayer({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.h(0.045),
      decoration: BoxDecoration(
        color: AppPalette.primary.withOpacity(opacity),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }
}

class _McqOptionItem extends StatelessWidget {
  final int optionId;
  final int optionPosition;
  final String optionText;
  final bool isCorrectOption;
  final TestPlayModesState state;
  final ValueChanged<int> onTap;

  const _McqOptionItem({
    required this.optionId,
    required this.optionPosition,
    required this.optionText,
    required this.isCorrectOption,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: state.isMcqChecked
          ? null
          : () {
              onTap(optionId);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.h(0.006),
          horizontal: SizeConfig.w(0.022),
        ),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: style.borderColor, width: 1),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            CustomTextWidget(
              "${_optionLetter(optionPosition)}.",
              color: style.textColor,
              fontFamily: AppFont.elMessiriMedium,
              fontSize: SizeConfig.text(0.035),
            ),
            SizedBox(width: SizeConfig.w(0.015)),
            Expanded(
              child: CustomTextWidget(
                optionText,
                textAlign: TextAlign.start,
                textDirection: TextDirection.rtl,
                color: style.textColor,
                fontFamily: AppFont.elMessiriMedium,
                fontSize: SizeConfig.text(0.03),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _McqOptionStyle _resolveStyle(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isSelected = state.selectedOptionId == optionId;
    final isChecked = state.isMcqChecked;
    final answerIsCorrect = state.isCurrentAnswerCorrect == true;

    final showCorrect = isChecked && isCorrectOption;
    final showWrong = isChecked && isSelected && !answerIsCorrect;
    final showSelectedBeforeCheck = !isChecked && isSelected;

    if (showCorrect) {
      return _McqOptionStyle(
        backgroundColor: isDark
            ? const Color.fromARGB(255, 24, 47, 26)
            : AppPalette.greenSoft,
        borderColor: AppPalette.green,
        textColor: AppPalette.green,
      );
    }

    if (showWrong) {
      return _McqOptionStyle(
        backgroundColor: AppPalette.red.withOpacity(0.12),
        borderColor: AppPalette.red,
        textColor: AppPalette.red,
      );
    }

    if (showSelectedBeforeCheck) {
      return _McqOptionStyle(
        backgroundColor: appColors.primarySoftTogreyLightDark,
        borderColor: appColors.primaryToPrimaryDark,
        textColor: appColors.primaryToPrimaryDark,
      );
    }

    return _McqOptionStyle(
      backgroundColor: appColors.whiteToblack,
      borderColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
      textColor: AppPalette.greyMedium,
    );
  }

  String _optionLetter(int position) {
    const letters = ['A', 'B', 'C', 'D', 'E'];

    if (position <= 0 || position > letters.length) {
      return position.toString();
    }

    return letters[position - 1];
  }
}

class _McqOptionStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _McqOptionStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}
