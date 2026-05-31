import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class ChallengeQuestionCard extends StatelessWidget {
  final TestPlayModesState state;
  final ValueChanged<int> onOptionTap;

  const ChallengeQuestionCard({
    super.key,
    required this.state,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final question = state.currentQuestion!;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -SizeConfig.h(0.05),
          left: SizeConfig.w(0.09),
          right: SizeConfig.w(0.09),
          child: const _ChallengeStackedCardLayer(opacity: 0.22),
        ),

        Positioned(
          bottom: -SizeConfig.h(0.025),
          left: SizeConfig.w(0.045),
          right: SizeConfig.w(0.045),
          child: const _ChallengeStackedCardLayer(opacity: 0.34),
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
            key: ValueKey(question.questionId),
            width: double.infinity,
            backgroundColor: appColors.whiteToblack,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: appColors.borderFieldColorNLightToborderFieldColorNDark,
              width: 2.2,
            ),
            padding: EdgeInsetsDirectional.only(
              start: SizeConfig.w(0.022),
              end: SizeConfig.w(0.022),
              top: SizeConfig.h(0.025),
              bottom: SizeConfig.h(0.04),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ChallengeQuestionHeader(number: question.position),

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
                    child: _ChallengeOptionItem(
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
      ],
    );
  }

  Color _cardBorderColor(BuildContext context) {
    if (state.challengeUserLastResult == ChallengeAnswerResult.correct) {
      return AppPalette.green;
    }

    if (state.challengeUserLastResult == ChallengeAnswerResult.wrong) {
      return AppPalette.red;
    }

    return context.appColors.borderFieldColorNLightToborderFieldColorNDark;
  }
}

class _ChallengeQuestionHeader extends StatelessWidget {
  final int number;

  const _ChallengeQuestionHeader({required this.number});

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
            'السؤال',
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
            '#$number',
            color: appColors.primaryToPrimaryDark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.035),
          ),
        ),
      ],
    );
  }
}

class _ChallengeStackedCardLayer extends StatelessWidget {
  final double opacity;

  const _ChallengeStackedCardLayer({required this.opacity});

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

class _ChallengeOptionItem extends StatelessWidget {
  final int optionId;
  final int optionPosition;
  final String optionText;
  final bool isCorrectOption;
  final TestPlayModesState state;
  final ValueChanged<int> onTap;

  const _ChallengeOptionItem({
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
      onTap: state.canChallengeUserAnswer
          ? () {
              onTap(optionId);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
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
              '${_optionLetter(optionPosition)}.',
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
            if (style.badgeText != null) ...[
              SizedBox(width: SizeConfig.w(0.015)),
              CustomBackgroundWithChild(
                backgroundColor: style.badgeColor ?? AppPalette.primary,
                borderRadius: BorderRadius.circular(20),
                childHorizontalPad: SizeConfig.w(0.018),
                childVerticalPad: SizeConfig.h(0.002),
                child: CustomTextWidget(
                  style.badgeText!,
                  color: AppPalette.white,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.02),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ChallengeOptionStyle _resolveStyle(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isUserSelected = state.selectedOptionId == optionId;
    final isBotSelected = state.challengeBotSelectedOptionId == optionId;


    //final bothAnswered = userAnswered && botAnswered;
    final isResolved = state.isChallengeQuestionResolved;
    // بعد انتهاء إجابة الطرفين: نظهر الصحيح والخطأ بوضوح
    if (isResolved && isCorrectOption) {
      return _ChallengeOptionStyle(
        backgroundColor: isDark
            ? const Color.fromARGB(255, 24, 47, 26)
            : AppPalette.greenSoft,
        borderColor: AppPalette.green,
        textColor: AppPalette.green,
        badgeText: 'صحيح',
        badgeColor: AppPalette.green,
      );
    }

    if (isResolved && isUserSelected && !isCorrectOption) {
      return _ChallengeOptionStyle(
        backgroundColor: AppPalette.red.withOpacity(0.12),
        borderColor: AppPalette.red,
        textColor: AppPalette.red,
        badgeText: 'أنت',
        badgeColor: AppPalette.red,
      );
    }

    if (isResolved && isBotSelected && !isCorrectOption) {
      return _ChallengeOptionStyle(
        backgroundColor: const Color(0xFFD46BFF).withOpacity(0.12),
        borderColor: const Color(0xFFD46BFF),
        textColor: const Color(0xFFD46BFF),
        badgeText: 'البوت',
        badgeColor: const Color(0xFFD46BFF),
      );
    }

    // قبل انتهاء الجولة: اختيار المستخدم أزرق
    if (isUserSelected) {
      return _ChallengeOptionStyle(
        backgroundColor: appColors.primarySoftTogreyLightDark,
        borderColor: appColors.primaryToPrimaryDark,
        textColor: appColors.primaryToPrimaryDark,
        badgeText: 'أنت',
        badgeColor: appColors.primaryToPrimaryDark,
      );
    }

    // قبل انتهاء الجولة: اختيار البوت زهري/بنفسجي
    if (isBotSelected) {
      return _ChallengeOptionStyle(
        backgroundColor: const Color(0xFFD46BFF).withOpacity(0.12),
        borderColor: const Color(0xFFD46BFF),
        textColor: const Color(0xFFD46BFF),
        badgeText: 'البوت',
        badgeColor: const Color(0xFFD46BFF),
      );
    }

    return _ChallengeOptionStyle(
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

class _ChallengeOptionStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String? badgeText;
  final Color? badgeColor;

  const _ChallengeOptionStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.badgeText,
    this.badgeColor,
  });
}
