import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/setup/challenge_difficulty_selector.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/setup/challenge_player_avatar.dart';

class ChallengeMainCard extends StatelessWidget {
  final String selectedCharacterName;
  final String selectedCharacterImage;
  final String playerName;
  final String playerImage;
  final ChallengeDifficulty selectedDifficulty;
  final VoidCallback onOpponentTap;
  final ValueChanged<ChallengeDifficulty> onDifficultyChanged;
  final VoidCallback onStartChallenge;

  const ChallengeMainCard({
    super.key,
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
              ChallengePlayerAvatar(title: playerName, imagePath: playerImage),

              SizedBox(width: SizeConfig.w(0.02)),

              GestureDetector(
                onTap: onOpponentTap,
                child: ChallengePlayerAvatar(
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

          ChallengeDifficultySelector(
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

