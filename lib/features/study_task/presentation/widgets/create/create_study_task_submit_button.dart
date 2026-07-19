import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';

class CreateStudyTaskSubmitButton extends StatelessWidget {
  const CreateStudyTaskSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        left: SizeConfig.w(0.035),
        right: SizeConfig.w(0.035),
        bottom: SizeConfig.h(0.012),
      ),
      child: BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
        buildWhen: (previous, current) {
          return previous.canSubmit != current.canSubmit ||
              previous.submitStatus != current.submitStatus;
        },
        builder: (context, state) {
          final isLoading = state.isSubmitLoading;

          final isEnabled = state.canSubmit && !isLoading;

          return CustomButtonWidget(
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
                      'Create Study Task Submit '
                      '============',
                    );
                    debugPrint('→ canSubmit: ${state.canSubmit}');

                    context.read<CreateStudyTaskCubit>().createStudyTask();
                  }
                : () {
                    debugPrint(
                      '============ '
                      'Create Study Task Submit Disabled '
                      '============',
                    );
                    debugPrint('→ canSubmit: ${state.canSubmit}');
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
                    'إنشاء المهمة',
                    color: isEnabled
                        ? AppPalette.white
                        : AppPalette.greyBorderCart,
                    fontSize: SizeConfig.text(0.03),
                    fontWeight: FontWeight.w700,
                  ),
          );
        },
      ),
    );
  }
}
