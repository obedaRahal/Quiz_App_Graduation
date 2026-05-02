
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TopPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback onShare;

  const TopPageHeader({
    super.key,
    required this.title,
    required this.onBack,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderActionButton(icon: Icons.arrow_back_ios, onTap: onBack),
          Expanded(
            child: Center(
              child: CustomTextWidget(
                title,
                color: AppPalette.black,
                fontFamily: AppFont.elMessiriSemiBold,
              ),
            ),
          ),
          _HeaderActionButton(icon: Icons.ios_share, onTap: onShare),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.h(0.01),
      borderRadius: 20,
      boxShadow: const [
        BoxShadow(
          color: AppPalette.greyMedium,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      backgroundColor: AppPalette.white,
      onTap: onTap,
      child: Icon(icon, color: AppPalette.black, size: SizeConfig.h(0.03)),
    );
  }
}
