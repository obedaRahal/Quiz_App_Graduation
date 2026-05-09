// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/sample_tab/sample_test_tap.dart';

class SampleQuestionCard extends StatelessWidget {
  final PreviewQuestionUiModel question;
  final int? selectedOptionId;
  final ValueChanged<int> onOptionSelected;

  const SampleQuestionCard({
    super.key,
    required this.question,
    required this.selectedOptionId,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hint = question.hintText?.trim();
    final hasHint = hint != null && hint.isNotEmpty;
    final isRevealed = selectedOptionId != null;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: isDark ? AppPalette.black : AppPalette.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: appColors.borderFieldColorNLightToborderFieldColorNDark,
      ),
      childVerticalPad: SizeConfig.h(0.015),
      childHorizontalPad: SizeConfig.w(0.022),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _QuestionHeader(number: question.number),

          SizedBox(height: SizeConfig.h(0.008)),

          CustomTextWidget(
            question.question,
            textAlign: TextAlign.start,
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriMedium,
            fontSize: SizeConfig.text(0.035),
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasHint)
                InkWell(
                  onTap: () {
                    showValidationTopSnackBar(
                      context,
                      title: "توضيح",
                      message: hint,
                      type: AppValidationSnackBarType.hint,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.03),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.lightbulb,
                      color: AppPalette.yellow,
                      size: SizeConfig.h(0.03),
                    ),
                  ),
                )
              else
                SizedBox(width: SizeConfig.w(0.09)),

              CustomTextWidget(
                "الخيارات",
                fontFamily: AppFont.elMessiriSemiBold,
                fontSize: SizeConfig.text(0.035),
                color: appColors.primaryToPrimaryDark,
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.008)),

          ...question.options.map((option) {
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
              child: SampleOptionItem(
                option: option,
                isSelected: selectedOptionId == option.id,
                isRevealed: isRevealed,
                onTap: () => onOptionSelected(option.id),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  final int number;

  const _QuestionHeader({required this.number});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(
          "السؤال",
          color: appColors.primaryToPrimaryDark,
          //fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.035),
        ),
        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          childHorizontalPad: SizeConfig.w(.022),
          childVerticalPad: SizeConfig.h(.002),
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

class SampleOptionItem extends StatelessWidget {
  final PreviewOptionUiModel option;
  final bool isSelected;
  final bool isRevealed;
  final VoidCallback onTap;

  const SampleOptionItem({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isRevealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool showCorrect = isRevealed && option.isCorrect;
    final bool showWrong = isRevealed && isSelected && !option.isCorrect;

    final Color backgroundColor = showCorrect
        ? (isDark
              ? const Color.fromARGB(255, 24, 47, 26)
              : AppPalette.greenSoft)
        : showWrong
        ? AppPalette.red.withOpacity(0.12)
        : appColors.greyToGreyMediumDark;

    final Color borderColor = showCorrect
        ? AppPalette.green
        : showWrong
        ? AppPalette.red
        : appColors.borderFieldColorNLightToborderFieldColorNDark;

    final Color textColor = showCorrect
        ? AppPalette.green
        : showWrong
        ? AppPalette.red
        : AppPalette.greyMedium;

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: isRevealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.h(0.006),
          horizontal: SizeConfig.w(0.022),
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            CustomTextWidget(
              "${option.letter}.",
              color: textColor,
              fontFamily: AppFont.elMessiriMedium,
              fontSize: SizeConfig.text(0.035),
            ),
            SizedBox(width: SizeConfig.w(0.015)),
            Expanded(
              child: CustomTextWidget(
                option.text,
                textAlign: TextAlign.start,
                color: textColor,
                fontFamily: AppFont.elMessiriMedium,
                fontSize: SizeConfig.text(0.03),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
