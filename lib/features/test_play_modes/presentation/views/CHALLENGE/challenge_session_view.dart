import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/CHALLENGE/challenge_result_summary_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/challenge_question_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/session/challenge_battle_progress_bar.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/session/challenge_next_button.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/session/challenge_players_score_section.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/session/challenge_session_info_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/exit_test_play_mode_dialog.dart';

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
  }

  void _onBackTap() {
    final state = context.read<TestPlayModesCubit>().state;

    if (state.isCompleted) {
      Navigator.pop(context);
      return;
    }

    showExitTestPlayModeDialog(
      context: context,
      onExitConfirmed: () {
        context.read<TestPlayModesCubit>().restartChallengeSession();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
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
            if (state.isCompleted) {
              return const ChallengeResultSummaryView();
            }

            final question = state.currentQuestion;

            if (question == null) {
              return const SizedBox.shrink();
            }

            if (state.isCompleted) {
              ChallengeResultSummaryView();
            }

            return Column(
              children: [
                TopPageHeader(
                  title: state.test?.title ?? 'جلسة التحدي',
                  onBack: _onBackTap,
                  icon: state.isVoiceSpeaking
                      ? Icons.stop_circle_outlined
                      : Icons.volume_up_outlined,
                  onIconTap: _onSoundTap,
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                ChallengeSessionInfoHeader(state: state),

                SizedBox(height: SizeConfig.h(0.008)),

                ChallengeBattleProgressBar(state: state),

                SizedBox(height: SizeConfig.h(0.018)),

                ChallengePlayersScoreSection(state: state),

                SizedBox(height: SizeConfig.h(0.02)),

                Expanded(
                  child: CustomBackgroundWithChild(
                    width: double.infinity,
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
                            ChallengeNextButton(
                              onNextQuestion: _onNextQuestion,
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
