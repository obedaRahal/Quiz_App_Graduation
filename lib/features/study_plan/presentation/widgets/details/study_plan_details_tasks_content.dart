import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_tasks_search_field.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/tudy_plan_tasks_group_section.dart';
import 'package:quiz_app_grad/features/study_task/data/models/study_task_details_args.dart';

class StudyPlanDetailsTasksContent extends StatelessWidget {
  const StudyPlanDetailsTasksContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudyPlanDetailsCubit, StudyPlanDetailsState>(
      buildWhen: (previous, current) {
        return previous.tasksStatus != current.tasksStatus ||
            previous.tasks != current.tasks ||
            previous.tasksSearchQuery != current.tasksSearchQuery ||
            previous.isOldExpanded != current.isOldExpanded ||
            previous.isUpcomingExpanded != current.isUpcomingExpanded ||
            previous.isCompletedExpanded != current.isCompletedExpanded;
      },
      builder: (context, state) {
        final planId = context.read<StudyPlanDetailsCubit>().planId;

        if (state.isTasksLoading && !state.hasTasksData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.08)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.isTasksFailure && !state.hasTasksData) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.06)),
            child: Column(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppPalette.red),
                SizedBox(height: SizeConfig.h(0.012)),
                CustomTextWidget(
                  state.errorMessage ?? 'تعذر جلب مهام الخطة',
                  textAlign: TextAlign.center,
                  color: AppPalette.red,
                ),
                TextButton(
                  onPressed: () {
                    context.read<StudyPlanDetailsCubit>().getTasks(
                      forceRefresh: true,
                    );
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final tasks = state.tasks;

        if (tasks == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudyPlanTasksSearchField(
              value: state.tasksSearchQuery,
              onChanged: context.read<StudyPlanDetailsCubit>().searchTasks,
              onClear: context.read<StudyPlanDetailsCubit>().clearTasksSearch,
            ),

            SizedBox(height: SizeConfig.h(0.02)),

            if (state.tasksSearchQuery.trim().isNotEmpty &&
                !state.hasSearchResults)
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
                child: CustomTextWidget(
                  'لا توجد مهام مطابقة للبحث',
                  color: AppPalette.greyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            else ...[
              // StudyPlanTasksGroupSection(
              //   title: 'مهام قديمة',
              //   count: tasks.old.count,
              //   tasks: state.filteredOldTasks,
              //   isExpanded: state.isOldExpanded,
              //   onToggle: context.read<StudyPlanDetailsCubit>().toggleOldTasks,
              // ),

              // SizedBox(height: SizeConfig.h(0.016)),

              // CustomDivider(height: 1, thickness: 1),

              // SizedBox(height: SizeConfig.h(0.016)),

              // StudyPlanTasksGroupSection(
              //   title: 'مهام قادمة',
              //   count: tasks.upcoming.count,
              //   tasks: state.filteredUpcomingTasks,
              //   isExpanded: state.isUpcomingExpanded,
              //   onToggle: context
              //       .read<StudyPlanDetailsCubit>()
              //       .toggleUpcomingTasks,
              // ),

              // SizedBox(height: SizeConfig.h(0.016)),

              // CustomDivider(height: 1, thickness: 1),

              // SizedBox(height: SizeConfig.h(0.016)),

              // StudyPlanTasksGroupSection(
              //   title: 'مهام مكتملة',
              //   count: tasks.completed.count,
              //   tasks: state.filteredCompletedTasks,
              //   isExpanded: state.isCompletedExpanded,
              //   onToggle: context
              //       .read<StudyPlanDetailsCubit>()
              //       .toggleCompletedTasks,
              // ),
              StudyPlanTasksGroupSection(
                title: 'مهام قديمة',
                count: tasks.old.count,
                tasks: state.filteredOldTasks,
                isExpanded: state.isOldExpanded,
                onToggle: context.read<StudyPlanDetailsCubit>().toggleOldTasks,
                isTaskUpdating: (taskId) {
                  return false;
                  //state.isUpdatingTask(taskId);
                },
                onTaskTap: (task) async {
                  await _openTaskDetails(
                    context,
                    planId: planId!,
                    taskId: task.id,
                  );
                },
                onTaskStatusToggle: (task) {
                  // context.read<StudyPlanDetailsCubit>().toggleTaskStatus(
                  //   taskId: task.id,
                  // );
                },
              ),

              SizedBox(height: SizeConfig.h(0.016)),

              CustomDivider(height: 1, thickness: 1),

              SizedBox(height: SizeConfig.h(0.016)),

              StudyPlanTasksGroupSection(
                title: 'مهام قادمة',
                count: tasks.upcoming.count,
                tasks: state.filteredUpcomingTasks,
                isExpanded: state.isUpcomingExpanded,
                onToggle: context
                    .read<StudyPlanDetailsCubit>()
                    .toggleUpcomingTasks,
                isTaskUpdating: (taskId) {
                  return false;
                  // state.isUpdatingTask(taskId);
                },
                onTaskTap: (task) async {
                  await _openTaskDetails(
                    context,
                    planId: planId!,
                    taskId: task.id,
                  );
                },
                onTaskStatusToggle: (task) {
                  // context.read<StudyPlanDetailsCubit>().toggleTaskStatus(
                  //   taskId: task.id,
                  // );
                },
              ),

              SizedBox(height: SizeConfig.h(0.016)),

              CustomDivider(height: 1, thickness: 1),

              SizedBox(height: SizeConfig.h(0.016)),

              StudyPlanTasksGroupSection(
                title: 'مهام مكتملة',
                count: tasks.completed.count,
                tasks: state.filteredCompletedTasks,
                isExpanded: state.isCompletedExpanded,
                onToggle: context
                    .read<StudyPlanDetailsCubit>()
                    .toggleCompletedTasks,
                isTaskUpdating: (taskId) {
                  return false;
                  //state.isUpdatingTask(taskId);
                },
                onTaskTap: (task) async {
                  await _openTaskDetails(
                    context,
                    planId: planId!,
                    taskId: task.id,
                  );
                },
                onTaskStatusToggle: (task) {
                  // context.read<StudyPlanDetailsCubit>().toggleTaskStatus(
                  //   taskId: task.id,
                  // );
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _openTaskDetails(
    BuildContext context, {
    required int planId,
    required int taskId,
  }) async {
    debugPrint(
      '============ Open Study Task Details From Plan Details ============',
    );
    debugPrint('→ planId: $planId');
    debugPrint('→ taskId: $taskId');
    debugPrint(
      '===================================================================',
    );

    final didChange = await context.pushNamed<bool>(
      AppRouterName.studyTaskDetails,
      extra: StudyTaskDetailsArgs(planId: planId, taskId: taskId),
    );

    if (didChange == true && context.mounted) {
      debugPrint('✓ task changed, refreshing plan tasks');

      await context.read<StudyPlanDetailsCubit>().getTasks(forceRefresh: true);
    }
  }
}
