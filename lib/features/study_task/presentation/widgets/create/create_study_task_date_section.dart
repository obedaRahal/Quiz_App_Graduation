





































import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_date_section.dart';

class CreateStudyTaskDateSection extends StatelessWidget {
  const CreateStudyTaskDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.startDate != current.startDate ||
            previous.endDate != current.endDate;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        final today = _normalizeDate(DateTime.now());

        final lastSelectableDate = DateTime(today.year + 10, 12, 31);

        return StudyTaskDateSection(
          startDate: state.startDate,
          endDate: state.endDate,
          firstSelectableStartDate: today,
          lastSelectableStartDate: lastSelectableDate,
          maxRangeDays: 7,
          sectionDescription:
              'حدد تاريخ بداية ونهاية المهمة، على ألا تتجاوز مدتها 7 أيام.',
          onStartDateChanged: (date) {
            if (date != null) {
              cubit.changeStartDate(date);
            }
          },
          onEndDateChanged: (date) {
            if (date != null) {
              cubit.changeEndDate(date);
            }
          },
        );
      },
    );
  }

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
