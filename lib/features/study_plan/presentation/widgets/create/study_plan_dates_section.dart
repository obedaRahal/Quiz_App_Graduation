import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';

class StudyPlanDatesSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;

  const StudyPlanDatesSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateTap,
    required this.onEndDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         StudyPlanFormSectionHeader(
          title: 'تواريخ الخطة',
          description:
              'اختر تاريخ بداية ونهاية الخطة لتحديد المدة التي ستعمل خلالها على إنجاز مهامك.',
          image: AppImage.stopwatch,
        ),

        SizedBox(
          height: SizeConfig.h(0.016),
        ),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: StudyPlanSelectionBox(
                title: 'من',
                value: startDate == null
                    ? null
                    : _formatDate(startDate!),
                icon: Icons.calendar_month_outlined,
                onTap: onStartDateTap,
              ),
            ),

            SizedBox(
              width: SizeConfig.w(0.025),
            ),

            Icon(
              Icons.arrow_back_rounded,
              color: AppPalette.greyMedium,
            ),

            SizedBox(
              width: SizeConfig.w(0.025),
            ),

            Expanded(
              child: StudyPlanSelectionBox(
                title: 'إلى',
                value: endDate == null
                    ? null
                    : _formatDate(endDate!),
                icon: Icons.calendar_month_outlined,
                onTap: onEndDateTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}