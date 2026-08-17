













import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_title_description_section.dart';

class UpdateStudyTaskTitleDescriptionSection extends StatelessWidget {
  const UpdateStudyTaskTitleDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.title != current.title ||
            previous.description != current.description;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        return StudyTaskTitleDescriptionSection(
          title: state.title,
          description: state.description,
          titleMaxLength: UpdateStudyTaskState.titleMaxLength,
          descriptionMaxLength: UpdateStudyTaskState.descriptionMaxLength,
          onTitleChanged: cubit.titleChanged,
          onDescriptionChanged: cubit.descriptionChanged,
          sectionDescription:
              'عدّل عنوان المهمة ووصفها بما يناسب محتواها الدراسي.',
        );
      },
    );
  }
}
