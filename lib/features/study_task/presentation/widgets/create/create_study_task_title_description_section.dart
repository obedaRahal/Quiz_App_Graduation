



























import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_title_description_section.dart';

class CreateStudyTaskTitleDescriptionSection extends StatelessWidget {
  const CreateStudyTaskTitleDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.title != current.title ||
            previous.description != current.description;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        return StudyTaskTitleDescriptionSection(
          title: state.title,
          description: state.description,
          titleMaxLength: CreateStudyTaskState.titleMaxLength,
          descriptionMaxLength: CreateStudyTaskState.descriptionMaxLength,
          onTitleChanged: cubit.changeTitle,
          onDescriptionChanged: cubit.changeDescription,
          sectionDescription:
              'أضف عنواناً واضحاً ووصفاً مختصراً يشرح المهمة الدراسية.',
        );
      },
    );
  }
}
