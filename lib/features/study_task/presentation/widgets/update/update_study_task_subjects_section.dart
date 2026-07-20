import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_subjects_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subjects/study_task_subject_option.dart';

class UpdateStudyTaskSubjectsSection extends StatelessWidget {
  const UpdateStudyTaskSubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.availableSubjects != current.availableSubjects ||
            previous.selectedStudyPlanSubjectId !=
                current.selectedStudyPlanSubjectId ||
            previous.initialDataStatus != current.initialDataStatus;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        final subjectOptions = state.availableSubjects.map((subject) {
          return StudyTaskSubjectOption(id: subject.id, name: subject.name);
        }).toList();

        return StudyTaskSubjectsSection(
          subjects: subjectOptions,
          selectedSubjectId: state.selectedStudyPlanSubjectId,
          onSubjectChanged: cubit.subjectChanged,
          sectionDescription: 'عدّل المادة الدراسية المرتبطة بهذه المهمة.',
        );
      },
    );
  }
}
