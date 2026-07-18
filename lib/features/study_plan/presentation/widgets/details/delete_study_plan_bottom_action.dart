import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';

class DeleteStudyPlanBottomAction extends StatelessWidget {
  final VoidCallback onDeleteTap;

  const DeleteStudyPlanBottomAction({super.key, required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StudyPlanDetailsCubit, StudyPlanDetailsState>(
      buildWhen: (previous, current) {
        return previous.deleteStatus != current.deleteStatus;
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.035),
            vertical: SizeConfig.h(0.012),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppPalette.black : AppPalette.white,
            boxShadow: [
              BoxShadow(
                color: AppPalette.greyMedium.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: CustomButtonWidget(
            width: double.infinity,
            backgroundColor: AppPalette.red,
            borderRadius: 6,
            childHorizontalPad: SizeConfig.w(0.04),
            childVerticalPad: SizeConfig.w(0.013),
            onTap: state.isDeleteLoading ? () {} : onDeleteTap,
            child: state.isDeleteLoading
                ? SizedBox(
                    width: SizeConfig.w(0.045),
                    height: SizeConfig.w(0.045),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppPalette.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline_rounded,
                        color: AppPalette.white,
                      ),
                      SizedBox(width: SizeConfig.w(0.02)),
                      CustomTextWidget(
                        'حذف الخطة الدراسية',
                        color: AppPalette.white,
                        fontSize: SizeConfig.text(0.03),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
