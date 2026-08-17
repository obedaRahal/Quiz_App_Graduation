






































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_subtasks_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_subtask_item.dart';

class CreateStudyTaskSubtasksSection extends StatelessWidget {
  const CreateStudyTaskSubtasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.subtasks != current.subtasks;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        final items = state.subtasks.map((title) {
          return StudyTaskSubtaskItem(
            id: null,
            title: title,
            isCompleted: false,
          );
        }).toList();

        return StudyTaskSubtasksSection(
          subtasks: items,
          maxSubtasksCount: CreateStudyTaskState.maxSubtasksCount,
          maxSubtaskTitleLength: CreateStudyTaskState.subtaskTitleMaxLength,
          showCompletedCheckbox: false,
          onAddSubtask: cubit.addSubtask,
          onRemoveSubtask: cubit.removeSubtask,
          onSubtaskTitleChanged: (index, title) {
            cubit.changeSubtaskTitle(index: index, value: title);
          },
        );
      },
    );
  }
}
