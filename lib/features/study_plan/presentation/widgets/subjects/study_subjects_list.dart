import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_cubit.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_subjects/study_subjects_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/subjects/study_subject_item.dart';

class StudySubjectsList extends StatelessWidget {
  const StudySubjectsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudySubjectsCubit, StudySubjectsState>(
      buildWhen: (previous, current) {
        return previous.subjects != current.subjects ||
            previous.loadStatus != current.loadStatus ||
            previous.deleteStatus != current.deleteStatus ||
            previous.deletingSubjectId != current.deletingSubjectId;
      },
      builder: (context, state) {
        if (state.isLoading && state.subjects.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isLoadFailure && state.subjects.isEmpty) {
          return Column(
            children: [
              CustomTextWidget(
                state.errorMessage ?? 'تعذر جلب المواد الدراسية',
                color: AppPalette.red,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: SizeConfig.h(0.012)),

              TextButton(
                onPressed: () {
                  context.read<StudySubjectsCubit>().getSubjects();
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          );
        }

        if (state.subjects.isEmpty) {
          return const EmptyActionBox(
            icon: Icons.menu_book_outlined,
            title: 'لا توجد مواد دراسية',
            description: 'أضف مادة دراسية لتستخدمها في خططك ومهامك',
          );
        }

        return Wrap(
          alignment: WrapAlignment.end,
          spacing: SizeConfig.w(0.02),
          runSpacing: SizeConfig.h(0.01),
          children: state.subjects.map((subject) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: SizeConfig.w(0.44)),
              child: StudySubjectItem(
                subject: subject,
                isDeleting: state.isDeletingSubject(subject.id),
                onDeleteTap: () {
                  context.read<StudySubjectsCubit>().deleteSubject(
                    subjectId: subject.id,
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
