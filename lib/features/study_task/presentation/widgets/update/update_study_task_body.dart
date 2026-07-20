import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_header.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_date_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_options_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_repeat_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_subjects_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_subtasks_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_title_description_section.dart';

class UpdateStudyTaskBody extends StatelessWidget {
  const UpdateStudyTaskBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.initialDataStatus != current.initialDataStatus ||
            previous.isFormInitialized != current.isFormInitialized;
      },
      builder: (context, state) {
        if (state.isInitialDataLoading) {
          return const _UpdateStudyTaskLoadingBody();
        }

        if (state.isInitialDataFailure) {
          return _UpdateStudyTaskFailureBody(
            message: state.errorMessage ?? 'تعذر تحميل بيانات المهمة الدراسية',
            onRetry: () {
              context.read<UpdateStudyTaskCubit>().retryInitialize();
            },
          );
        }

        if (!state.isFormInitialized) {
          return const _UpdateStudyTaskLoadingBody();
        }

        return const _UpdateStudyTaskContent();
      },
    );
  }
}

class _UpdateStudyTaskContent extends StatelessWidget {
  const _UpdateStudyTaskContent();

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
            title: 'تعديل المهمة الدراسية',
            actionIcon: Icons.close_rounded,
            onActionTap: () {
              Navigator.of(context).pop();
            },
          ),

          SizedBox(height: SizeConfig.h(0.015)),

          const UpdateStudyTaskTitleDescriptionSection(),

          const CustomDivider(height: 35, thickness: 3),

          const UpdateStudyTaskDateSection(),

          const CustomDivider(height: 35, thickness: 3),

          const UpdateStudyTaskOptionsSection(),

          const CustomDivider(height: 35, thickness: 3),

          const UpdateStudyTaskRepeatSection(),

          const CustomDivider(height: 35, thickness: 3),

          const UpdateStudyTaskSubtasksSection(),

          const CustomDivider(height: 35, thickness: 3),

          const UpdateStudyTaskSubjectsSection(),

          SizedBox(height: SizeConfig.h(0.025)),
        ],
      ),
    );
  }
}

class _UpdateStudyTaskLoadingBody extends StatelessWidget {
  const _UpdateStudyTaskLoadingBody();

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
            title: 'تعديل المهمة الدراسية',
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

class _UpdateStudyTaskFailureBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _UpdateStudyTaskFailureBody({
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
            title: 'تعديل المهمة الدراسية',
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
