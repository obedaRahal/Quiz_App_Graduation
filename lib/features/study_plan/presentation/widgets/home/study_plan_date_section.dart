import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_session_header_and_botton.dart';

class StudyPlanDateSection extends StatelessWidget {
  final String selectedDate;
  final VoidCallback onManageSubjectsTap;

  const StudyPlanDateSection({
    super.key,
    required this.selectedDate,
    required this.onManageSubjectsTap,
  });

  @override
  Widget build(BuildContext context) {
    return StudyPlanSectionHeader(
      title: _formatDate(selectedDate),
      buttonTitle: 'إدارة المواد',
      onTap: onManageSubjectsTap,
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    return DateFormat('EEEE، d MMMM yyyy', 'ar').format(date);
  }
}
