import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/result/challenge_result_player_item.dart';

class ChallengeResultHeroCard extends StatelessWidget {
  final TestPlayModesState state;
  final String opponentName;
  final String opponentImage;
  final String playerName;
  final String playerImage;

  const ChallengeResultHeroCard({
    super.key,
    required this.state,
    required this.opponentName,
    required this.opponentImage,
    required this.playerName,
    required this.playerImage,
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
                    ResultPlayerItem(
                      name: playerName,
                      imagePath: playerImage,
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

                    ResultPlayerItem(
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
