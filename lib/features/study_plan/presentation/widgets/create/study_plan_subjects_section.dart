import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';

class StudyPlanSubjectsSection extends StatelessWidget {
  final int selectedSubjectsCount;
  final int maxSubjects;
  final bool isLoading;
  final VoidCallback onTap;

  const StudyPlanSubjectsSection({
    super.key,
    required this.selectedSubjectsCount,
    required this.onTap,
    this.maxSubjects = 10,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubjects = selectedSubjectsCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudyPlanFormSectionHeader(
          title: 'مواد الخطة',
          description:
              'اختر المواد التي تريد إضافتها داخل الخطة الدراسية، ويمكنك اختيار عشر مواد على الأكثر.',
          image: AppImage.layers,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        StudyPlanSelectionBox(
          title: isLoading ? 'جارٍ تحميل المواد...' : 'اختر موادك',
          value: hasSubjects
              ? '$selectedSubjectsCount/$maxSubjects مواد محددة'
              : null,
          icon: Icons.layers_outlined,
          enabled: !isLoading,
          onTap: onTap,
        ),
      ],
    );
  }
}
