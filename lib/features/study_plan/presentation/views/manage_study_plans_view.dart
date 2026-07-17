import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/manage/manage_study_plans_body.dart';

class ManageStudyPlansView extends StatelessWidget {
  const ManageStudyPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ManageStudyPlansCubit, ManageStudyPlansState>(
          listenWhen: (previous, current) {
            return previous.errorMessage != current.errorMessage &&
                current.errorMessage != null;
          },
          listener: (context, state) {
            /*
             * نظهر SnackBar فقط إذا كانت هناك
             * بيانات قديمة ما زالت معروضة وفشل Refresh.
             *
             * أما الفشل الأول فسيظهر داخل القائمة.
             */
            if (state.plans.isEmpty) {
              return;
            }

            showValidationTopSnackBar(
              context,
              title: state.errorTitle ?? 'خطأ',
              message: state.errorMessage ?? 'تعذر تحديث الخطط الدراسية',
              type: AppValidationSnackBarType.error,
            );

            context.read<ManageStudyPlansCubit>().resetError();
          },
          child: const ManageStudyPlansBody(),
        ),
      ),
    );
  }
}
