// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_title_description_section.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_date_section.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_options_section.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_repeat_section.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_subjects_section.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_subtasks_section.dart';

// class CreateStudyTaskFormSections extends StatelessWidget {
//   const CreateStudyTaskFormSections({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         CreateStudyTaskTitleDescriptionSection(),
//         CustomDivider(height: 30, thickness: 2),
//         CreateStudyTaskDateSection(),
//         CustomDivider(height: 30, thickness: 2),
//         CreateStudyTaskOptionsSection(),

//         CustomDivider(height: 30, thickness: 2),
//         CreateStudyTaskSubjectsSection(),
//         CustomDivider(height: 30, thickness: 2),

//         CreateStudyTaskRepeatSection(),
//         CustomDivider(height: 30, thickness: 2),

//         CreateStudyTaskSubtasksSection(),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_divider.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/widgets/create_test_title_description_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_date_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_options_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_repeat_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_subjects_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_subtasks_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_title_description_section.dart';

class CreateStudyTaskFormSections extends StatelessWidget {
  const CreateStudyTaskFormSections({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreateStudyTaskTitleDescriptionSection(),

        CustomDivider(height: 30, thickness: 2),

        CreateStudyTaskDateSection(),

        CustomDivider(height: 30, thickness: 2),

        CreateStudyTaskOptionsSection(),

        CustomDivider(height: 30, thickness: 2),

        CreateStudyTaskSubjectsSection(),

        CustomDivider(height: 30, thickness: 2),

        CreateStudyTaskRepeatSection(),

        CustomDivider(height: 30, thickness: 2),

        CreateStudyTaskSubtasksSection(),
      ],
    );
  }
}

class CreateStudyTaskTitleDescriptionSection extends StatelessWidget {
  const CreateStudyTaskTitleDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.title != current.title ||
            previous.description != current.description;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const _SectionTitle(),
            SizedBox(height: SizeConfig.h(0.006)),
            CustomTextWidget(
              'أضف عنواناً واضحاً ووصفاً مختصراً يشرح المهمة الدراسية.',
              fontSize: SizeConfig.text(0.033),
              fontWeight: FontWeight.w500,
              color: AppPalette.greyMedium,
              textAlign: TextAlign.right,
              maxLines: 2,
            ),
            SizedBox(height: SizeConfig.h(0.016)),
            CreateTestCounterTextField(
              value: state.title,
              hintText: 'العنوان',
              image: AppImage.selfie,
              maxLength: CreateStudyTaskState.titleMaxLength,
              currentLength: state.title.length,
              minLines: 1,
              maxLines: 1,
              onChanged: context.read<CreateStudyTaskCubit>().changeTitle,
            ),
            SizedBox(height: SizeConfig.h(0.014)),
            CreateTestCounterTextField(
              value: state.description,
              hintText: 'الوصف',
              image: AppImage.menu,
              maxLength: CreateStudyTaskState.descriptionMaxLength,
              currentLength: state.description.length,
              minLines: 1,
              maxLines: 3,
              onChanged: context.read<CreateStudyTaskCubit>().changeDescription,
            ),
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomTextWidget(
          'العنوان والوصف',
          fontSize: SizeConfig.text(0.043),
          fontWeight: FontWeight.w800,
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
          textAlign: TextAlign.right,
        ),

        SizedBox(width: SizeConfig.w(0.018)),

        Icon(
          Icons.notes_outlined,
          size: SizeConfig.text(0.090),
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
        ),
      ],
    );
  }
}
