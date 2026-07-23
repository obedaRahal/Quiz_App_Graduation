import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/utils/synchronize_study_alarms_after_task_mutation.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_body.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/update/update_study_task_submit_button.dart';

class UpdateStudyTaskView extends StatelessWidget {
  final int planId;
  final int taskId;

  const UpdateStudyTaskView({
    super.key,
    required this.planId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // =================================================
            // INITIAL DATA FAILURE
            // =================================================
            BlocListener<UpdateStudyTaskCubit, UpdateStudyTaskState>(
              listenWhen: (previous, current) {
                return previous.initialDataStatus != current.initialDataStatus;
              },
              listener: (context, state) {
                if (!state.isInitialDataFailure) {
                  return;
                }

                debugPrint(
                  '============ '
                  'UpdateStudyTaskView initial data failure '
                  '============',
                );
                debugPrint('→ planId: ${state.planId}');
                debugPrint('→ taskId: ${state.taskId}');
                debugPrint(
                  '→ initial status: '
                  '${state.initialDataStatus}',
                );
                debugPrint('→ error title: ${state.errorTitle}');
                debugPrint('→ error message: ${state.errorMessage}');
                debugPrint(
                  '================================================'
                  '===============',
                );

                showValidationTopSnackBar(
                  context,
                  title: state.errorTitle ?? 'خطأ',
                  message:
                      state.errorMessage ?? 'تعذر تحميل بيانات المهمة الدراسية',
                  type: AppValidationSnackBarType.error,
                );
              },
            ),

            // =================================================
            // SUBMIT RESULT
            // =================================================
            BlocListener<UpdateStudyTaskCubit, UpdateStudyTaskState>(
              listenWhen: (previous, current) {
                return previous.submitStatus != current.submitStatus;
              },
              listener: (context, state) async {
                if (state.isSubmitSuccess) {
                  debugPrint(
                    '============ '
                    'UpdateStudyTaskView submit success '
                    '============',
                  );
                  debugPrint('→ planId: ${state.planId}');
                  debugPrint('→ taskId: ${state.taskId}');
                  debugPrint('→ message: ${state.actionMessage}');
                  debugPrint(
                    '================================================'
                    '===========',
                  );

                  showValidationTopSnackBar(
                    context,
                    title: 'تم بنجاح',
                    message:
                        state.actionMessage ?? 'تم تعديل المهمة الدراسية بنجاح',
                    type: AppValidationSnackBarType.success,
                  );

                  await synchronizeStudyAlarmsAfterTaskMutation(context);

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.of(context).pop(true);

                  return;
                }

                if (state.isSubmitFailure) {
                  debugPrint(
                    '============ '
                    'UpdateStudyTaskView submit failure '
                    '============',
                  );
                  debugPrint('→ planId: ${state.planId}');
                  debugPrint('→ taskId: ${state.taskId}');
                  debugPrint('→ error title: ${state.errorTitle}');
                  debugPrint(
                    '→ error message: '
                    '${state.errorMessage}',
                  );
                  debugPrint(
                    '================================================'
                    '===========',
                  );

                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? 'خطأ',
                    message: state.errorMessage ?? 'تعذر تعديل المهمة الدراسية',
                    type: AppValidationSnackBarType.error,
                  );

                  context.read<UpdateStudyTaskCubit>().resetSubmitStatus();
                }
              },
            ),

            // =================================================
            // LOCAL VALIDATION ERRORS
            // =================================================
            BlocListener<UpdateStudyTaskCubit, UpdateStudyTaskState>(
              listenWhen: (previous, current) {
                final hasNewError =
                    current.errorMessage != null &&
                    current.errorMessage!.trim().isNotEmpty &&
                    previous.errorMessage != current.errorMessage;

                final isLocalValidationError =
                    current.isSubmitInitial && current.isInitialDataSuccess;

                return hasNewError && isLocalValidationError;
              },
              listener: (context, state) {
                final errorMessage = state.errorMessage;

                if (errorMessage == null || errorMessage.trim().isEmpty) {
                  return;
                }

                debugPrint(
                  '============ '
                  'UpdateStudyTaskView validation failure '
                  '============',
                );
                debugPrint('→ planId: ${state.planId}');
                debugPrint('→ taskId: ${state.taskId}');
                debugPrint('→ error title: ${state.errorTitle}');
                debugPrint('→ error message: $errorMessage');
                debugPrint(
                  '================================================'
                  '===============',
                );

                showValidationTopSnackBar(
                  context,
                  title: state.errorTitle ?? 'تنبيه',
                  message: errorMessage,
                  type: AppValidationSnackBarType.error,
                );

                context.read<UpdateStudyTaskCubit>().clearError();
              },
            ),
          ],
          child: const Column(
            children: [
              Expanded(child: UpdateStudyTaskBody()),
              UpdateStudyTaskSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
