import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TopPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onIconTap;
  final IconData icon;
  final Color? titleColor;

  const TopPageHeader({
    super.key,
    required this.title,
    required this.onBack,
    required this.onIconTap,
    required this.icon,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final resolvedTitleColor = titleColor ?? appColors.blackTogreyMedium;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderActionButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: onBack,
          ),
          Expanded(
            child: Center(
              child: CustomTextWidget(
                title,
                color: resolvedTitleColor,
                fontFamily: AppFont.elMessiriSemiBold,
              ),
            ),
          ),
          HeaderActionButton(icon: icon, onTap: onIconTap),
        ],
      ),
    );
  }
}

class HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const HeaderActionButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomButtonWidget(
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.w(0.02),
      borderRadius: 20,
      boxShadow: [
        BoxShadow(
          color: appColors.greyMediumTogrey,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      backgroundColor: appColors.whiteToblack,
      onTap: onTap,
      child: Icon(
        icon,
        color: appColors.blackTogreyMedium,
        size: SizeConfig.h(0.03),
      ),
    );
  }
}
