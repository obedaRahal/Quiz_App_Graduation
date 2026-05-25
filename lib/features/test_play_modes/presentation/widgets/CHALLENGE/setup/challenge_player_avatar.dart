import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/review_tab/my_published_review_card.dart';

class ChallengePlayerAvatar extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool showTapHint;

  const ChallengePlayerAvatar({super.key, 
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

