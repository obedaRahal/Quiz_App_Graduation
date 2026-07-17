import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/subjects/study_subject_name_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/subjects/study_subjects_list.dart';

class StudySubjectsBottomSheet extends StatelessWidget {
  const StudySubjectsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<StudySubjectsCubit, StudySubjectsState>(
      listenWhen: (previous, current) {
        return previous.createStatus != current.createStatus ||
            previous.deleteStatus != current.deleteStatus;
      },
      listener: (context, state) {
        if (state.isCreateSuccess) {
          showValidationTopSnackBar(
            context,
            title: 'تم بنجاح',
            message: state.actionMessage ?? 'تم إنشاء المادة الدراسية بنجاح',
            type: AppValidationSnackBarType.success,
          );

          context.read<StudySubjectsCubit>().resetCreateState();
        }

        if (state.isCreateFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر إنشاء المادة الدراسية',
            type: AppValidationSnackBarType.error,
          );

          context.read<StudySubjectsCubit>().resetCreateState();
        }

        if (state.isDeleteSuccess) {
          showValidationTopSnackBar(
            context,
            title: 'تم بنجاح',
            message: state.actionMessage ?? 'تم حذف المادة الدراسية بنجاح',
            type: AppValidationSnackBarType.success,
          );

          context.read<StudySubjectsCubit>().resetDeleteState();
        }

        if (state.isDeleteFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر حذف المادة الدراسية',
            type: AppValidationSnackBarType.error,
          );

          context.read<StudySubjectsCubit>().resetDeleteState();
        }
      },
      buildWhen: (previous, current) {
        return previous.loadStatus != current.loadStatus ||
            previous.subjects != current.subjects;
      },
      builder: (context, state) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
            ),
            decoration: BoxDecoration(
              color: context.appColors.whiteToblack,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  SizeConfig.w(0.04),
                  SizeConfig.h(0.012),
                  SizeConfig.w(0.04),
                  SizeConfig.h(0.025),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: SizeConfig.w(0.12),
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppPalette.greyMedium,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    SizedBox(height: SizeConfig.h(0.018)),

                    Center(
                      child: CustomTextWidget(
                        'قائمة المواد',
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.045),
                        color: context.appColors.blackToGrey2Dark,
                        textAlign: TextAlign.right,
                      ),
                    ),

                    const CustomDivider(height: 28, thickness: 2 , isDashed: true,),

                    const StudySubjectNameSection(),

                    const CustomDivider(height: 32, thickness: 2),

                    CustomTextWidget(
                      'المواد المضافة',
                      fontFamily: AppFont.elMessiriBold,
                      fontSize: SizeConfig.text(0.04),
                      color: context.appColors.blackToGrey2Dark,
                      textAlign: TextAlign.right,
                    ),

                    SizedBox(height: SizeConfig.h(0.014)),

                    const StudySubjectsList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
