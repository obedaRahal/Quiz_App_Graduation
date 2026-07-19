import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_details_header.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_failure_body.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_general_card.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_subtasks_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_timing_section.dart';

class StudyTaskDetailsBody extends StatelessWidget {
  final int planId;
  final int taskId;

  const StudyTaskDetailsBody({
    super.key,
    required this.planId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StudyTaskDetailsHeader(
          onBackTap: () {
            Navigator.of(context).pop();
          },
        ),
        Expanded(
          child: BlocBuilder<StudyTaskDetailsCubit, StudyTaskDetailsState>(
            buildWhen: (previous, current) {
              return previous.loadStatus != current.loadStatus ||
                  previous.taskDetails != current.taskDetails ||
                  previous.updatingSubTaskId != current.updatingSubTaskId;
            },
            builder: (context, state) {
              if (state.isInitial || state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.isLoadFailure) {
                return StudyTaskFailureBody(
                  title: state.errorTitle ?? 'حدث خطأ',
                  message: state.errorMessage ?? 'تعذر جلب تفاصيل المهمة',
                  onRetry: () {
                    debugPrint(
                      '============ Retry Study Task Details ============',
                    );
                    debugPrint('→ planId: $planId');
                    debugPrint('→ taskId: $taskId');

                    context.read<StudyTaskDetailsCubit>().getStudyTaskDetails(
                      planId: planId,
                      taskId: taskId,
                    );
                  },
                );
              }

              final taskDetails = state.taskDetails;

              if (!state.isLoadSuccess || taskDetails == null) {
                return const SizedBox.shrink();
              }

              final task = taskDetails.data;
              final basicInfo = task.basicInfo;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                child: Column(
                  children: [
                    StudyTaskGeneralDetailsCard(
                      taskDetails: task,
                      task: task,
                      onStatusToggle: () {
                        context
                            .read<StudyTaskDetailsCubit>()
                            .changeTaskStatus();
                      },
                    ),
                    SizedBox(height: SizeConfig.h(0.02)),
                    TaskTimingSession(timingInfo: task.timingInfo),
                    SizedBox(height: SizeConfig.h(0.025)),
                    StudyTaskSubtasksSection(
                      subtasks: task.subtasks,
                      count: basicInfo.subtasksCount,
                      //updatingSubTaskId: state.updatingSubTaskId,
                      onSubTaskTap: (subTaskId) {
                        context
                            .read<StudyTaskDetailsCubit>()
                            .toggleSubTaskStatus(subTaskId: subTaskId);
                      },
                    ),
                    SizedBox(height: SizeConfig.h(0.025)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
