import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/subjects/study_subjects_bottom_sheet.dart';

Future<void> showStudySubjectsBottomSheet(
  BuildContext context,
) async {
  debugPrint(
    '============ showStudySubjectsBottomSheet ============',
  );

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return BlocProvider<StudySubjectsCubit>(
        create: (_) => sl<StudySubjectsCubit>()
          ..getSubjects(),
        child:
            const StudySubjectsBottomSheet(),
      );
    },
  );

  debugPrint(
    '============ StudySubjectsBottomSheet closed ============',
  );
}