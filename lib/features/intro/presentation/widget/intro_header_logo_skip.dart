import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class IntroHeaderLogoSkip extends StatelessWidget {
  final VoidCallback onSkip;

  const IntroHeaderLogoSkip({
    super.key,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.06),
        vertical: SizeConfig.h(0.02),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AppImage.logo, height: SizeConfig.h(0.06)),
          InkWell(
            onTap: onSkip,
            child: Row(
              children: [
                CustomTextWidget(
                  "تخطي",
                  fontSize: SizeConfig.text(0.055),
                  color: AppColor.black,
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: SizeConfig.h(0.025),
                  color: AppColor.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}