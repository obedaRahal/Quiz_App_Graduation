import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
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
        if (!state.isInitialDataSuccess || !state.isFormInitialized) {
          return const SizedBox.shrink();
        }

        final isLoading = state.isSubmitLoading;

        final isEnabled = state.canSubmit && !isLoading;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.035),
            vertical: SizeConfig.h(0.012),
          ),
          decoration: BoxDecoration(
            color: context.appColors.whiteToblack,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppPalette.greyMediumDark
                    : AppPalette.greyBorderCart,
                blurRadius: 4,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            minimum: EdgeInsets.zero,
            child: CustomButtonWidget(
              width: double.infinity,
              backgroundColor: isEnabled
                  ? context.appColors.primaryToPrimaryDark
                  : context.appColors.greyToGreyMediumDark,
              borderRadius: 6,
              childHorizontalPad: SizeConfig.w(0.04),
              childVerticalPad: SizeConfig.h(0.01),
              onTap: isEnabled
                  ? () {
                      debugPrint(
                        '============ UpdateStudyTaskSubmitButton.updateStudyTask ============',
                      );
                      debugPrint('→ canSubmit: ${state.canSubmit}');
                      debugPrint('→ hasChanges: ${state.hasChanges}');
                      debugPrint('→ isFormValid: ${state.isFormValid}');
                      debugPrint('→ isLoading: $isLoading');

                      context.read<UpdateStudyTaskCubit>().updateStudyTask();
                    }
                  : () {
                      debugPrint(
                        '============ UpdateStudyTaskSubmitButton.disabled ============',
                      );
                      debugPrint('→ canSubmit: ${state.canSubmit}');
                      debugPrint('→ hasChanges: ${state.hasChanges}');
                      debugPrint('→ isFormValid: ${state.isFormValid}');
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
                          : AppPalette.greyMedium,
                      fontSize: SizeConfig.text(0.03),
                      fontWeight: FontWeight.w700,
                    ),
            ),
          ),
        );
      },
    );
  }
}
