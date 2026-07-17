import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_home_body.dart';

class StudyPlanHomeView extends StatelessWidget {
  const StudyPlanHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudyPlanHomeCubit, StudyPlanHomeState>(
        listenWhen: (previous, current) {
          return previous.status != current.status ||
              previous.taskUpdateStatus != current.taskUpdateStatus;
        },
        listener: (context, state) {
          if (state.isFailure) {
            showValidationTopSnackBar(
              context,
              title: state.errorTitle ?? 'خطأ',
              message: state.errorMessage ?? 'تعذر جلب بيانات الخطة الدراسية',
              type: AppValidationSnackBarType.error,
            );
          }

          if (state.isTaskUpdateFailure) {
            showValidationTopSnackBar(
              context,
              title: state.errorTitle ?? 'خطأ',
              message: state.errorMessage ?? 'تعذر تحديث حالة المهمة',
              type: AppValidationSnackBarType.error,
            );

            context.read<StudyPlanHomeCubit>().resetTaskUpdateState();
          }

          if (state.isTaskUpdateSuccess) {
            showValidationTopSnackBar(
              context,
              title: 'تم بنجاح',
              message: 'تم تحديث حالة المهمة بنجاح',
              type: AppValidationSnackBarType.success,
            );

            context.read<StudyPlanHomeCubit>().resetTaskUpdateState();
          }
        },
        buildWhen: (previous, current) {
          return previous.status != current.status ||
              previous.overview != current.overview;
        },
        builder: (context, state) {
          if (state.isInitial || state.isLoading && state.overview == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isFailure && state.overview == null) {
            return StudyPlanHomeFailureView(
              message: state.errorMessage,
              onRetry: () {
                context.read<StudyPlanHomeCubit>().initialize(
                  weekStartsOn: 'السبت',
                );
              },
            );
          }

          return const StudyPlanHomeBody();
        },
      ),
    );
  }
}

class StudyPlanHomeFailureView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const StudyPlanHomeFailureView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 54,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'تعذر جلب بيانات الخطة الدراسية',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
