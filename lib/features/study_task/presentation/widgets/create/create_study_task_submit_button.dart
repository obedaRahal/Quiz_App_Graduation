import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';







class CreateStudyTaskSubmitButton extends StatelessWidget {
  const CreateStudyTaskSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
        buildWhen: (previous, current) {
          return previous.canSubmit != current.canSubmit ||
              previous.submitStatus != current.submitStatus;
        },
        builder: (context, state) {
          final appColors = context.appColors;

          final isLoading = state.isSubmitLoading;
          final isButtonEnabled = state.canSubmit && !isLoading;

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.035),
              vertical: SizeConfig.h(0.012),
            ),
            decoration: BoxDecoration(
              color: appColors.whiteToblack,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppPalette.greyMediumDark
                      : AppPalette.greyBorderCart,
                  blurRadius: 4,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: CustomButtonWidget(
              width: double.infinity,
              backgroundColor: isButtonEnabled
                  ? appColors.primaryToPrimaryDark
                  : appColors.greyToGreyMediumDark,
              childHorizontalPad: SizeConfig.w(0.04),
              childVerticalPad: SizeConfig.h(0.01),
              borderRadius: 6,
              onTap: isButtonEnabled
                  ? () {
                      debugPrint(
                        '============ CreateStudyTaskSubmitButton.createStudyTask ============',
                      );
                      debugPrint('→ canSubmit: ${state.canSubmit}');
                      debugPrint('→ isSubmitLoading: $isLoading');

                      context.read<CreateStudyTaskCubit>().createStudyTask();
                    }
                  : () {
                      debugPrint(
                        '============ CreateStudyTaskSubmitButton.disabled ============',
                      );
                      debugPrint('→ canSubmit: ${state.canSubmit}');
                      debugPrint('→ isSubmitLoading: $isLoading');
                      debugPrint(
                        '===============================================================',
                      );
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
                      'إنشاء المهمة',
                      fontSize: SizeConfig.text(0.03),
                      color: isButtonEnabled
                          ? AppPalette.white
                          : AppPalette.greyMedium,
                    ),
            ),
          );
        },
      ),
    );
  }
}
