import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_session_header_and_botton.dart';

class StudyPlanDailyTasksHeader extends StatelessWidget {
  final int tasksCount;
  final VoidCallback onShowAllTap;

  const StudyPlanDailyTasksHeader({
    super.key,
    required this.tasksCount,
    required this.onShowAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return StudyPlanSectionHeader(
      title: 'قائمة المهام',
      subtitle: '($tasksCount مهمة)',
      buttonTitle: 'عرض كل المهام',
      buttonIcon: Icons.arrow_back_rounded,
      onTap: onShowAllTap,
    );
  }
}
