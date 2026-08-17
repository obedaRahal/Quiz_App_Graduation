































































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_repeat_section.dart';

class CreateStudyTaskRepeatSection extends StatelessWidget {
  const CreateStudyTaskRepeatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.repeatPattern != current.repeatPattern ||
            previous.repeatWeekday != current.repeatWeekday;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        return StudyTaskRepeatSection(
          repeatPattern: state.repeatPattern,
          repeatWeekday: state.repeatWeekday,
          sectionDescription:
              'حدد نمط التكرار واليوم الذي تريد تكرار المهمة فيه.',
          onRepeatChanged: (pattern, weekday) {
            cubit.changeRepeatPattern(pattern);

            if (pattern != StudyTaskRepeatPattern.none && weekday != null) {
              cubit.changeRepeatWeekday(weekday);
            }
          },
        );
      },
    );
  }
}
