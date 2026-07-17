import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

class StudyPlanDetailsSubjectsSection extends StatelessWidget {
  final StudyPlanDetailsSubjectsEntity subjects;

  const StudyPlanDetailsSubjectsSection({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: CustomTextWidget(
                'مواد الخطة',
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.043),
                color: appColors.blackToGrey2Dark,
                textAlign: TextAlign.right,
              ),
            ),

            CustomTextWidget(
              subjects.label,
              fontFamily: AppFont.elMessiriSemiBold,
              fontSize: SizeConfig.text(0.036),
              color: appColors.primaryToPrimaryDark,
              textDirection: TextDirection.ltr,
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.014)),

        if (subjects.items.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.04),
              vertical: SizeConfig.h(0.018),
            ),
            decoration: BoxDecoration(
              color: appColors.primarySoftTogreyLightDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomTextWidget(
              'لا توجد مواد مرتبطة بهذه الخطة',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.03),
              textAlign: TextAlign.center,
            ),
          )
        else
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              textDirection: TextDirection.rtl,
              alignment: WrapAlignment.start,
              spacing: SizeConfig.w(0.02),
              runSpacing: SizeConfig.h(0.012),
              children: subjects.items.map((subject) {
                return CustomBackgroundWithChild(
                  borderRadius: BorderRadius.circular(4),
                  childHorizontalPad: SizeConfig.w(0.025),
                  childVerticalPad: SizeConfig.h(0.005),
                  backgroundColor: appColors.primarySoftTogreyLightDark,
                  child: CustomTextWidget(
                    '# ${subject.name}',
                    color: appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.031),
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
