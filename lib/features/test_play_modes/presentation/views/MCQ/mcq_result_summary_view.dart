// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart'
    show ThemeCubit;
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';

class McqResultSummaryView extends StatelessWidget {
  const McqResultSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TestPlayModesCubit, TestPlayModesState>(
          builder: (context, state) {
            final test = state.test;

            if (test == null) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                BlocConsumer<TestPlayModesCubit, TestPlayModesState>(
                  listenWhen: (previous, current) =>
                      previous.mcqResultPdfStatus != current.mcqResultPdfStatus,
                  listener: (context, state) {
                    if (state.isMcqResultPdfSuccess) {
                      showValidationTopSnackBar(
                        context,
                        title: "تم التحميل",
                        message: "تم حفظ نتيجة الاختبار بنجاح",
                        type: AppValidationSnackBarType.success,
                        actionText: "عرض النتيجة",
                        onActionTap: () async {
                          final filePath = state.generatedMcqResultPdfPath;

                          if (filePath == null || filePath.isEmpty) return;

                          await OpenFilex.open(filePath);
                        },
                      );

                      context
                          .read<TestPlayModesCubit>()
                          .resetMcqResultPdfState();
                    }

                    if (state.isMcqResultPdfFailure) {
                      showValidationTopSnackBar(
                        context,
                        title: state.errorTitle ?? "خطأ",
                        message: state.errorMessage ?? "تعذر إنشاء ملف النتيجة",
                        type: AppValidationSnackBarType.error,
                      );

                      context
                          .read<TestPlayModesCubit>()
                          .resetMcqResultPdfState();
                    }
                  },
                  builder: (context, state) {
                    return TopPageHeader(
                      title: 'ملخص الاختبار',
                      onBack: () => Navigator.pop(context),
                      icon: state.isMcqResultPdfLoading
                          ? Icons.hourglass_top_rounded
                          : Icons.download_outlined,
                      onIconTap: state.isMcqResultPdfLoading
                          ? () {}
                          : () {
                              context
                                  .read<TestPlayModesCubit>()
                                  .downloadMcqResultPdf();
                            },
                    );
                  },
                ),
                CustomButtonWidget(
                  onTap: () {
                    debugPrint("change mode ");
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  child: ThemedAppImage(
                    darkPath: AppImage.logoDark,
                    lightPath: AppImage.logoLight,
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.02)),

                _McqResultCongratulationsCard(state: state),

                SizedBox(height: SizeConfig.h(0.01)),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.03),
                      vertical: SizeConfig.h(0.02),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DashedSectionTitle(title: 'إجاباتك'),

                        SizedBox(height: SizeConfig.h(0.015)),

                        ...state.questions.map((question) {
                          final answer =
                              state.answersByQuestionId[question.questionId];

                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.h(0.018),
                            ),
                            child: _McqResultQuestionCard(
                              question: question,
                              answer: answer,
                              totalQuestions: state.totalQuestions,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                PlayAgainButton(
                  onTap: () {
                    context
                        .read<TestPlayModesCubit>()
                        .restartMcqSession(); //context.read<TestPlayModesCubit>().loadMockTestContent();

                    //Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _McqResultCongratulationsCard extends StatelessWidget {
  final TestPlayModesState state;

  const _McqResultCongratulationsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isPassed = state.hasPassed;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: CustomBackgroundWithChild(
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
                      isPassed
                          ? 'تهانينا لقد أنجزت الاختبار!'
                          : 'أحسنت، أكملت الاختبار!',
                      color: appColors.whiteToblack,
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.04),
                      textDirection: TextDirection.rtl,
                    ),

                    SizedBox(height: SizeConfig.h(0.002)),

                    CustomTextWidget(
                      isPassed ? 'نتيجة ممتازة' : 'حاول مرة أخرى لتحسين نتيجتك',
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
                          label: 'النسبة',
                          value: '${state.scorePercentage}%',
                        ),
                        _ResultMiniStat(
                          label: 'إجابات صحيحة',
                          value: '${state.correctAnswersCount}',
                        ),
                        _ResultMiniStat(
                          label: 'إجابات خاطئة',
                          value: '${state.wrongAnswersCount}',
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
                height: SizeConfig.h(0.19),
              ),
            ),

            // Container(
            //   width: SizeConfig.w(0.18),
            //   height: SizeConfig.w(0.18),
            //   decoration: BoxDecoration(
            //     color: AppPalette.white.withOpacity(0.12),
            //     shape: BoxShape.circle,
            //   ),
            //   child: Icon(
            //     isPassed
            //         ? Icons.emoji_events_outlined
            //         : Icons.psychology_alt_outlined,
            //     color: AppPalette.white.withOpacity(0.8),
            //     size: SizeConfig.w(0.11),
            //   ),
            // ),
          ],
        ),
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
      childHorizontalPad: SizeConfig.w(0.025),
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

class DashedSectionTitle extends StatelessWidget {
  final String title;

  const DashedSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: Axis.horizontal,
                children: List.generate(
                  (constraints.constrainWidth() / 10).floor(),
                  (_) => Expanded(
                    child: Container(
                      height: 1.2,
                      color: AppPalette.black,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.025)),
          child: CustomTextWidget(
            title,
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.04),
          ),
        ),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: Axis.horizontal,
                children: List.generate(
                  (constraints.constrainWidth() / 10).floor(),
                  (_) => Expanded(
                    child: Container(
                      height: 1.2,
                      color: AppPalette.black,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _McqResultQuestionCard extends StatelessWidget {
  final TestPlayQuestionEntity question;
  final TestPlayAnswerRecordEntity? answer;
  final int totalQuestions;

  const _McqResultQuestionCard({
    required this.question,
    required this.answer,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: isDark ? AppPalette.black : AppPalette.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: answer?.isCorrect == true ? AppPalette.green : AppPalette.red,
      ),
      padding: EdgeInsets.all(SizeConfig.w(0.03)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              CustomBackgroundWithChild(
                backgroundColor: answer?.isCorrect == true
                    ? isDark
                          ? const Color.fromARGB(255, 24, 47, 26)
                          : AppPalette.greenSoft
                    : AppPalette.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                childHorizontalPad: SizeConfig.w(0.018),
                childVerticalPad: SizeConfig.h(0.002),
                border: Border.all(
                  color: answer?.isCorrect == true
                      ? AppPalette.green
                      : AppPalette.red,
                ),
                child: CustomTextWidget(
                  '${question.position}/$totalQuestions',
                  color: answer?.isCorrect == true
                      ? AppPalette.green
                      : AppPalette.red,
                  fontFamily: AppFont.elMessiriBold,
                  fontSize: SizeConfig.text(0.026),
                ),
              ),

              const Spacer(),

              CustomTextWidget(
                'السؤال',
                color: appColors.primaryToPrimaryDark,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.03),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(0.01)),

          CustomTextWidget(
            question.questionText,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.03),
          ),

          SizedBox(height: SizeConfig.h(0.012)),

          Align(
            alignment: Alignment.centerRight,
            child: CustomTextWidget(
              'الخيارات',
              color: appColors.primaryToPrimaryDark,
              fontFamily: AppFont.elMessiriSemiBold,
              fontSize: SizeConfig.text(0.03),
            ),
          ),

          SizedBox(height: SizeConfig.h(0.008)),

          ...question.options.map((option) {
            final isSelected = option.optionId == answer?.selectedOptionId;

            final isCorrect = option.isCorrect;

            Color borderColor;
            Color backgroundColor;
            Color textColor;

            if (isCorrect) {
              borderColor = AppPalette.green;
              backgroundColor = isDark
                  ? const Color.fromARGB(255, 24, 47, 26)
                  : AppPalette.greenSoft;
              textColor = AppPalette.green;
            } else if (isSelected && !isCorrect) {
              borderColor = AppPalette.red;
              backgroundColor = AppPalette.red.withOpacity(0.12);
              textColor = AppPalette.red;
            } else {
              borderColor =
                  appColors.borderFieldColorNLightToborderFieldColorNDark;
              backgroundColor = appColors.whiteToblack;
              textColor = AppPalette.greyMedium;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.h(0.008)),
              child: CustomBackgroundWithChild(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.022),
                  vertical: SizeConfig.h(0.008),
                ),
                //decoration: BoxDecoration(
                backgroundColor: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor),
                //),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    CustomTextWidget(
                      '${_optionLetter(option.position)}.',
                      color: textColor,
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.03),
                    ),

                    SizedBox(width: SizeConfig.w(0.015)),

                    Expanded(
                      child: CustomTextWidget(
                        option.optionText,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        color: textColor,
                        fontFamily: AppFont.elMessiriMedium,
                        fontSize: SizeConfig.text(0.028),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
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

class PlayAgainButton extends StatelessWidget {
  final VoidCallback onTap;

  const PlayAgainButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomBackgroundWithChild(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.03),
        vertical: SizeConfig.h(0.017),
      ),
      boxShadow: [
        BoxShadow(
          color: isDark ? AppPalette.greyMediumDark : AppPalette.greyBorderCart,
          blurRadius: 4,
          offset: const Offset(0, -4),
        ),
      ],
      backgroundColor: appColors.whiteToblack,
      child: CustomButtonWidget(
        borderRadius: 5,
        width: double.infinity,
        childHorizontalPad: SizeConfig.w(0.04),
        childVerticalPad: SizeConfig.h(0.007),
        backgroundColor: appColors.primaryToPrimaryDark,
        onTap: onTap,
        child: CustomTextWidget(
          "اللعب مرة اخرى",
          color: appColors.whiteToblack,
          fontSize: SizeConfig.text(0.03),
        ),
      ),
    );
  }
}
