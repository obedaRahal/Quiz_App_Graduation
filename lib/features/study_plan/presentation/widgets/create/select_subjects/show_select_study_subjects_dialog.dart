import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/select_subjects/select_study_subjects_dialog.dart';

Future<Set<int>?> showSelectStudySubjectsDialog(
  BuildContext context, {
  required List<StudySubjectEntity> subjects,
  required Set<int> initiallySelectedIds,
  int maxSelection = 10,
}) async {
  debugPrint(
    '============ showSelectStudySubjectsDialog ============',
  );
  debugPrint(
    '→ available subjects count: ${subjects.length}',
  );
  debugPrint(
    '→ initially selected ids: $initiallySelectedIds',
  );
  debugPrint(
    '→ maxSelection: $maxSelection',
  );

  final result = await showDialog<Set<int>>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return SelectStudySubjectsDialog(
        subjects: subjects,
        initiallySelectedIds:
            initiallySelectedIds,
        maxSelection: maxSelection,
      );
    },
  );

  debugPrint(
    '→ dialog result: $result',
  );
  debugPrint(
    '=======================================================',
  );

  return result;
}