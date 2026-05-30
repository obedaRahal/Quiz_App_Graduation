import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_card.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/widgets/CHALLENGE/challenge_characters_data.dart';

class ChallengeCharactersPanel extends StatelessWidget {
  final int selectedCharacterId;
  final ValueChanged<int> onCharacterSelected;

  const ChallengeCharactersPanel({
    super.key,
    required this.selectedCharacterId,
    required this.onCharacterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final availableCharacters = ChallengeCharactersData.characters
        .where((character) => character.id != selectedCharacterId)
        .toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: isDark ? AppPalette.greyMediumDark : const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(18),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: SizeConfig.h(0.02)),

            CustomTextWidget(
              'الشخصيات',
              color: appColors.blackToGrey2Dark,
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
                    onTap: () => onCharacterSelected(character.id),
                    child: Column(
                      children: [
                        ReviewerAvatar(avatarPath: character.imagePath),

                        SizedBox(height: SizeConfig.h(0.006)),

                        CustomBackgroundWithChild(
                          backgroundColor: appColors.whiteToblack,
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
