import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
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
  Timer? _characterRollTimer;
  bool _isRollingCharacter = false;
  int? _rollingCharacterId;
  bool _didInitialRoll = false;
  double _rollingOffsetY = 0;

  final Random _random = Random();

  void _startRandomCharacterRoll() {
    if (_isRollingCharacter) return;

    final characters = ChallengeCharactersData.characters;

    setState(() {
      _isRollingCharacter = true;
      _rollingOffsetY = 0;
    });

    int ticks = 0;

    _characterRollTimer?.cancel();
    _characterRollTimer = Timer.periodic(const Duration(milliseconds: 250), (
      timer,
    ) {
      ticks++;

      setState(() {
        _rollingOffsetY = -SizeConfig.h(0.06);
      });

      Future.delayed(const Duration(milliseconds: 45), () {
        if (!mounted || !_isRollingCharacter) return;

        final randomCharacter = characters[_random.nextInt(characters.length)];

        setState(() {
          _rollingCharacterId = randomCharacter.id;
          _rollingOffsetY = SizeConfig.h(0.06);
        });

        Future.delayed(const Duration(milliseconds: 45), () {
          if (!mounted || !_isRollingCharacter) return;

          setState(() {
            _rollingOffsetY = 0;
          });
        });
      });

      if (ticks >= 18) {
        timer.cancel();

        final selectedCharacter =
            characters[_random.nextInt(characters.length)];

        context.read<TestPlayModesCubit>().selectChallengeCharacter(
          selectedCharacter.id,
        );

        setState(() {
          _rollingCharacterId = null;
          _rollingOffsetY = 0;
          _isRollingCharacter = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _characterRollTimer?.cancel();
    super.dispose();
  }

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
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppPalette.blueDark : AppPalette.blueLight,
      body: SafeArea(
        child: BlocBuilder<TestPlayModesCubit, TestPlayModesState>(
          builder: (context, state) {
            final pageTitle = state.test?.title ?? '';

            // final selectedCharacter = ChallengeCharactersData.selectedById(
            //   state.selectedChallengeCharacterId,
            // );

            final selectedCharacter = ChallengeCharactersData.selectedById(
              _rollingCharacterId ?? state.selectedChallengeCharacterId,
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

            if (!_didInitialRoll && state.isContentSuccess) {
              _didInitialRoll = true;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                _startRandomCharacterRoll();
              });
            }

            final viewer = state.content?.data.viewer;
            final playerName = viewer?.name ?? 'أنت';
            final playerAvatar = viewer?.avatarUrl ?? AppImage.carmen;

            return Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TopPageHeader(
                  title: pageTitle,
                  onBack: () => Navigator.pop(context),
                  icon: Icons.info_outline_rounded,
                  titleColor: isDark ? AppPalette.grey2Dark : AppPalette.black,
                  onIconTap: () {
                    context
                        .read<TestPlayModesCubit>()
                        .toggleChallengeRulesPanel();
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
                SizedBox(height: SizeConfig.h(0.015)),

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
                            //onOpponentTap: _startRandomCharacterRoll,
                            onOpponentTap: () {
                              context
                                  .read<TestPlayModesCubit>()
                                  .toggleChallengeCharactersPanel();
                            },
                            isOpponentRolling: _isRollingCharacter,
                            opponentRollingOffsetY: _rollingOffsetY,
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

