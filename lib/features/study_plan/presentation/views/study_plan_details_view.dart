import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/delete_study_plan_bottom_action.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/details/study_plan_details_body.dart';
import 'package:quiz_app_grad/features/study_task/data/models/create_study_task_args.dart';

class StudyPlanDetailsView extends StatelessWidget {
  final StudyPlanSummaryEntity plan;

  const StudyPlanDetailsView({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<StudyPlanDetailsCubit, StudyPlanDetailsState>(
          listenWhen: (previous, current) {
            return previous.deleteStatus != current.deleteStatus ||
                previous.taskUpdateStatus != current.taskUpdateStatus;
          },
          listener: (context, state) {
            if (state.isTaskUpdateSuccess) {
              showValidationTopSnackBar(
                context,
                title: 'تم بنجاح',
                message:
                    state.taskUpdateMessage ?? 'تم تحديث حالة المهمة بنجاح',
                type: AppValidationSnackBarType.success,
              );

              context.read<StudyPlanDetailsCubit>().resetTaskUpdateState();
              return;
            }

            if (state.isTaskUpdateFailure) {
              showValidationTopSnackBar(
                context,
                title: state.taskUpdateErrorTitle ?? 'تعذر تحديث المهمة',
                message:
                    state.taskUpdateErrorMessage ??
                    'حدث خطأ أثناء تحديث حالة المهمة',
                type: AppValidationSnackBarType.error,
              );

              context.read<StudyPlanDetailsCubit>().resetTaskUpdateState();
              return;
            }

            if (state.isDeleteSuccess) {
              debugPrint(
                '============ StudyPlanDetailsView delete success ============',
              );
              debugPrint('→ planId: ${plan.id}');
              debugPrint('→ title: ${state.deleteSuccessTitle}');
              debugPrint('→ message: ${state.deleteSuccessMessage}');

              showValidationTopSnackBar(
                context,
                title: state.deleteSuccessTitle ?? 'تم بنجاح',
                message:
                    state.deleteSuccessMessage ?? 'تم حذف الخطة الدراسية بنجاح',
                type: AppValidationSnackBarType.success,
              );

              Navigator.of(context).pop(true);
              return;
            }

            if (state.isDeleteFailure) {
              debugPrint(
                '============ StudyPlanDetailsView delete failure ============',
              );
              debugPrint('→ planId: ${plan.id}');
              debugPrint('→ title: ${state.deleteErrorTitle}');
              debugPrint('→ message: ${state.deleteErrorMessage}');

              showValidationTopSnackBar(
                context,
                title: state.deleteErrorTitle ?? 'تعذر حذف الخطة',
                message:
                    state.deleteErrorMessage ??
                    'حدث خطأ أثناء حذف الخطة الدراسية',
                type: AppValidationSnackBarType.error,
              );

              context.read<StudyPlanDetailsCubit>().resetDeleteState();
            }
          },
          child: Column(
            children: [
              Expanded(child: StudyPlanDetailsBody(plan: plan)),

              DeleteStudyPlanBottomAction(
                onDeleteTap: () {
                  _showDeleteConfirmation(
                    context,
                    planId: plan.id,
                    planTitle: plan.title,
                  );
                },
                onCreateTask: () async {
                  final wasCreated = await context.pushNamed<bool>(
                    AppRouterName.createStudyTask,
                    extra: CreateStudyTaskArgs(planId: plan.id),
                  );

                  if (!context.mounted || wasCreated != true) {
                    return;
                  }

                  await context
                      .read<StudyPlanDetailsCubit>()
                      .refreshAfterTaskCreation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context, {
    required int planId,
    required String planTitle,
  }) async {
    debugPrint('============ Show Delete Study Plan Confirmation ============');
    debugPrint('→ planId: $planId');
    debugPrint('→ planTitle: $planTitle');

    await showCustomConfirmationDialog(
      context: context,
      title: 'حذف الخطة الدراسية',
      message:
          'هل أنت متأكد من حذف خطة "$planTitle"؟\n'
          'لن تتمكن من استعادة الخطة بعد حذفها.',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      icon: Icons.delete,
      onConfirm: () {
        // debugPrint('→ confirmed: $confirmed');

        // if (confirmed != true || !context.mounted) {
        //   debugPrint('→ delete cancelled');
        //   return;
        // }

        context.read<StudyPlanDetailsCubit>().deleteStudyPlan(planId: planId);
      },
      //confirmTextColor: AppPalette.red,
      iconColor: AppPalette.red,
      iconBackgroundColor: AppPalette.red.withValues(alpha: 0.1),
      confirmBackgroundColor: AppPalette.red,
    );
  }
}
