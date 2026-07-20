import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subjects/study_task_subject_option.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subjects/study_task_subjects_bottom_sheet.dart';

class StudyTaskSubjectsSection extends StatelessWidget {
  final List<StudyTaskSubjectOption> subjects;
  final int? selectedSubjectId;

  final ValueChanged<int> onSubjectChanged;

  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  final String sectionDescription;

  const StudyTaskSubjectsSection({
    super.key,
    required this.subjects,
    required this.selectedSubjectId,
    required this.onSubjectChanged,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.sectionDescription = 'اختر المادة الدراسية المرتبطة بهذه المهمة.',
  });

  StudyTaskSubjectOption? get _selectedSubject {
    for (final subject in subjects) {
      if (subject.id == selectedSubjectId) {
        return subject;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudyPlanFormSectionHeader(
          title: 'المادة الدراسية',
          description: sectionDescription,
          image: AppImage.bookmark,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (errorMessage != null && subjects.isEmpty)
          _SubjectsFailureBody(message: errorMessage!, onRetry: onRetry)
        else
          StudyPlanSelectionBox(
            title: 'اختر المادة',
            value: _selectedSubject?.name,
            icon: Icons.menu_book_outlined,
            onTap: subjects.isEmpty
                ? () {}
                : () {
                    _selectSubject(context);
                  },
          ),
      ],
    );
  }

  Future<void> _selectSubject(BuildContext context) async {
    final selectedId = await showStudyTaskSubjectsBottomSheet(
      context: context,
      subjects: subjects,
      selectedSubjectId: selectedSubjectId,
    );

    if (selectedId == null || !context.mounted) {
      return;
    }

    onSubjectChanged(selectedId);
  }
}

class _SubjectsFailureBody extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _SubjectsFailureBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.40),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Theme.of(context).colorScheme.error,
          ),

          const SizedBox(height: 8),

          Text(message, textAlign: TextAlign.center),

          if (onRetry != null) ...[
            const SizedBox(height: 10),

            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ],
      ),
    );
  }
}
