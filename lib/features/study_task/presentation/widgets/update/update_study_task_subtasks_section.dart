import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_subtasks_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_subtask_item.dart';

// class UpdateStudyTaskSubtasksSection extends StatelessWidget {
//   const UpdateStudyTaskSubtasksSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
//       buildWhen: (previous, current) {
//         return previous.subtasks != current.subtasks;
//       },
//       builder: (context, state) {
//         final cubit = context.read<UpdateStudyTaskCubit>();

//         final items = state.subtasks.map((subtask) {
//           return StudyTaskSubtaskItem(
//             id: subtask.id,
//             title: subtask.title,
//             isCompleted: subtask.isCompleted,
//           );
//         }).toList();

//         return StudyTaskSubtasksSection(
//           subtasks: items,
//           maxSubtasksCount: UpdateStudyTaskState.maxSubtasksCount,
//           maxSubtaskTitleLength: UpdateStudyTaskState.subtaskTitleMaxLength,
//           sectionDescription: 'عدّل المهام الفرعية أو أضف خطوات جديدة للمهمة.',
//           onAddSubtask: cubit.addSubtask,
//           onRemoveSubtask: cubit.removeSubtask,
//           onSubtaskTitleChanged: cubit.subtaskTitleChanged,
//           onSubtaskCompletedChanged: cubit.subtaskCompletedChanged,
//         );
//       },
//     );
//   }
// }

class UpdateStudyTaskSubtasksSection extends StatelessWidget {
  const UpdateStudyTaskSubtasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.subtasks != current.subtasks;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        final items = state.subtasks.map((subtask) {
          return StudyTaskSubtaskItem(
            id: subtask.id,
            title: subtask.title,
            isCompleted: subtask.isCompleted,
          );
        }).toList();

        return StudyTaskSubtasksSection(
          subtasks: items,
          maxSubtasksCount: UpdateStudyTaskState.maxSubtasksCount,
          maxSubtaskTitleLength: UpdateStudyTaskState.subtaskTitleMaxLength,
          showCompletedCheckbox: false,
          onAddSubtask: cubit.addSubtask,
          onRemoveSubtask: cubit.removeSubtask,
          onSubtaskTitleChanged: (index, title) {
            cubit.subtaskTitleChanged(index, title);
          },
          onSubtaskCompletedChanged: (index, isCompleted) {
            cubit.subtaskCompletedChanged(index, isCompleted);
          },
        );
      },
    );
  }
}
