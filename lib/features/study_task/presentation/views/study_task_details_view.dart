import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_task/data/models/create_study_task_args.dart';
import 'package:quiz_app_grad/features/study_task/data/models/update_study_task_args.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/views/update_study_task_view.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_bottom_actions.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/details/study_task_details_body.dart';

class StudyTaskDetailsView extends StatelessWidget {
  final int planId;
  final int taskId;

  const StudyTaskDetailsView({
    super.key,
    required this.planId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<StudyTaskDetailsCubit, StudyTaskDetailsState>(
          listenWhen: (previous, current) {
            return previous.deleteStatus != current.deleteStatus ||
                previous.changeStatus != current.changeStatus ||
                previous.toggleSubTaskStatus != current.toggleSubTaskStatus;
          },
          listener: _handleStateListener,
          child: Column(
            children: [
              Expanded(
                child: StudyTaskDetailsBody(planId: planId, taskId: taskId),
              ),
              BlocBuilder<StudyTaskDetailsCubit, StudyTaskDetailsState>(
                buildWhen: (previous, current) {
                  return previous.taskDetails != current.taskDetails ||
                      previous.changeStatus != current.changeStatus ||
                      previous.deleteStatus != current.deleteStatus;
                },
                builder: (context, state) {
                  final taskDetails = state.taskDetails;

                  if (!state.isLoadSuccess || taskDetails == null) {
                    return const SizedBox.shrink();
                  }

                  return StudyTaskBottomActions(
                    onEditTap: () async {
                      debugPrint('on edit task tap');

                      final isUpdated = await context.pushNamed<bool>(
                        AppRouterName.updateStudyTask,
                        extra: UpdateStudyTaskArgs(
                          planId: planId,
                          taskId: taskId,
                        ),
                      );

                      if (!context.mounted) {
                        return;
                      }

                      if (isUpdated == true) {
                        context
                            .read<StudyTaskDetailsCubit>()
                            .getStudyTaskDetails(
                              planId: planId,
                              taskId: taskId,
                            );
                      }
                    },
                    onDeleteTap: () {
                      _showDeleteConfirmation(
                        context,
                        taskId: taskDetails.data.basicInfo.id,
                        taskTitle: taskDetails.data.basicInfo.title,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStateListener(BuildContext context, StudyTaskDetailsState state) {
    if (state.isChangeStatusSuccess) {
      debugPrint(
        '============ StudyTaskDetailsView status success ============',
      );
      debugPrint('→ message: ${state.actionMessage}');

      showValidationTopSnackBar(
        context,
        title: 'تم بنجاح',
        message: state.actionMessage ?? 'تم تحديث حالة المهمة بنجاح',
        type: AppValidationSnackBarType.success,
      );

      context.read<StudyTaskDetailsCubit>().resetChangeStatusState();

      return;
    }

    if (state.isChangeStatusFailure) {
      debugPrint(
        '============ StudyTaskDetailsView status failure ============',
      );
      debugPrint('→ title: ${state.errorTitle}');
      debugPrint('→ message: ${state.errorMessage}');

      showValidationTopSnackBar(
        context,
        title: state.errorTitle ?? 'تعذر تحديث المهمة',
        message: state.errorMessage ?? 'حدث خطأ أثناء تحديث حالة المهمة',
        type: AppValidationSnackBarType.error,
      );

      context.read<StudyTaskDetailsCubit>().resetChangeStatusState();

      return;
    }

    if (state.isToggleSubTaskSuccess) {
      debugPrint(
        '============ StudyTaskDetailsView subtask success ============',
      );
      debugPrint('→ message: ${state.actionMessage}');

      context.read<StudyTaskDetailsCubit>().resetToggleSubTaskState();

      return;
    }

    if (state.isToggleSubTaskFailure) {
      debugPrint(
        '============ StudyTaskDetailsView subtask failure ============',
      );
      debugPrint('→ title: ${state.errorTitle}');
      debugPrint('→ message: ${state.errorMessage}');

      showValidationTopSnackBar(
        context,
        title: state.errorTitle ?? 'تعذر تحديث المهمة الفرعية',
        message:
            state.errorMessage ?? 'حدث خطأ أثناء تحديث حالة المهمة الفرعية',
        type: AppValidationSnackBarType.error,
      );

      context.read<StudyTaskDetailsCubit>().resetToggleSubTaskState();

      return;
    }

    if (state.isDeleteSuccess) {
      debugPrint(
        '============ StudyTaskDetailsView delete success ============',
      );
      debugPrint('→ taskId: ${state.deletedTaskId}');
      debugPrint('→ message: ${state.actionMessage}');

      showValidationTopSnackBar(
        context,
        title: 'تم بنجاح',
        message: state.actionMessage ?? 'تم حذف المهمة بنجاح',
        type: AppValidationSnackBarType.success,
      );

      Navigator.of(context).pop(true);
      return;
    }

    if (state.isDeleteFailure) {
      debugPrint(
        '============ StudyTaskDetailsView delete failure ============',
      );
      debugPrint('→ title: ${state.errorTitle}');
      debugPrint('→ message: ${state.errorMessage}');

      showValidationTopSnackBar(
        context,
        title: state.errorTitle ?? 'تعذر حذف المهمة',
        message: state.errorMessage ?? 'حدث خطأ أثناء حذف المهمة',
        type: AppValidationSnackBarType.error,
      );

      context.read<StudyTaskDetailsCubit>().resetDeleteState();
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context, {
    required int taskId,
    required String taskTitle,
  }) async {
    debugPrint('============ Show Delete Study Task Confirmation ============');
    debugPrint('→ taskId: $taskId');
    debugPrint('→ taskTitle: $taskTitle');

    await showCustomConfirmationDialog(
      context: context,
      title: 'حذف المهمة',
      message:
          'هل أنت متأكد من حذف مهمة "$taskTitle"؟\n'
          'لن تتمكن من استعادة المهمة بعد حذفها.',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      icon: Icons.delete,
      onConfirm: () {
        context.read<StudyTaskDetailsCubit>().deleteTask();
      },
      iconColor: AppPalette.red,
      iconBackgroundColor: AppPalette.red.withValues(alpha: 0.1),
      confirmBackgroundColor: AppPalette.red,
    );
  }
}
