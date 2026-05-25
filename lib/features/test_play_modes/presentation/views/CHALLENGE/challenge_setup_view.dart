import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/CHALLENGE/challenge_session_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/setup/challenge_characters_panel.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/setup/challenge_main_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/setup/challenge_rules_panel.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/challenge/challenge_characters_data.dart';

class ChallengeSetupView extends StatefulWidget {
  final int testId;

  const ChallengeSetupView({super.key, required this.testId});

  @override
  State<ChallengeSetupView> createState() => _ChallengeSetupViewState();
}

class _ChallengeSetupViewState extends State<ChallengeSetupView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TestPlayModesCubit>().getTestPlayContent(
        testId: widget.testId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppPalette.blueDark : AppPalette.blueLight,
      body: SafeArea(
        child: BlocBuilder<TestPlayModesCubit, TestPlayModesState>(
          builder: (context, state) {
            final selectedCharacter = ChallengeCharactersData.selectedById(
              state.selectedChallengeCharacterId,
            );

            if (state.isContentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isContentFailure) {
              return Center(
                child: CustomTextWidget(
                  state.errorMessage ?? 'حدث خطأ أثناء تحميل بيانات التحدي',
                  color: AppPalette.red,
                  textAlign: TextAlign.center,
                ),
              );
            }

            final viewer = state.content?.data.viewer;
            final playerName = viewer?.name ?? 'أنت';
            final playerAvatar = viewer?.avatarUrl ?? AppImage.carmen;

            return Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopPageHeader(
                  title: 'إعداد التحدي',
                  onBack: () => Navigator.pop(context),
                  icon: Icons.info_outline_rounded,
                  onIconTap: () {
                    context
                        .read<TestPlayModesCubit>()
                        .toggleChallengeRulesPanel();
                  },
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                SizedBox(
                  height: SizeConfig.h(0.2),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: state.isChallengeRulesPanelVisible
                        ? const ChallengeRulesPanel(
                            key: ValueKey('rules_panel'),
                          )
                        : state.isChallengeCharactersPanelVisible
                        ? ChallengeCharactersPanel(
                            key: ValueKey('characters_panel'),
                            selectedCharacterId:
                                state.selectedChallengeCharacterId,
                            onCharacterSelected: (characterId) {
                              context
                                  .read<TestPlayModesCubit>()
                                  .selectChallengeCharacter(characterId);
                            },
                          )
                        : const SizedBox(key: ValueKey('empty_panel')),
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.03)),

                Stack(
                  children: [
                    ThemedAppImage(
                      lightPath: AppImage.challengeMainCardLight,
                      darkPath: AppImage.challengeMainCardDark,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.w(0.03),
                            vertical: SizeConfig.h(0.01),
                          ),
                          child: ChallengeMainCard(
                            selectedCharacterName: selectedCharacter.name,
                            selectedCharacterImage: selectedCharacter.imagePath,
                            playerName: playerName,
                            playerImage: playerAvatar,
                            selectedDifficulty:
                                state.selectedChallengeDifficulty,
                            onOpponentTap: () {
                              context
                                  .read<TestPlayModesCubit>()
                                  .toggleChallengeCharactersPanel();
                            },
                            onDifficultyChanged: (difficulty) {
                              context
                                  .read<TestPlayModesCubit>()
                                  .changeChallengeDifficulty(difficulty);
                            },
                            onStartChallenge: () {
                              debugPrint(
                                'start challenge with testId: ${widget.testId}',
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<TestPlayModesCubit>(),
                                    child: const ChallengeSessionView(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


// class _VsBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomBackgroundWithChild(
//       backgroundColor: AppPalette.orange.withOpacity(0.15),
//       borderRadius: BorderRadius.circular(20),
//       childHorizontalPad: SizeConfig.w(0.035),
//       childVerticalPad: SizeConfig.h(0.008),
//       child: CustomTextWidget(
//         'VS',
//         color: AppPalette.orange,
//         fontFamily: AppFont.elMessiriBold,
//         fontSize: SizeConfig.text(0.045),
//       ),
//     );
//   }
// }

