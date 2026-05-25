import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/challenge_characters_data.dart';

class ChallengePlayersScoreSection extends StatelessWidget {
  final TestPlayModesState state;

  const ChallengePlayersScoreSection({super.key, required this.state});

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
    if (state.isChallengeUserThinking) {
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
