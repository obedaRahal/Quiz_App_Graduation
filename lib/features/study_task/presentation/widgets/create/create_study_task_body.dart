import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_date_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_form_sections.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_options_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_repeat_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_subjects_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_subtasks_section.dart';

class CreateStudyTaskBody extends StatelessWidget {
  const CreateStudyTaskBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.subjectsStatus != current.subjectsStatus ||
            previous.availableSubjects != current.availableSubjects;
      },
      builder: (context, state) {
        if (state.isSubjectsLoading) {
          return const _CreateStudyTaskLoadingBody();
        }

        if (state.isSubjectsFailure && state.availableSubjects.isEmpty) {
          return _CreateStudyTaskFailureBody(
            message: state.errorMessage ?? 'تعذر جلب مواد الخطة الدراسية',
            onRetry: () {
              context.read<CreateStudyTaskCubit>().retryGetStudyPlanSubjects();
            },
          );
        }

        return const _CreateStudyTaskContent();
      },
    );
  }
}

class _CreateStudyTaskContent extends StatelessWidget {
  const _CreateStudyTaskContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        SizeConfig.w(0.03),
        SizeConfig.h(0.015),
        SizeConfig.w(0.03),
        SizeConfig.h(0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudyPlanHomeHeader(
            title: 'إنشاء مهمة دراسية',
            actionIcon: Icons.close_rounded,
            onActionTap: () {
              Navigator.of(context).pop();
            },
          ),

          SizedBox(height: SizeConfig.h(0.015)),

          const CreateStudyTaskTitleDescriptionSection(),

          const CustomDivider(height: 35, thickness: 3),

          const CreateStudyTaskDateSection(),

          const CustomDivider(height: 35, thickness: 3),

          const CreateStudyTaskOptionsSection(),

          const CustomDivider(height: 35, thickness: 3),

          const CreateStudyTaskRepeatSection(),

          const CustomDivider(height: 35, thickness: 3),

          const CreateStudyTaskSubtasksSection(),
          
          const CustomDivider(height: 35, thickness: 3),

          const CreateStudyTaskSubjectsSection(),

          SizedBox(height: SizeConfig.h(0.025)),
        ],
      ),
    );
  }
}

class _CreateStudyTaskLoadingBody extends StatelessWidget {
  const _CreateStudyTaskLoadingBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(0.03),
            SizeConfig.h(0.015),
            SizeConfig.w(0.03),
            0,
          ),
          child: StudyPlanHomeHeader(
            title: 'إنشاء مهمة دراسية',
            actionIcon: Icons.close_rounded,
            onActionTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}

class _CreateStudyTaskFailureBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CreateStudyTaskFailureBody({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(0.03),
            SizeConfig.h(0.015),
            SizeConfig.w(0.03),
            0,
          ),
          child: StudyPlanHomeHeader(
            title: 'إنشاء مهمة دراسية',
            actionIcon: Icons.close_rounded,
            onActionTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.08)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off_outlined,
                    size: SizeConfig.text(0.16),
                    color: colorScheme.error,
                  ),
                  SizedBox(height: SizeConfig.h(0.018)),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: SizeConfig.h(0.020)),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
