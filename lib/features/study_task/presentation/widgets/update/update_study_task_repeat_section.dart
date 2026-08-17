


















import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_repeat_section.dart';

class UpdateStudyTaskRepeatSection extends StatelessWidget {
  const UpdateStudyTaskRepeatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.repeatPattern != current.repeatPattern ||
            previous.repeatWeekday != current.repeatWeekday;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        return StudyTaskRepeatSection(
          repeatPattern: state.repeatPattern,
          repeatWeekday: state.repeatWeekday,
          showMissingWeekdayWarning: true,
          sectionDescription: 'عدّل نمط التكرار وحدد يوم التكرار عند الحاجة.',
          onRepeatChanged: (pattern, weekday) {
            cubit.repeatPatternChanged(pattern);

            cubit.repeatWeekdayChanged(
              pattern == StudyTaskRepeatPattern.none ? null : weekday,
            );
          },
        );
      },
    );
  }
}
