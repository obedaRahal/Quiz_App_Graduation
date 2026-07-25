import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class SoldTestsHeader extends StatelessWidget {
  final String? title;
  const SoldTestsHeader({super.key, this.title = 'الاختبارات المباعة'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.w(0.03),
        right: SizeConfig.w(0.03),
        top: SizeConfig.h(0.03),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _HeaderActionButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: () => Navigator.pop(context),
          ),
          CustomTextWidget(
            title ?? " العنوان",
            color: context.appColors.blackTogreyMedium,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.045),
          ),
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
    final appColors = context.appColors;

    return CustomButtonWidget(
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.w(0.02),
      borderRadius: 20,
      boxShadow: [
        BoxShadow(
          color: appColors.greyMediumTogrey,
          blurRadius: 2,
          offset: const Offset(0, 0),
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
