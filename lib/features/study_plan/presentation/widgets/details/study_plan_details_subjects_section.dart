import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
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
          const EmptyActionBox(
            icon: Icons.menu_book_outlined,
            title: 'لا توجد مواد',
            description: 'لا توجد مواد دراسية مرتبطة بهذه الخطة',
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
