
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ChipsSection extends StatelessWidget {
  final String title;
  final List<String> chips;
  final Color chipColor;
  final Color textColor;

  const ChipsSection({super.key, 
    required this.title,
    required this.chips,
    required this.chipColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          title,
          color: context.appColors.blackTogreyMedium,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.036),
        ),
        SizedBox(height: SizeConfig.h(0.01)),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            textDirection: TextDirection.rtl,
            spacing: SizeConfig.w(0.018),
            runSpacing: SizeConfig.h(0.01),
            children: chips.map((chip) {
              return CustomBackgroundWithChild(
                backgroundColor: chipColor,
                borderRadius: BorderRadius.circular(5),
                childHorizontalPad: SizeConfig.w(0.022),
                childVerticalPad: SizeConfig.h(0.004),
                child: CustomTextWidget(
                  '# $chip',
                  color: textColor,
                  fontSize: SizeConfig.text(0.027),
                  textDirection: TextDirection.rtl,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}