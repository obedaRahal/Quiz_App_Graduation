import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_edit_small_button.dart';

class StudyPlanSectionHeader extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final VoidCallback onTap;

  final String? subtitle;
  final IconData? buttonIcon;

  const StudyPlanSectionHeader({
    super.key,
    required this.title,
    required this.buttonTitle,
    required this.onTap,
    this.subtitle,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfileEditSmallButton(
          title: buttonTitle,
          onTap: onTap,
          textColor: context.appColors.primaryToPrimaryDark,
        ),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
              CustomTextWidget(
                subtitle!,
                fontSize: SizeConfig.text(0.03),
                fontFamily: AppFont.elMessiriSemiBold,
                color: context.appColors.primaryToPrimaryDark,
              ),
              SizedBox(width: SizeConfig.w(0.012)),
            ],

            CustomTextWidget(
              title,
              fontSize: SizeConfig.text(0.04),
              fontFamily: AppFont.elMessiriSemiBold,
              color: context.appColors.blackToGrey2Dark,
            ),
          ],
        ),
      ],
    );
  }
}
