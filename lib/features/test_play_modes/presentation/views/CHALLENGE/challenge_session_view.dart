import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/CHALLENGE/challenge_result_summary_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/challenge_characters_data.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/challenge_question_card.dart';

class ChallengeSessionView extends StatefulWidget {
  const ChallengeSessionView({super.key});

  @override
  State<ChallengeSessionView> createState() => _ChallengeSessionViewState();
}

class _ChallengeSessionViewState extends State<ChallengeSessionView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TestPlayModesCubit>().startChallengeSession();
    });
    Future.microtask(() {
      final cubit = context.read<TestPlayModesCubit>();

      if (!cubit.state.hasPlayableContent) {
        cubit.loadMockTestContent();
      }

      cubit.startChallengeSession();
    });
  }

  void _onBackTap() {
    Navigator.pop(context);
  }

  void _onSoundTap() {
    context.read<TestPlayModesCubit>().toggleVoiceAssistantForCurrentQuestion();
  }

  void _onOptionTap(int optionId) {
    context.read<TestPlayModesCubit>().selectChallengeAnswer(
      optionId: optionId,
    );
  }

  void _onNextQuestion() {
    context.read<TestPlayModesCubit>().goToNextChallengeQuestion();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TestPlayModesCubit, TestPlayModesState>(
          builder: (context, state) {
            final question = state.currentQuestion;

            if (question == null) {
              return const SizedBox.shrink();
            }

            if (state.isCompleted) {
              return const ChallengeResultSummaryView();
            }

            return Column(
              children: [
                TopPageHeader(
                  title: 'جلسة امتحانية أولى',
                  onBack: _onBackTap,
                  icon: state.isVoiceSpeaking
                      ? Icons.stop_circle_outlined
                      : Icons.volume_up_outlined,
                  onIconTap: _onSoundTap,
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                _ChallengeSessionInfoHeader(state: state),

                SizedBox(height: SizeConfig.h(0.008)),

                _ChallengeBattleProgressBar(state: state),

                SizedBox(height: SizeConfig.h(0.018)),

                _ChallengePlayersScoreSection(state: state),

                SizedBox(height: SizeConfig.h(0.02)),

                Expanded(
                  child: CustomBackgroundWithChild(
                    backgroundColor: AppPalette.black,
                    alignment: Alignment.topCenter,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isDark
                          ? [
                              const Color.fromARGB(255, 29, 58, 121),
                              const Color.fromARGB(255, 62, 123, 221),
                            ]
                          : [AppPalette.blueDark, AppPalette.blueLight],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.h(0.025),
                        vertical: SizeConfig.h(0.025),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: ChallengeQuestionCard(
                                state: state,
                                onOptionTap: _onOptionTap,
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.h(0.02)),

                          if (state.canGoNextChallengeQuestion)
                            GestureDetector(
                              onTap: _onNextQuestion,
                              child: CustomBackgroundWithChild(
                                width: double.infinity,
                                height: SizeConfig.h(0.05),
                                alignment: Alignment.center,
                                backgroundColor: AppPalette.white,
                                borderRadius: BorderRadius.circular(16),
                                child: CustomTextWidget(
                                  'التالي',
                                  color: AppPalette.primary,
                                  fontFamily: AppFont.elMessiriBold,
                                  fontSize: SizeConfig.text(0.035),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChallengeSessionInfoHeader extends StatelessWidget {
  final TestPlayModesState state;

  const _ChallengeSessionInfoHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: Row(
        children: [
          _ChallengeTimePill(seconds: state.challengeQuestionRemainingSeconds),
          const Spacer(),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${state.totalQuestions}',
                  style: TextStyle(
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.05),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
                TextSpan(
                  text: '\\',
                  style: TextStyle(
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.06),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
                TextSpan(
                  text: '${state.currentQuestionNumber}',
                  style: TextStyle(
                    color: appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.07),
                    fontFamily: AppFont.elMessiriBold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeTimePill extends StatelessWidget {
  final int seconds;

  const _ChallengeTimePill({required this.seconds});

  String get formattedTime {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              'مؤقت',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.025),
            ),
            CustomTextWidget(
              formattedTime,
              color: appColors.blackToGrey2Dark,
              fontSize: SizeConfig.text(0.032),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        SizedBox(width: SizeConfig.w(0.015)),
        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderRadius: BorderRadius.circular(30),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.01),
            vertical: SizeConfig.w(0.01),
          ),
          child: Icon(
            Icons.timer_outlined,
            size: SizeConfig.h(0.03),
            color: AppPalette.primary,
          ),
        ),
      ],
    );
  }
}

class _ChallengeBattleProgressBar extends StatelessWidget {
  final TestPlayModesState state;

  const _ChallengeBattleProgressBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalScore = state.challengeUserScore + state.challengeBotScore;
    final userRatio = totalScore == 0
        ? 0.5
        : state.challengeUserScore / totalScore;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.045)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: SizeConfig.h(0.014),
          width: double.infinity,
          color: AppPalette.greyLight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * (1 - userRatio),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB657FF), Color(0xFFD46BFF)],
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * userRatio,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF6A5AE0)],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChallengePlayersScoreSection extends StatelessWidget {
  final TestPlayModesState state;

  const _ChallengePlayersScoreSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final selectedCharacter = ChallengeCharactersData.selectedById(
      state.selectedChallengeCharacterId,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.08)),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ChallengeReactionAvatar(
            name: 'أنت',
            imagePath: AppImage.carmen,
            score: state.challengeUserScore,
            reaction: _userReaction(state),
          ),
          Container(
            width: 1,
            height: SizeConfig.h(0.09),
            color: AppPalette.greyLight,
          ),
          // _ChallengePlayerScoreAvatar(
          //   name: selectedCharacter.name,
          //   imagePath: selectedCharacter.imagePath,
          //   score: state.challengeBotScore,
          //   isActive: state.isChallengeBotThinking,
          //   isUser: false,
          // ),
          _ChallengeReactionAvatar(
            name: selectedCharacter.name,
            imagePath: selectedCharacter.imagePath,
            score: state.challengeBotScore,
            reaction: state.challengeBotReaction,
          ),
        ],
      ),
    );
  }

  ChallengeBotReaction _userReaction(TestPlayModesState state) {
    if (!state.challengeUserHasAnsweredCurrentQuestion) {
      return ChallengeBotReaction.thinking;
    }

    if (state.isChallengeUserLastAnswerCorrect) {
      return ChallengeBotReaction.correct;
    }

    if (state.isChallengeUserLastAnswerWrong) {
      return ChallengeBotReaction.wrong;
    }

    return ChallengeBotReaction.none;
  }
}

class _ChallengeReactionAvatar extends StatelessWidget {
  final String name;
  final String imagePath;
  final int score;
  final ChallengeBotReaction reaction;
  final double? reactionWidth;
  final double? reactionHeight;

  const _ChallengeReactionAvatar({
    required this.name,
    required this.imagePath,
    required this.score,
    required this.reaction,
    this.reactionWidth,
    this.reactionHeight,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final lottiePath = _reactionLottiePath(reaction);
    final reactionSize = _reactionSize(reaction);

    return Column(
      children: [
        SizedBox(
          width: SizeConfig.w(0.18),
          height: SizeConfig.h(0.105),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                child: CustomAppImage(
                  path: imagePath,
                  height: SizeConfig.h(0.075),
                  borderRadius: BorderRadius.circular(40),
                  width: SizeConfig.h(0.075),
                  fit: BoxFit.cover,
                ),
              ),

              if (lottiePath != null)
                Positioned(
                  top: -SizeConfig.h(0.03),
                  child: SizedBox(
                    width: SizeConfig.w(0.14),
                    height: SizeConfig.w(0.14),
                    child: CustomAppImage(
                      path: lottiePath,
                      width: reactionWidth ?? reactionSize,
                      height: reactionHeight ?? reactionSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: SizeConfig.h(0.004)),

        CustomTextWidget(
          name,
          color: appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.028),
        ),

        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderRadius: BorderRadius.circular(8),
          childHorizontalPad: SizeConfig.w(0.025),
          childVerticalPad: SizeConfig.h(0.001),
          child: CustomTextWidget(
            '$score',
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.026),
          ),
        ),
      ],
    );
  }

  String? _reactionLottiePath(ChallengeBotReaction reaction) {
    switch (reaction) {
      case ChallengeBotReaction.thinking:
        return AppImage.thinkIcon;
      case ChallengeBotReaction.correct:
        return AppImage.correctLottie;
      case ChallengeBotReaction.wrong:
        return AppImage.wrongIcon;
      case ChallengeBotReaction.none:
        return null;
    }
  }

  double _reactionSize(ChallengeBotReaction reaction) {
    switch (reaction) {
      case ChallengeBotReaction.thinking:
        return SizeConfig.w(0.12);
      case ChallengeBotReaction.correct:
        return SizeConfig.w(0.105);
      case ChallengeBotReaction.wrong:
        return SizeConfig.w(0.13);
      case ChallengeBotReaction.none:
        return 0;
    }
  }
}

class _ChallengePlayerScoreAvatar extends StatelessWidget {
  final String name;
  final String imagePath;
  final int score;
  final bool isActive;
  final bool isUser;

  const _ChallengePlayerScoreAvatar({
    required this.name,
    required this.imagePath,
    required this.score,
    required this.isActive,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final activeColor = isUser ? AppPalette.primary : const Color(0xFFD46BFF);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.all(isActive ? 3 : 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.35),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: CustomAppImage(
            path: imagePath,
            height: SizeConfig.h(0.075),
            borderRadius: BorderRadius.circular(40),
            width: SizeConfig.h(0.075),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: SizeConfig.h(0.005)),
        CustomTextWidget(
          name,
          color: appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.028),
        ),
        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderRadius: BorderRadius.circular(8),
          childHorizontalPad: SizeConfig.w(0.025),
          childVerticalPad: SizeConfig.h(0.001),
          child: CustomTextWidget(
            '$score',
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.026),
          ),
        ),
      ],
    );
  }
}

