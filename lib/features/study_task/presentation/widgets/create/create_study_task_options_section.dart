
























































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/study_task_options_section.dart';

class CreateStudyTaskOptionsSection extends StatelessWidget {
  const CreateStudyTaskOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.startTime != current.startTime ||
            previous.durationMinutes != current.durationMinutes ||
            previous.priority != current.priority ||
            previous.reminderOffsetMinutes != current.reminderOffsetMinutes;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        return StudyTaskOptionsSection(
          startTime: state.startTime,
          durationMinutes: state.durationMinutes,
          priority: state.priority,
          reminderOffsetMinutes: state.reminderOffsetMinutes,
          onStartTimeChanged: cubit.changeStartTime,
          onDurationChanged: cubit.changeDurationMinutes,
          onPriorityChanged: cubit.changePriority,
          onReminderChanged: cubit.changeReminderOffsetMinutes,
        );
      },
    );
  }
}
