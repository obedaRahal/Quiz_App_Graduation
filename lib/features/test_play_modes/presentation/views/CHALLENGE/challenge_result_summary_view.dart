import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_result_summary_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/result/challenge_result_hero_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/result/challenge_result_legend.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/result/challenge_result_question_card.dart';
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

            final viewer = state.content?.data.viewer;
            final playerName = viewer?.name ?? 'أنت';
            final playerImage = viewer?.avatarUrl ;

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

                ChallengeResultHeroCard(
                  state: state,
                  opponentName: selectedCharacter.name,
                  opponentImage: selectedCharacter.imagePath,
                  playerName: playerName,
                  playerImage: playerImage ?? AppImage.male,
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
                        const ChallengeResultLegend(),

                        SizedBox(height: SizeConfig.h(0.018)),

                        _ChallengeQuestionsResultList(state: state),
                      ],
                    ),
                  ),
                ),

                PlayAgainButton(
                  onTap: () {
                    context.read<TestPlayModesCubit>().resetSession();
                    //context.read<TestPlayModesCubit>().loadMockTestContent();

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
          child: ChallengeResultQuestionCard(
            question: question,
            answer: answer,
            totalQuestions: state.totalQuestions,
          ),
        );
      }).toList(),
    );
  }
}
