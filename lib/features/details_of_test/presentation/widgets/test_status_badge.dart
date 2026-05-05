import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class TestStatusBadge extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final FaIconData icon;

  const TestStatusBadge({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      backgroundColor: backgroundColor,
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.h(0.003),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: SizeConfig.h(0.02), color: foregroundColor),
          const SizedBox(width: 5),
          CustomTextWidget(
            title,
            color: foregroundColor,
            fontFamily: AppFont.elMessiriSemiBold,
            fontSize: SizeConfig.text(0.03),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
