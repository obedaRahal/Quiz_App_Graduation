import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/create_update_study_plan/create_update_study_plan_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/models/study_plan_mutation_result.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/utils/study_plan_date_utils.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/create_study_plan_body.dart';

class CreateStudyPlanView extends StatelessWidget {
  final StudyPlanSummaryEntity? initialPlan;

  const CreateStudyPlanView({super.key, this.initialPlan});

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
                debugPrint('→ mode: ${state.mode}');
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
                final isUpdateMode = state.isUpdateMode;

                if (state.isSubmitSuccess) {
                  final fallbackMessage = isUpdateMode
                      ? 'تم تعديل الخطة الدراسية بنجاح'
                      : 'تم إنشاء الخطة الدراسية بنجاح';

                  debugPrint(
                    '============ CreateStudyPlanView submit success ============',
                  );
                  debugPrint('→ mode: ${state.mode}');
                  debugPrint('→ planId: ${state.planId}');
                  debugPrint('→ message: ${state.actionMessage}');

                  showValidationTopSnackBar(
                    context,
                    title: 'تم بنجاح',
                    message: state.actionMessage ?? fallbackMessage,
                    type: AppValidationSnackBarType.success,
                  );

                  final result = isUpdateMode && initialPlan != null
                      ? StudyPlanMutationResult.updated(
                          _buildUpdatedPlan(initialPlan!, state),
                        )
                      : const StudyPlanMutationResult.created();

                  Navigator.of(context).pop(result);
                  return;
                }

                if (state.isSubmitFailure) {
                  final fallbackMessage = isUpdateMode
                      ? 'تعذر تعديل الخطة الدراسية'
                      : 'تعذر إنشاء الخطة الدراسية';

                  debugPrint(
                    '============ CreateStudyPlanView submit failure ============',
                  );
                  debugPrint('→ mode: ${state.mode}');
                  debugPrint('→ planId: ${state.planId}');
                  debugPrint('→ title: ${state.errorTitle}');
                  debugPrint('→ message: ${state.errorMessage}');

                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? 'خطأ',
                    message: state.errorMessage ?? fallbackMessage,
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
                  return previous.mode != current.mode ||
                      previous.planId != current.planId ||
                      previous.submitStatus != current.submitStatus ||
                      previous.title != current.title ||
                      previous.emoji != current.emoji ||
                      previous.startDate != current.startDate ||
                      previous.endDate != current.endDate ||
                      previous.selectedSubjectIds !=
                          current.selectedSubjectIds ||
                      previous.dailyStudyHours != current.dailyStudyHours ||
                      previous.isDefault != current.isDefault ||
                      previous.isFormInitialized != current.isFormInitialized;
                },
                builder: (context, state) {
                  final appColors = context.appColors;

                  final isButtonEnabled = state.canSubmit;

                  final buttonText = state.isUpdateMode
                      ? 'حفظ التعديلات'
                      : 'إنشاء الخطة';

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
                                '============ CreateStudyPlanView.submitStudyPlan ============',
                              );
                              debugPrint('→ mode: ${state.mode}');
                              debugPrint('→ planId: ${state.planId}');
                              debugPrint(
                                '→ isFormInitialized: '
                                '${state.isFormInitialized}',
                              );
                              debugPrint('→ hasChanges: ${state.hasChanges}');
                              debugPrint('→ canSubmit: ${state.canSubmit}');

                              context
                                  .read<CreateUpdateStudyPlanCubit>()
                                  .submitStudyPlan();
                            }
                          : () {
                              debugPrint(
                                '============ Study plan submit disabled ============',
                              );
                              debugPrint('→ mode: ${state.mode}');
                              debugPrint(
                                '→ isFormInitialized: '
                                '${state.isFormInitialized}',
                              );
                              debugPrint('→ hasChanges: ${state.hasChanges}');
                              debugPrint(
                                '→ isSubmitLoading: '
                                '${state.isSubmitLoading}',
                              );
                              debugPrint('→ canSubmit: ${state.canSubmit}');
                              debugPrint(
                                '=====================================================',
                              );
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
                              buttonText,
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

  StudyPlanSummaryEntity _buildUpdatedPlan(
    StudyPlanSummaryEntity plan,
    CreateUpdateStudyPlanState state,
  ) {
    final startDate = state.startDate!;
    final endDate = state.endDate!;
    final startDateValue = StudyPlanDateUtils.formatApiDate(startDate);
    final endDateValue = StudyPlanDateUtils.formatApiDate(endDate);
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    return plan.copyWith(
      title: state.title.trim(),
      emoji: state.emoji.trim(),
      subjectsCount: state.selectedSubjectsCount,
      dailyStudyMinutes: state.dailyStudyHours * 60,
      dailyStudyHours: state.dailyStudyHours,
      durationDays: endDate.difference(startDate).inDays + 1,
      startDate: startDateValue,
      endDate: endDateValue,
      startsInDays: startDate.difference(normalizedToday).inDays,
      remainingDays: endDate.difference(normalizedToday).inDays,
      isDefault: state.isDefault,
      startDateLabel: startDateValue,
      endDateLabel: endDateValue,
    );
  }
}
