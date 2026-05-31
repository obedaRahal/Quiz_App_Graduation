import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';

class ChallengeResultOptionRow extends StatelessWidget {
  final TestPlayOptionEntity option;
  final TestPlayAnswerRecordEntity? answer;

  const ChallengeResultOptionRow({
    super.key,
    required this.option,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(0.006),
        horizontal: SizeConfig.w(0.025),
      ),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: style.borderColor, width: 1),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          CustomTextWidget(
            '${_optionLetter(option.position)}.',
            color: style.textColor,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.032),
          ),
          SizedBox(width: SizeConfig.w(0.015)),
          Expanded(
            child: CustomTextWidget(
              option.optionText,
              color: style.textColor,
              fontFamily: AppFont.elMessiriMedium,
              fontSize: SizeConfig.text(0.028),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          if (style.badgeText != null) ...[
            SizedBox(width: SizeConfig.w(0.015)),
            CustomBackgroundWithChild(
              backgroundColor: style.badgeColor!,
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
    );
  }

  _ResultOptionStyle _resolveStyle(BuildContext context) {
    final appColors = context.appColors;

    final selectedId = answer?.selectedOptionId;
    final isSelected = selectedId == option.optionId;
    final isCorrectOption = option.isCorrect;

    if (isCorrectOption) {
      return _ResultOptionStyle(
        backgroundColor: AppPalette.green.withOpacity(0.12),
        borderColor: AppPalette.green,
        textColor: AppPalette.green,
        badgeText: 'صحيح',
        badgeColor: AppPalette.green,
      );
    }

    if (isSelected && answer?.answeredBy == TestPlayAnswerOwner.user) {
      return _ResultOptionStyle(
        backgroundColor: AppPalette.primary.withOpacity(0.12),
        borderColor: AppPalette.primary,
        textColor: AppPalette.primary,
        badgeText: 'أنت',
        badgeColor: AppPalette.primary,
      );
    }

    if (isSelected && answer?.answeredBy == TestPlayAnswerOwner.bot) {
      return _ResultOptionStyle(
        backgroundColor: const Color(0xFFD46BFF).withOpacity(0.12),
        borderColor: const Color(0xFFD46BFF),
        textColor: const Color(0xFFD46BFF),
        badgeText: 'الخصم',
        badgeColor: const Color(0xFFD46BFF),
      );
    }

    return _ResultOptionStyle(
      backgroundColor: appColors.greyToGreyMediumDark,
      borderColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
      textColor: AppPalette.greyMedium,
    );
  }

  String _optionLetter(int position) {
    const letters = ['A', 'B', 'C', 'D', 'E'];
    if (position <= 0 || position > letters.length) return position.toString();
    return letters[position - 1];
  }
}

class _ResultOptionStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String? badgeText;
  final Color? badgeColor;

  const _ResultOptionStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    this.badgeText,
    this.badgeColor,
  });
}