class _ChallengeBotScoreAvatar extends StatelessWidget {
  final TestPlayModesState state;
  final String name;
  final String imagePath;
  final int score;

  const _ChallengeBotScoreAvatar({
    required this.state,
    required this.name,
    required this.imagePath,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final reactionColor = _reactionColor();

    return Column(
      children: [
        Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _buildReactionWidget(context),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              padding: EdgeInsets.all(
                state.isChallengeBotReactionThinking ? 4 : 2,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: reactionColor.withOpacity(0.35),
                    blurRadius: state.isChallengeBotReactionThinking ? 18 : 10,
                    spreadRadius: state.isChallengeBotReactionThinking ? 4 : 1,
                  ),
                ],
              ),
              child: CustomAppImage(
                path: imagePath,
                height: SizeConfig.h(0.075),
                borderRadius: BorderRadius.circular(40),
                width: SizeConfig.h(0.075),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),

        CustomTextWidget(
          name,
          color: appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.028),
        ),

        CustomBackgroundWithChild(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderRadius: BorderRadius.circular(8),
          childHorizontalPad: SizeConfig.w(0.025),
          childVerticalPad: SizeConfig.h(0.001),
          child: CustomTextWidget(
            '$score',
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.026),
          ),
        ),
      ],
    );
  }

  Widget _buildReactionWidget(BuildContext context) {
    if (state.isChallengeBotReactionThinking) {
      return CustomTextWidget(
        'يفكر...',
        key: const ValueKey('thinking'),
        color: const Color(0xFFD46BFF),
        fontFamily: AppFont.elMessiriMedium,
        fontSize: SizeConfig.text(0.022),
      );
    }

    // if (state.isChallengeBotReactionCorrect) {
    //   return Row(
    //     key: const ValueKey('correct'),
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       const Icon(Icons.check_circle, color: AppPalette.green, size: 18),
    //       SizedBox(width: SizeConfig.w(0.01)),
    //       CustomTextWidget(
    //         'إجابة صحيحة',
    //         color: AppPalette.green,
    //         fontFamily: AppFont.elMessiriMedium,
    //         fontSize: SizeConfig.text(0.022),
    //       ),
    //     ],
    //   );
    // }

    // if (state.isChallengeBotReactionWrong) {
    //   return Row(
    //     key: const ValueKey('wrong'),
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       const Icon(Icons.cancel, color: AppPalette.red, size: 18),
    //       SizedBox(width: SizeConfig.w(0.01)),
    //       CustomTextWidget(
    //         'إجابة خاطئة',
    //         color: AppPalette.red,
    //         fontFamily: AppFont.elMessiriMedium,
    //         fontSize: SizeConfig.text(0.022),
    //       ),
    //     ],
    //   );
    // }

    return SizedBox(key: const ValueKey('empty'), height: SizeConfig.h(0.025));
  }

  Color _reactionColor() {
    if (state.isChallengeBotReactionCorrect) {
      return AppPalette.green;
    }

    if (state.isChallengeBotReactionWrong) {
      return AppPalette.red;
    }

    return const Color(0xFFD46BFF);
  }
}
