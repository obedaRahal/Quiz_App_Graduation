import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';

Future<StudyTaskPriority?> showStudyTaskPriorityBottomSheet({
  required BuildContext context,
  required StudyTaskPriority? selectedPriority,
}) {
  return showModalBottomSheet<StudyTaskPriority>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        top: false,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 14),
              child: Text(
                'أولوية المهمة',
                textAlign: TextAlign.right,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            ...selectableStudyTaskPriorities.map((priority) {
              final isSelected = priority == selectedPriority;

              return ListTile(
                onTap: () {
                  Navigator.of(context).pop(priority);
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(priority.apiValue, textAlign: TextAlign.right),
              );
            }),
          ],
        ),
      );
    },
  );
}
