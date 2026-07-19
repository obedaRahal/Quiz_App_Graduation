import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_body.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_submit_button.dart';

class CreateStudyTaskView extends StatelessWidget {
  final int planId;

  const CreateStudyTaskView({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // =================================================
            // SUBJECTS FAILURE
            // =================================================
            BlocListener<CreateStudyTaskCubit, CreateStudyTaskState>(
              listenWhen: (previous, current) {
                return previous.subjectsStatus != current.subjectsStatus;
              },
              listener: (context, state) {
                if (!state.isSubjectsFailure) {
                  return;
                }

                debugPrint(
                  '============ '
                  'CreateStudyTaskView subjects failure '
                  '============',
                );
                debugPrint('→ planId: ${state.planId}');
                debugPrint(
                  '→ subjects status: '
                  '${state.subjectsStatus}',
                );
                debugPrint('→ error title: ${state.errorTitle}');
                debugPrint('→ error message: ${state.errorMessage}');
                debugPrint(
                  '================================================'
                  '=============',
                );

                showValidationTopSnackBar(
                  context,
                  title: state.errorTitle ?? 'خطأ',
                  message: state.errorMessage ?? 'تعذر جلب مواد الخطة الدراسية',
                  type: AppValidationSnackBarType.error,
                );

                context.read<CreateStudyTaskCubit>().resetError();
              },
            ),

            // =================================================
            // SUBMIT RESULT
            // =================================================
            BlocListener<CreateStudyTaskCubit, CreateStudyTaskState>(
              listenWhen: (previous, current) {
                return previous.submitStatus != current.submitStatus;
              },
              listener: (context, state) {
                if (state.isSubmitSuccess) {
                  debugPrint(
                    '============ '
                    'CreateStudyTaskView submit success '
                    '============',
                  );
                  debugPrint('→ planId: ${state.planId}');
                  debugPrint('→ message: ${state.actionMessage}');
                  debugPrint(
                    '================================================'
                    '===========',
                  );

                  showValidationTopSnackBar(
                    context,
                    title: 'تم بنجاح',
                    message:
                        state.actionMessage ?? 'تم إنشاء المهمة الدراسية بنجاح',
                    type: AppValidationSnackBarType.success,
                  );

                  Navigator.of(context).pop(true);

                  return;
                }

                if (state.isSubmitFailure) {
                  debugPrint(
                    '============ '
                    'CreateStudyTaskView submit failure '
                    '============',
                  );
                  debugPrint('→ planId: ${state.planId}');
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
                    message: state.errorMessage ?? 'تعذر إنشاء المهمة الدراسية',
                    type: AppValidationSnackBarType.error,
                  );

                  context.read<CreateStudyTaskCubit>().resetSubmitState();
                }
              },
            ),

            // =================================================
            // LOCAL VALIDATION ERRORS
            // =================================================
            BlocListener<CreateStudyTaskCubit, CreateStudyTaskState>(
              listenWhen: (previous, current) {
                final hasNewError =
                    current.errorMessage != null &&
                    current.errorMessage!.trim().isNotEmpty &&
                    previous.errorMessage != current.errorMessage;

                final isLocalValidationError =
                    current.isSubmitInitial && !current.isSubjectsFailure;

                return hasNewError && isLocalValidationError;
              },
              listener: (context, state) {
                final errorMessage = state.errorMessage;

                if (errorMessage == null || errorMessage.trim().isEmpty) {
                  return;
                }

                debugPrint(
                  '============ '
                  'CreateStudyTaskView validation failure '
                  '============',
                );
                debugPrint('→ planId: ${state.planId}');
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

                context.read<CreateStudyTaskCubit>().resetError();
              },
            ),
          ],
          child: const Column(
            children: [
              Expanded(child: CreateStudyTaskBody()),
              CreateStudyTaskSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
