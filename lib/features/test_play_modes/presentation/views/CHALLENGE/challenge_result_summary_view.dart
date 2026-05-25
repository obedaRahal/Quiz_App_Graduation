import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_answer_record_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/domain/entities/test_play_content_entity.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_result_summary_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/challenge/challenge_characters_data.dart';

class ChallengeResultSummaryView extends StatelessWidget {
  const ChallengeResultSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TestPlayModesCubit, TestPlayModesState>(
          builder: (context, state) {
            final selectedCharacter = ChallengeCharactersData.selectedById(
              state.selectedChallengeCharacterId,
            );

            return Column(
              children: [
                TopPageHeader(
                  title: 'ملخص التحدي',
                  onBack: () => Navigator.pop(context),
                  icon: Icons.ios_share,
                  onIconTap: () {
                    debugPrint('share challenge result');
                  },
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                _ChallengeResultHeroCard(
                  state: state,
                  opponentName: selectedCharacter.name,
                  opponentImage: selectedCharacter.imagePath,
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.04),
                      vertical: SizeConfig.h(0.01),
                    ),
                    child: Column(
                      children: [
                        const _ChallengeResultLegend(),

                        SizedBox(height: SizeConfig.h(0.018)),

                        _ChallengeQuestionsResultList(state: state),
                      ],
                    ),
                  ),
                ),

                PlayAgainButton(
                  onTap: () {
                    context.read<TestPlayModesCubit>().resetSession();
                    context.read<TestPlayModesCubit>().loadMockTestContent();

                    Navigator.pop(context);
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

class _ChallengeResultHeroCard extends StatelessWidget {
  final TestPlayModesState state;
  final String opponentName;
  final String opponentImage;

  const _ChallengeResultHeroCard({
    required this.state,
    required this.opponentName,
    required this.opponentImage,
  });

  @override
  Widget build(BuildContext context) {
    final title = state.didChallengeUserWin
        ? 'تهانينا لقد ربحت!'
        : state.didChallengeBotWin
        ? 'حظ أوفر في المرة القادمة'
        : 'تعادل رائع!';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: AppPalette.violetMedium,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppPalette.white, width: 2),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.045),
          vertical: SizeConfig.h(0.01),
        ),
        boxShadow: [BoxShadow(color: AppPalette.violetMedium, blurRadius: 6)],
        child: Column(
          children: [
            CustomTextWidget(
              title,
              color: AppPalette.white,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  child: DashedVerticalDivider(
                    height: SizeConfig.h(0.13),
                    color: AppPalette.violet,
                    width: 3,
                    dashGap: 3,
                    dashHeight: SizeConfig.h(0.015),
                  ),
                ),
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ResultPlayerItem(
                      name: 'أنت',
                      imagePath: AppImage.carmen,
                      score: state.challengeUserScore,
                      isWinner: state.didChallengeUserWin,
                    ),

                    Column(
                      children: [
                        CustomBackgroundWithChild(
                          backgroundColor: AppPalette.white,
                          childHorizontalPad: SizeConfig.h(0.01),
                          borderRadius: BorderRadius.circular(4),
                          child: CustomTextWidget(
                            'عدد الأسئلة',
                            color: AppPalette.violetMedium,
                            fontFamily: AppFont.elMessiriMedium,
                            fontSize: SizeConfig.text(0.025),
                          ),
                        ),
                        CustomTextWidget(
                          '${state.questions.length}',
                          color: AppPalette.white,
                          fontFamily: AppFont.elMessiriBold,
                          fontSize: SizeConfig.text(0.07),
                        ),
                      ],
                    ),

                    _ResultPlayerItem(
                      name: opponentName,
                      imagePath: opponentImage,
                      score: state.challengeBotScore,
                      isWinner: state.didChallengeBotWin,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPlayerItem extends StatelessWidget {
  final String name;
  final String imagePath;
  final int score;
  final bool isWinner;

  const _ResultPlayerItem({
    required this.name,
    required this.imagePath,
    required this.score,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            if (isWinner) ...[
              //  if (name == 'أنت')
              Positioned(
                top: -SizeConfig.h(0.05),
                left: -SizeConfig.h(0.08),
                child: CustomAppImage(
                  path: AppImage.winnerLottie,
                  width: SizeConfig.w(0.2),
                  height: SizeConfig.w(0.2),
                  fit: BoxFit.contain,
                ),
              ),
            ],
            CustomAppImage(
              path: imagePath,
              width: SizeConfig.h(0.07),
              height: SizeConfig.h(0.07),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.h(0.008)),
        CustomTextWidget(
          name,
          color: AppPalette.white,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.03),
        ),
        CustomBackgroundWithChild(
          backgroundColor: Colors.transparent,
          border: Border.all(color: AppPalette.white),
          childHorizontalPad: SizeConfig.w(0.025),
          borderRadius: BorderRadius.circular(4),
          child: CustomTextWidget(
            '$score',
            color: AppPalette.white,
            fontFamily: AppFont.elMessiriMedium,
            fontSize: SizeConfig.text(0.026),
          ),
        ),
      ],
    );
  }
}

class _ChallengeResultLegend extends StatelessWidget {
  const _ChallengeResultLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextWidget(
          'أنت',
          color: context.appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.03),
        ),
        SizedBox(width: SizeConfig.w(0.015)),

        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppPalette.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: SizeConfig.w(0.02)),

        Expanded(child: DashedSectionTitle(title: 'الإجابات')),
        SizedBox(width: SizeConfig.w(0.02)),

        //SizedBox(width: 18),
        _LegendItem(title: 'الخصم', color: Color(0xFFD46BFF)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String title;
  final Color color;

  const _LegendItem({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: SizeConfig.w(0.015)),
        CustomTextWidget(
          title,
          color: context.appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.03),
        ),
      ],
    );
  }
}

class _ChallengeQuestionsResultList extends StatelessWidget {
  final TestPlayModesState state;

  const _ChallengeQuestionsResultList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: state.questions.map((question) {
        final answer = state.answersByQuestionId[question.questionId];

        return Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
          child: _ChallengeResultQuestionCard(
            question: question,
            answer: answer,
            totalQuestions: state.totalQuestions,
          ),
        );
      }).toList(),
    );
  }
}

class _ChallengeResultQuestionCard extends StatelessWidget {
  final TestPlayQuestionEntity question;
  final TestPlayAnswerRecordEntity? answer;
  final int totalQuestions;

  const _ChallengeResultQuestionCard({
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
            color: AppPalette.black,
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
              child: _ChallengeResultOptionRow(option: option, answer: answer),
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

class _ChallengeResultOptionRow extends StatelessWidget {
  final TestPlayOptionEntity option;
  final TestPlayAnswerRecordEntity? answer;

  const _ChallengeResultOptionRow({required this.option, required this.answer});

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
