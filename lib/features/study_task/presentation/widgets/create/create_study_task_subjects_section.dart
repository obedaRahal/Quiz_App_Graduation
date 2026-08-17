

















































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_subjects_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subjects/study_task_subject_option.dart';

class CreateStudyTaskSubjectsSection extends StatelessWidget {
  const CreateStudyTaskSubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.availableSubjects != current.availableSubjects ||
            previous.selectedStudyPlanSubjectId !=
                current.selectedStudyPlanSubjectId ||
            previous.subjectsStatus != current.subjectsStatus;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        final subjectOptions = state.availableSubjects.map((subject) {
          return StudyTaskSubjectOption(id: subject.id, name: subject.name);
        }).toList();

        return StudyTaskSubjectsSection(
          subjects: subjectOptions,
          selectedSubjectId: state.selectedStudyPlanSubjectId,
          isLoading: state.isSubjectsLoading,
          errorMessage: state.isSubjectsFailure ? state.errorMessage : null,
          onSubjectChanged: (subjectId) {
            cubit.changeSelectedSubject(subjectId);
          },
        );
      },
    );
  }
}
