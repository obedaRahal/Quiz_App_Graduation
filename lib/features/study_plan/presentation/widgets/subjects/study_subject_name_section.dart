import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_title_description_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_state.dart';

class StudySubjectNameSection extends StatelessWidget {
  const StudySubjectNameSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        StudySubjectsCubit,
        StudySubjectsState>(
      buildWhen: (previous, current) {
        return previous.draftName != current.draftName ||
            previous.createStatus !=
                current.createStatus;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextWidget(
              'اسم المادة',
              fontSize: SizeConfig.text(0.04),
              fontWeight: FontWeight.w900,
              color:
                  context.appColors.blackToGrey2Dark,
              textAlign: TextAlign.right,
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            CreateTestCounterTextField(
              value: state.draftName,
              hintText: 'أدخل اسم المادة',
              image: AppImage.layers,
              maxLength:
                  StudySubjectsCubit
                      .subjectNameMaxLength,
              currentLength:
                  state.draftName.length,
              minLines: 1,
              maxLines: 1,
              onChanged: context
                  .read<StudySubjectsCubit>()
                  .changeDraftName,
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            CustomButtonWidget(
              width: double.infinity,
              backgroundColor:
                  state.canCreateSubject
                      ? context.appColors
                          .primaryToPrimaryDark
                      : AppPalette.greyMedium,
              childHorizontalPad:
                  SizeConfig.w(0.04),
              childVerticalPad:
                  SizeConfig.h(0.011),
              borderRadius: 7,
              onTap: state.canCreateSubject
                  ? () {
                      context
                          .read<StudySubjectsCubit>()
                          .createSubject();
                    }
                  : (){},
              child: state.isCreateLoading
                  ? SizedBox(
                      width: SizeConfig.w(0.045),
                      height: SizeConfig.w(0.045),
                      child:
                          const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : CustomTextWidget(
                      'إنشاء المادة',
                      fontSize:
                          SizeConfig.text(0.031),
                      color: context.appColors.whiteToblack,
                    ),
            ),
          ],
        );
      },
    );
  }
}