import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';

class DeleteStudyPlanBottomAction extends StatelessWidget {
  final VoidCallback onDeleteTap;
  final VoidCallback onCreateTask;

  const DeleteStudyPlanBottomAction({
    super.key,
    required this.onDeleteTap,
    required this.onCreateTask,
  });

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
            color: context.appColors.whiteToblack,
            boxShadow: [
              BoxShadow(
                color: AppPalette.greyMedium.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _BottomActionButton(
                  title: "إضافة مهمة",
                  backgroundColor: context.appColors.primaryToPrimaryDark,
                  onTap: onCreateTask,
                ),
              ),

              SizedBox(width: SizeConfig.w(0.025)),

              Expanded(
                child: _BottomActionButton(
                  title: 'حذف الخطة',
                  backgroundColor: AppPalette.red,
                  onTap: onDeleteTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _BottomActionButton({
    required this.title,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButtonWidget(
      width: double.infinity,
      backgroundColor: backgroundColor,
      borderRadius: 6,
      childHorizontalPad: SizeConfig.w(0.025),
      childVerticalPad: SizeConfig.w(0.013),
      onTap: onTap,
      child: CustomTextWidget(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        color: context.appColors.whiteToblack,
        fontFamily: AppFont.elMessiriSemiBold,
        fontSize: SizeConfig.text(0.03),
      ),
    );
  }
}
