import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/CHALLENGE/challenge_session_view.dart';
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
                        ? const _ChallengeRulesPanel(
                            key: ValueKey('rules_panel'),
                          )
                        : state.isChallengeCharactersPanelVisible
                        ? _ChallengeCharactersPanel(
                            key: ValueKey('characters_panel'),
                            selectedCharacterId:
                                state.selectedChallengeCharacterId,
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
                          child: _ChallengeMainCard(
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

                // Center(
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: SizeConfig.w(0.03),
                //     ),
                //     child: _ChallengeMainCard(
                //       selectedCharacterName: selectedCharacter.name,
                //       selectedCharacterImage: selectedCharacter.imagePath,
                //       selectedDifficulty: state.selectedChallengeDifficulty,
                //       onOpponentTap: () {
                //         context
                //             .read<TestPlayModesCubit>()
                //             .toggleChallengeCharactersPanel();
                //       },
                //       onDifficultyChanged: (difficulty) {
                //         context
                //             .read<TestPlayModesCubit>()
                //             .changeChallengeDifficulty(difficulty);
                //       },
                //       onStartChallenge: () {
                //         debugPrint('start challenge with testId: $testId');
                //         // لاحقًا ننتقل لواجهة challenge session
                //       },
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChallengeRulesPanel extends StatelessWidget {
  const _ChallengeRulesPanel({super.key});
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.whiteToPrimaryDark,
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.all(SizeConfig.w(0.035)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              'قواعد التحدي',
              color: appColors.blackToGrey2Dark,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
            ),
            SizedBox(height: SizeConfig.h(0.008)),
            Row(
              children: [
                Expanded(
                  child: CustomTextWidget(
                    'كل إجابة صحيحة لك تحسب نقطة واحدة وكذلك للخصم بنفس الطريقة في حال اجابته بشكل صحيح',
                    color: appColors.greyMediumTogrey,
                    fontFamily: AppFont.elMessiriMedium,
                    fontSize: SizeConfig.text(0.026),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.01)),
                CustomBackgroundWithChild(
                  borderRadius: BorderRadius.circular(20),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(0.01)),
                  backgroundColor: AppPalette.primarySoft,
                  child: CustomTextWidget(
                    '1',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.04),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(0.01)),

            Row(
              children: [
                Expanded(
                  child: CustomTextWidget(
                    'الاجابة الخاطئة لا تلغي نقطة وفي حال عدم الاجابة خلال الوقت المحدد لن يتم الحصول على نقاط',
                    color: appColors.greyMediumTogrey,
                    fontFamily: AppFont.elMessiriMedium,
                    fontSize: SizeConfig.text(0.026),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.01)),
                CustomBackgroundWithChild(
                  borderRadius: BorderRadius.circular(20),
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.h(0.01)),
                  backgroundColor: AppPalette.primarySoft,
                  child: CustomTextWidget(
                    '2',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.04),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCharactersPanel extends StatelessWidget {
  final int selectedCharacterId;
  const _ChallengeCharactersPanel({
    super.key,
    required this.selectedCharacterId,
  });
  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final availableCharacters = ChallengeCharactersData.characters
        .where((character) => character.id != selectedCharacterId)
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: SizeConfig.h(0.02)),
            CustomTextWidget(
              'الشخصيات',
              color: appColors.blackToGreyLightDark,
              fontFamily: AppFont.elMessiriBold,
              fontSize: SizeConfig.text(0.04),
            ),
            SizedBox(height: SizeConfig.h(0.012)),
            SizedBox(
              height: SizeConfig.h(0.12),
              child: ListView.separated(
                reverse: true,
                scrollDirection: Axis.horizontal,
                itemCount: availableCharacters.length,
                separatorBuilder: (_, __) =>
                    SizedBox(width: SizeConfig.w(0.04)),
                itemBuilder: (context, index) {
                  final character = availableCharacters[index];

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<TestPlayModesCubit>()
                          .selectChallengeCharacter(character.id);
                    },
                    child: Column(
                      children: [
                        ReviewerAvatar(avatarPath: character.imagePath),

                        SizedBox(height: SizeConfig.h(0.006)),
                        CustomBackgroundWithChild(
                          backgroundColor: AppPalette.white,
                          childHorizontalPad: SizeConfig.h(0.01),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: appColors
                                .borderFieldColorNLightToborderFieldColorNDark,
                          ),
                          child: CustomTextWidget(
                            character.name,
                            color: appColors.blackToGrey2Dark,
                            fontFamily: AppFont.elMessiriSemiBold,
                            fontSize: SizeConfig.text(0.026),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeMainCard extends StatelessWidget {
  final String selectedCharacterName;
  final String selectedCharacterImage;
  final String playerName;
  final String playerImage;
  final ChallengeDifficulty selectedDifficulty;
  final VoidCallback onOpponentTap;
  final ValueChanged<ChallengeDifficulty> onDifficultyChanged;
  final VoidCallback onStartChallenge;

  const _ChallengeMainCard({
    required this.selectedCharacterName,
    required this.selectedCharacterImage,
    required this.playerName,
    required this.playerImage,
    required this.selectedDifficulty,
    required this.onOpponentTap,
    required this.onDifficultyChanged,
    required this.onStartChallenge,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      width: double.infinity,
      backgroundColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      padding: EdgeInsets.all(SizeConfig.w(0.045)),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ChallengePlayerAvatar(title: playerName, imagePath: playerImage),

              //_VsBadge(),
              SizedBox(width: SizeConfig.w(0.02)),

              GestureDetector(
                onTap: onOpponentTap,
                child: _ChallengePlayerAvatar(
                  title: selectedCharacterName,
                  imagePath: selectedCharacterImage,
                  showTapHint: true,
                ),
              ),
            ],
          ),
          //Spacer(),
          SizedBox(height: SizeConfig.h(0.07)),

          CustomTextWidget(
            'تحدي',
            color: appColors.blackTogreyMedium,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.05),
          ),

          SizedBox(height: SizeConfig.h(0.005)),

          CustomTextWidget(
            'حاول التغلب على نيرد في هذا التحدي الممتع انتبه ! ليس لديك الكثير من الوقت يا صديقي',
            color: AppPalette.greyMedium,
            fontFamily: AppFont.elMessiriMedium,
            fontSize: SizeConfig.text(0.03),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: SizeConfig.h(0.005)),

          _ChallengeDifficultySelector(
            selectedDifficulty: selectedDifficulty,
            onChanged: onDifficultyChanged,
          ),

          SizedBox(height: SizeConfig.h(0.02)),

          GestureDetector(
            onTap: onStartChallenge,
            child: CustomBackgroundWithChild(
              width: double.infinity,
              height: SizeConfig.h(0.05),
              alignment: Alignment.center,
              backgroundColor: appColors.primaryToPrimaryDark,
              boxShadow: [BoxShadow(color: AppPalette.primary, blurRadius: 4)],
              borderRadius: BorderRadius.circular(18),
              child: CustomTextWidget(
                'ابدأ التحدي',
                color: AppPalette.white,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.035),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengePlayerAvatar extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool showTapHint;

  const _ChallengePlayerAvatar({
    required this.title,
    required this.imagePath,
    this.showTapHint = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // CircleAvatar(
            //   radius: SizeConfig.w(0.105),
            //   backgroundColor: appColors.primarySoftTogreyLightDark,
            //   backgroundImage:
            // ),
            ReviewerAvatar(avatarPath: imagePath),
            if (showTapHint)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.018),
                  vertical: SizeConfig.h(0.002),
                ),
                decoration: BoxDecoration(
                  color: appColors.primaryToPrimaryDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomTextWidget(
                  'تغيير',
                  color: AppPalette.white,
                  fontFamily: AppFont.elMessiriMedium,
                  fontSize: SizeConfig.text(0.015),
                ),
              ),
          ],
        ),
        SizedBox(height: SizeConfig.h(0.008)),
        CustomBackgroundWithChild(
          backgroundColor: AppPalette.white,
          borderRadius: BorderRadius.circular(10),
          childHorizontalPad: SizeConfig.w(0.025),
          child: CustomTextWidget(
            title,
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.03),
          ),
        ),
      ],
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

class _ChallengeDifficultySelector extends StatelessWidget {
  final ChallengeDifficulty selectedDifficulty;
  final ValueChanged<ChallengeDifficulty> onChanged;

  const _ChallengeDifficultySelector({
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          'مستوى التحدي',
          color: appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriSemiBold,
          fontSize: SizeConfig.text(0.04),
        ),
        SizedBox(height: SizeConfig.h(0.01)),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            _DifficultyChip(
              title: 'سهل',
              difficulty: ChallengeDifficulty.easy,
              selectedDifficulty: selectedDifficulty,
              onChanged: onChanged,
            ),
            SizedBox(width: SizeConfig.w(0.02)),
            _DifficultyChip(
              title: 'متوسط',
              difficulty: ChallengeDifficulty.medium,
              selectedDifficulty: selectedDifficulty,
              onChanged: onChanged,
            ),
            SizedBox(width: SizeConfig.w(0.02)),
            _DifficultyChip(
              title: 'صعب',
              difficulty: ChallengeDifficulty.hard,
              selectedDifficulty: selectedDifficulty,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final String title;
  final ChallengeDifficulty difficulty;
  final ChallengeDifficulty selectedDifficulty;
  final ValueChanged<ChallengeDifficulty> onChanged;

  const _DifficultyChip({
    required this.title,
    required this.difficulty,
    required this.selectedDifficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isSelected = difficulty == selectedDifficulty;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(difficulty),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: SizeConfig.h(0.03),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? appColors.primaryToPrimaryDark
                : appColors.primarySoftTogreyLightDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? appColors.primaryToPrimaryDark
                  : appColors.borderFieldColorNLightToborderFieldColorNDark,
            ),
          ),
          child: CustomTextWidget(
            title,
            color: isSelected ? AppPalette.white : appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.03),
          ),
        ),
      ),
    );
  }
}
