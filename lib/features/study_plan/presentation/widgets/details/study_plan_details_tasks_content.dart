import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class StudyPlanDetailsTasksContent
    extends StatelessWidget {
  const StudyPlanDetailsTasksContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.h(0.06),
      ),
      child: Column(
        children: [
          Icon(
            Icons.checklist_rounded,
            size: SizeConfig.text(0.13),
            color: AppPalette.greyMedium,
          ),

          SizedBox(height: SizeConfig.h(0.014)),

          CustomTextWidget(
            'قائمة المهام',
            fontSize: SizeConfig.text(0.037),
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: SizeConfig.h(0.006)),

          CustomTextWidget(
            'سيتم عرض مهام الخطة هنا',
            fontSize: SizeConfig.text(0.03),
            color: AppPalette.greyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}