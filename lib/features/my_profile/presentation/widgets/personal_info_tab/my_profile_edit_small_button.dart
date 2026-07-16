import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ProfileEditSmallButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileEditSmallButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      onTap: onTap,
      backgroundColor: context.appColors.greyToGreyMediumDark,
      borderRadius: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_rounded,
              color: AppPalette.greyMedium,
              size: SizeConfig.h(0.018),
            ),

            SizedBox(width: SizeConfig.w(0.05)),

            CustomTextWidget(
              title,
              fontSize: SizeConfig.text(0.028),
              color: AppPalette.greyMedium,
            ),
          ],
        ),
      ),
    );
  }
}