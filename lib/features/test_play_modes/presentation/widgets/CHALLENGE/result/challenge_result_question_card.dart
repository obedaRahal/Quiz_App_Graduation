import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/result/challenge_result_option_row.dart';

class ChallengeResultQuestionCard extends StatelessWidget {
  final TestPlayQuestionEntity question;
  final TestPlayAnswerRecordEntity? answer;
  final int totalQuestions;

  const ChallengeResultQuestionCard({
    super.key,
    required this.question,
    required this.answer,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final winnerColor = _winnerColor();

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: appColors.whiteToblack,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: winnerColor, width: 1.4),
      padding: EdgeInsets.all(SizeConfig.w(0.03)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                'السؤال ${question.position}',
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.035),
              ),
              CustomBackgroundWithChild(
                backgroundColor: winnerColor.withOpacity(0.12),
                childHorizontalPad: SizeConfig.h(0.01),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: winnerColor),
                child: CustomTextWidget(
                  '${question.position}/$totalQuestions',
                  color: winnerColor,
                  fontFamily: AppFont.elMessiriSemiBold,
                  fontSize: SizeConfig.text(0.028),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.01)),

          CustomTextWidget(
            question.questionText,
            color: context.appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.032),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: SizeConfig.h(0.012)),
          CustomTextWidget(
            'الخيارات',
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.035),
          ),
          SizedBox(height: SizeConfig.h(0.012)),

          ...question.options.map((option) {
            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.007)),
              child: ChallengeResultOptionRow(option: option, answer: answer),
            );
          }),
        ],
      ),
    );
  }

  Color _winnerColor() {
    if (answer?.answeredBy == TestPlayAnswerOwner.user) {
      return AppPalette.primary;
    }

    if (answer?.answeredBy == TestPlayAnswerOwner.bot ||
        answer?.answeredBy == TestPlayAnswerOwner.timeout) {
      return const Color(0xFFD46BFF);
    }

    return AppPalette.greyMedium;
  }
}
