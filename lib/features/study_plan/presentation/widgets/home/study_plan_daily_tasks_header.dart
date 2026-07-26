import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanDailyTasksHeader extends StatelessWidget {
  const StudyPlanDailyTasksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          'عرض كل المهام',
          fontSize: SizeConfig.text(0.04),
          fontFamily: AppFont.elMessiriSemiBold,
          color: context.appColors.blackToGrey2Dark,
        ),
      ],
    );
  }
}
