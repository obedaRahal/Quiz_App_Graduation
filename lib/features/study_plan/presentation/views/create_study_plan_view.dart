import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/create_study_plan_body.dart';

class CreateStudyPlanView extends StatelessWidget {
  const CreateStudyPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<
              CreateUpdateStudyPlanCubit,
              CreateUpdateStudyPlanState
            >(
              listenWhen: (previous, current) {
                return previous.subjectsStatus != current.subjectsStatus;
              },
              listener: (context, state) {
                if (!state.isSubjectsFailure) {
                  return;
                }

                debugPrint(
                  '============ CreateStudyPlanView subjects failure ============',
                );
                debugPrint('→ title: ${state.errorTitle}');
                debugPrint('→ message: ${state.errorMessage}');

                showValidationTopSnackBar(
                  context,
                  title: state.errorTitle ?? 'خطأ',
                  message: state.errorMessage ?? 'تعذر جلب المواد الدراسية',
                  type: AppValidationSnackBarType.error,
                );

                context.read<CreateUpdateStudyPlanCubit>().resetError();
              },
            ),

            BlocListener<
              CreateUpdateStudyPlanCubit,
              CreateUpdateStudyPlanState
            >(
              listenWhen: (previous, current) {
                return previous.submitStatus != current.submitStatus;
              },
              listener: (context, state) {
                if (state.isSubmitSuccess) {
                  debugPrint(
                    '============ CreateStudyPlanView submit success ============',
                  );
                  debugPrint('→ message: ${state.actionMessage}');

                  showValidationTopSnackBar(
                    context,
                    title: 'تم بنجاح',
                    message:
                        state.actionMessage ?? 'تم إنشاء الخطة الدراسية بنجاح',
                    type: AppValidationSnackBarType.success,
                  );

                  Navigator.of(context).pop(true);
                  return;
                }

                if (state.isSubmitFailure) {
                  debugPrint(
                    '============ CreateStudyPlanView submit failure ============',
                  );
                  debugPrint('→ title: ${state.errorTitle}');
                  debugPrint('→ message: ${state.errorMessage}');

                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? 'خطأ',
                    message: state.errorMessage ?? 'تعذر إنشاء الخطة الدراسية',
                    type: AppValidationSnackBarType.error,
                  );

                  context.read<CreateUpdateStudyPlanCubit>().resetSubmitState();
                }
              },
            ),
          ],
          child: Column(
            children: [
              const Expanded(child: CreateStudyPlanBody()),

              BlocBuilder<
                CreateUpdateStudyPlanCubit,
                CreateUpdateStudyPlanState
              >(
                buildWhen: (previous, current) {
                  return previous.submitStatus != current.submitStatus ||
                      previous.title != current.title ||
                      previous.emoji != current.emoji ||
                      previous.startDate != current.startDate ||
                      previous.endDate != current.endDate ||
                      previous.selectedSubjectIds !=
                          current.selectedSubjectIds ||
                      previous.dailyStudyHours != current.dailyStudyHours;
                },
                builder: (context, state) {
                  final appColors = context.appColors;

                  final isButtonEnabled =
                      state.canSubmit && !state.isSubmitLoading;

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
                      childVerticalPad: SizeConfig.w(0.013),
                      borderRadius: 6,
                      onTap: isButtonEnabled
                          ? () {
                              debugPrint(
                                '============ CreateStudyPlanView.createPlan ============',
                              );

                              context
                                  .read<CreateUpdateStudyPlanCubit>()
                                  .createStudyPlan();
                            }
                          : () {
                              debugPrint('✗ Create study plan button disabled');
                            },
                      child: state.isSubmitLoading
                          ? SizedBox(
                              width: SizeConfig.w(0.045),
                              height: SizeConfig.w(0.045),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppPalette.white,
                              ),
                            )
                          : CustomTextWidget(
                              'إنشاء الخطة',
                              fontSize: SizeConfig.text(0.03),
                              color: isButtonEnabled
                                  ? AppPalette.white
                                  : AppPalette.greyMedium,
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
