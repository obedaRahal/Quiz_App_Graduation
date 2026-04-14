import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TowTextRow extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;

  const TowTextRow({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        CustomTextWidget(
          text,
          fontSize: SizeConfig.diagonal * .018,
          color: AppPalette.greyMedium,
        ),
        InkWell(
          onTap: onTap,
          child: CustomTextWidget(
            actionText,
            fontSize: SizeConfig.diagonal * .02,
            color: appColors.primaryToPrimaryDark,
          ),
        ),
      ],
    );
  }
}
