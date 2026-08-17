






































































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/study_task_options_section.dart';

class UpdateStudyTaskOptionsSection extends StatelessWidget {
  const UpdateStudyTaskOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.startTime != current.startTime ||
            previous.durationMinutes != current.durationMinutes ||
            previous.priority != current.priority ||
            previous.reminderOffsetMinutes != current.reminderOffsetMinutes;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        return StudyTaskOptionsSection(
          startTime: state.startTime,
          durationMinutes: state.durationMinutes,
          priority: state.priority,
          reminderOffsetMinutes: state.reminderOffsetMinutes,
          sectionDescription:
              'عدّل وقت البداية والمدة والأولوية وموعد التذكير.',
          onStartTimeChanged: cubit.startTimeChanged,
          onDurationChanged: cubit.durationChanged,
          onPriorityChanged: cubit.priorityChanged,
          onReminderChanged: cubit.reminderChanged,
        );
      },
    );
  }
}
