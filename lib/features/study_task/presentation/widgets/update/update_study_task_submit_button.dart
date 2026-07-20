import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';

class UpdateStudyTaskSubmitButton extends StatelessWidget {
  const UpdateStudyTaskSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.canSubmit != current.canSubmit ||
            previous.submitStatus != current.submitStatus ||
            previous.initialDataStatus != current.initialDataStatus ||
            previous.isFormInitialized != current.isFormInitialized;
      },
      builder: (context, state) {
        /*
         * لا نظهر زر الحفظ أثناء تحميل البيانات
         * أو عند فشل التهيئة.
         */
        if (!state.isInitialDataSuccess || !state.isFormInitialized) {
          return const SizedBox.shrink();
        }

        final isLoading = state.isSubmitLoading;

        final isEnabled = state.canSubmit && !isLoading;

        return SafeArea(
          top: false,
          minimum: EdgeInsets.only(
            left: SizeConfig.w(0.035),
            right: SizeConfig.w(0.035),
            bottom: SizeConfig.h(0.012),
          ),
          child: CustomButtonWidget(
            width: double.infinity,
            backgroundColor: isEnabled
                ? AppPalette.primary
                : AppPalette.greyMedium,
            borderRadius: 6,
            childHorizontalPad: SizeConfig.w(0.04),
            childVerticalPad: SizeConfig.w(0.013),
            onTap: isEnabled
                ? () {
                    debugPrint(
                      '============ '
                      'Update Study Task Submit '
                      '============',
                    );
                    debugPrint(
                      '→ canSubmit: '
                      '${state.canSubmit}',
                    );
                    debugPrint(
                      '→ hasChanges: '
                      '${state.hasChanges}',
                    );
                    debugPrint(
                      '→ isFormValid: '
                      '${state.isFormValid}',
                    );

                    context.read<UpdateStudyTaskCubit>().updateStudyTask();
                  }
                : () {
                    debugPrint(
                      '============ '
                      'Update Study Task Submit Disabled '
                      '============',
                    );
                    debugPrint(
                      '→ canSubmit: '
                      '${state.canSubmit}',
                    );
                    debugPrint(
                      '→ hasChanges: '
                      '${state.hasChanges}',
                    );
                    debugPrint(
                      '→ isFormValid: '
                      '${state.isFormValid}',
                    );
                    debugPrint('→ isLoading: $isLoading');
                  },
            child: isLoading
                ? SizedBox(
                    width: SizeConfig.w(0.045),
                    height: SizeConfig.w(0.045),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppPalette.white,
                    ),
                  )
                : CustomTextWidget(
                    state.hasChanges ? 'حفظ التعديلات' : 'لا توجد تعديلات',
                    color: isEnabled
                        ? AppPalette.white
                        : AppPalette.greyBorderCart,
                    fontSize: SizeConfig.text(0.03),
                    fontWeight: FontWeight.w700,
                  ),
          ),
        );
      },
    );
  }
}
