import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_result_summary_view.dart';

class FlashcardSummaryDialog extends StatelessWidget {
  final TestPlayModesState state;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;

  const FlashcardSummaryDialog({
    super.key,
    required this.state,
    required this.onPlayAgain,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.08)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // maxWidth: SizeConfig.w(0.86),
          maxHeight: SizeConfig.h(0.47),
        ),
        child: CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: appColors.whiteToblack,
          borderRadius: BorderRadius.circular(16),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        'ملخص الاختبار',
                        color: appColors.blackToGrey2Dark,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.045),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      onTap: onClose,
                      child: Icon(
                        Icons.close_rounded,
                        color: appColors.blackToGrey2Dark,
                        size: SizeConfig.h(0.028),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.h(0.01)),

              const CustomDivider(height: 20, thickness: 4, isDashed: true),

              SizedBox(height: SizeConfig.h(0.01)),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.01)),
                child: _FlashcardResultCongratulationsCard(state: state),
              ),

              SizedBox(height: SizeConfig.h(0.014)),
              PlayAgainButton(onTap: onPlayAgain),
              // GestureDetector(
              //   onTap: onPlayAgain,
              //   child: CustomBackgroundWithChild(
              //     width: double.infinity,
              //     height: SizeConfig.h(0.05),
              //     alignment: Alignment.center,
              //     backgroundColor: appColors.primaryToPrimaryDark,
              //     borderRadius: BorderRadius.circular(10),
              //     child: CustomTextWidget(
              //       'اللعب مرة أخرى',
              //       color: AppPalette.white,
              //       fontFamily: AppFont.elMessiriBold,
              //       fontSize: SizeConfig.text(0.033),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlashcardResultCongratulationsCard extends StatelessWidget {
  final TestPlayModesState state;

  const _FlashcardResultCongratulationsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final percent = state.totalQuestions == 0
        ? 0
        : ((state.flashcardKnownCardsCount / state.totalQuestions) * 100)
              .round();
    return CustomBackgroundWithChild(
      backgroundColor: appColors.whiteToblack,
      width: double.infinity,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: appColors.whiteToblack, width: 2),
      boxShadow: [
        BoxShadow(
          color: isDark ? AppPalette.greyMedium : AppPalette.circleContainer3,
          blurRadius: 6,
        ),
      ],
      gradient: const LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          // Color(0xFF8E6CFF), Color(0xFFA864E8)
          AppPalette.homeContainer1,
          AppPalette.homeContainer2,
          AppPalette.homeContainer3,
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.h(0.015)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomTextWidget(
                    'تهانينا لقد أنهيت البطاقات!',
                    color: appColors.whiteToblack,
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.04),
                    textDirection: TextDirection.rtl,
                  ),

                  SizedBox(height: SizeConfig.h(0.002)),

                  CustomTextWidget(
                    'راجعت جميع البطاقات بنجاح',
                    color: appColors.whiteToblack.withOpacity(0.8),
                    fontFamily: AppFont.elMessiriMedium,
                    fontSize: SizeConfig.text(0.028),
                    textDirection: TextDirection.rtl,
                  ),

                  SizedBox(height: SizeConfig.h(0.014)),

                  Wrap(
                    spacing: SizeConfig.w(0.025),
                    runSpacing: SizeConfig.h(0.008),
                    alignment: WrapAlignment.end,
                    children: [
                      _ResultMiniStat(
                        label: 'لا يجتاج لتذكرة',
                        value: '${state.flashcardKnownImmediatelyCardsCount}',
                      ),
                      _ResultMiniStat(label: 'أكملت', value: '$percent%'),

                      _ResultMiniStat(
                        label: 'تمت مراجعته',
                        value: '${state.flashcardReviewedCardsCount}',
                      ),
                      _ResultMiniStat(
                        label: 'الوقت المستغرق',
                        value: _formatSeconds(state.elapsedSeconds),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: SizeConfig.w(0.04)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DashedVerticalDivider(
              height: SizeConfig.h(0.2),
              color: appColors.whiteToblack,
              width: 2,
              dashGap: 2,
              dashHeight: SizeConfig.h(0.015),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: SizeConfig.w(0.02)),
            child: CustomAppImage(
              path: AppImage.cup,
              height: SizeConfig.h(0.15),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSeconds(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _ResultMiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _ResultMiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      backgroundColor: appColors.whiteToblack.withOpacity(0.18),
      borderRadius: BorderRadius.circular(5),
      childHorizontalPad: SizeConfig.w(0.015),
      childVerticalPad: SizeConfig.h(0.004),
      child: Column(
        children: [
          CustomTextWidget(
            label,
            color: appColors.whiteToblack.withOpacity(0.8),
            fontFamily: AppFont.elMessiriMedium,
            fontSize: SizeConfig.text(0.024),
          ),
          CustomTextWidget(
            value,
            color: appColors.whiteToblack,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.032),
          ),
        ],
      ),
    );
  }
}
