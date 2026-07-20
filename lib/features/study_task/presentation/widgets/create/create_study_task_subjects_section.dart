// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
// import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';

// class CreateStudyTaskSubjectsSection extends StatelessWidget {
//   const CreateStudyTaskSubjectsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
//       buildWhen: (previous, current) {
//         return previous.selectedStudyPlanSubjectId !=
//                 current.selectedStudyPlanSubjectId ||
//             previous.subjectsStatus != current.subjectsStatus ||
//             previous.availableSubjects != current.availableSubjects;
//       },
//       builder: (context, state) {
//         final selectedSubject = _findSubjectById(
//           subjects: state.availableSubjects,
//           subjectId: state.selectedStudyPlanSubjectId,
//         );

//         final isLoading = state.isSubjectsLoading;

//         final hasNoSubjects =
//             state.isSubjectsSuccess && state.availableSubjects.isEmpty;

//         /*
//          * عند الفشل نبقي الحقل قابلًا للضغط حتى يستطيع
//          * المستخدم إعادة المحاولة.
//          *
//          * أما أثناء التحميل أو عند نجاح الطلب دون وجود
//          * مواد، فنقوم بتعطيله.
//          */
//         final isEnabled = !isLoading && !hasNoSubjects;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             StudyPlanFormSectionHeader(
//               title: 'مادة المهمة',
//               description: 'اختر المادة الدراسية التي تنتمي إليها هذه المهمة.',
//               image: AppImage.layers,
//             ),
//             SizedBox(height: SizeConfig.h(0.016)),
//             StudyPlanSelectionBox(
//               title: _buildSelectionTitle(state),
//               value: selectedSubject?.name,
//               icon: _buildSelectionIcon(state),
//               enabled: isEnabled,
//               onTap: () {
//                 _openSubjectsDialog(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _openSubjectsDialog(BuildContext context) async {
//     var state = context.read<CreateStudyTaskCubit>().state;

//     debugPrint(
//       '============ '
//       'Open Study Task Subject Dialog '
//       '============',
//     );
//     debugPrint(
//       '→ subjects status: '
//       '${state.subjectsStatus}',
//     );
//     debugPrint(
//       '→ available subjects: '
//       '${state.availableSubjects.length}',
//     );
//     debugPrint(
//       '→ selected subject id: '
//       '${state.selectedStudyPlanSubjectId}',
//     );
//     debugPrint(
//       '================================'
//       '========================',
//     );

//     if (state.isSubjectsLoading) {
//       debugPrint(
//         '✗ dialog ignored: '
//         'subjects still loading',
//       );

//       return;
//     }

//     /*
//      * عند فشل جلب المواد، الضغط على الحقل يعيد
//      * المحاولة مباشرة.
//      */
//     if (state.isSubjectsFailure) {
//       debugPrint('→ retrying study plan subjects request');

//       await context.read<CreateStudyTaskCubit>().retryGetStudyPlanSubjects();

//       if (!context.mounted) {
//         return;
//       }

//       state = context.read<CreateStudyTaskCubit>().state;

//       if (!state.isSubjectsSuccess) {
//         debugPrint(
//           '✗ cannot open dialog: '
//           'subjects request failed',
//         );

//         return;
//       }
//     }

//     if (state.availableSubjects.isEmpty) {
//       debugPrint(
//         '✗ cannot open dialog: '
//         'no subjects available',
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(
//           const SnackBar(content: Text('لا توجد مواد مضافة إلى هذه الخطة')),
//         );

//       return;
//     }

//     /*
//      * نمرر القيمة الحالية فقط إذا كانت المادة ما زالت
//      * موجودة ضمن القائمة القادمة من الخادم.
//      */
//     final validSelectedSubject = _findSubjectById(
//       subjects: state.availableSubjects,
//       subjectId: state.selectedStudyPlanSubjectId,
//     );

//     final selectedSubjectId = await showSelectStudyTaskSubjectDialog(
//       context,
//       subjects: state.availableSubjects,
//       initiallySelectedId: validSelectedSubject?.id,
//     );

//     if (selectedSubjectId == null || !context.mounted) {
//       debugPrint('→ subject selection cancelled');

//       return;
//     }

//     debugPrint(
//       '✓ selected study plan subject id: '
//       '$selectedSubjectId',
//     );

//     context.read<CreateStudyTaskCubit>().changeSelectedSubject(
//       selectedSubjectId,
//     );
//   }

//   static StudyPlanSubjectEntity? _findSubjectById({
//     required List<StudyPlanSubjectEntity> subjects,
//     required int? subjectId,
//   }) {
//     if (subjectId == null) {
//       return null;
//     }

//     for (final subject in subjects) {
//       if (subject.id == subjectId) {
//         return subject;
//       }
//     }

//     return null;
//   }

//   static String _buildSelectionTitle(CreateStudyTaskState state) {
//     if (state.isSubjectsLoading) {
//       return 'جارٍ تحميل مواد الخطة...';
//     }

//     if (state.isSubjectsFailure) {
//       return 'تعذر تحميل المواد، اضغط للمحاولة';
//     }

//     if (state.isSubjectsSuccess && state.availableSubjects.isEmpty) {
//       return 'لا توجد مواد في هذه الخطة';
//     }

//     return 'اختر مادة المهمة';
//   }

//   static IconData _buildSelectionIcon(CreateStudyTaskState state) {
//     if (state.isSubjectsFailure) {
//       return Icons.refresh_rounded;
//     }

//     if (state.isSubjectsLoading) {
//       return Icons.hourglass_top_rounded;
//     }

//     return Icons.layers_outlined;
//   }
// }

// Future<int?> showSelectStudyTaskSubjectDialog(
//   BuildContext context, {
//   required List<StudyPlanSubjectEntity> subjects,
//   required int? initiallySelectedId,
// }) {
//   return showDialog<int>(
//     context: context,
//     builder: (dialogContext) {
//       return _SelectStudyTaskSubjectDialog(
//         subjects: subjects,
//         initiallySelectedId: initiallySelectedId,
//       );
//     },
//   );
// }

// class _SelectStudyTaskSubjectDialog extends StatefulWidget {
//   final List<StudyPlanSubjectEntity> subjects;

//   final int? initiallySelectedId;

//   const _SelectStudyTaskSubjectDialog({
//     required this.subjects,
//     required this.initiallySelectedId,
//   });

//   @override
//   State<_SelectStudyTaskSubjectDialog> createState() {
//     return _SelectStudyTaskSubjectDialogState();
//   }
// }

// class _SelectStudyTaskSubjectDialogState
//     extends State<_SelectStudyTaskSubjectDialog> {
//   int? _selectedSubjectId;

//   @override
//   void initState() {
//     super.initState();

//     _selectedSubjectId = _isValidInitialSelection(widget.initiallySelectedId)
//         ? widget.initiallySelectedId
//         : null;
//   }

//   bool _isValidInitialSelection(int? subjectId) {
//     if (subjectId == null) {
//       return false;
//     }

//     return widget.subjects.any((subject) => subject.id == subjectId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return AlertDialog(
//       title: const Text('اختر مادة المهمة', textAlign: TextAlign.right),
//       contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
//       content: ConstrainedBox(
//         constraints: BoxConstraints(maxHeight: SizeConfig.h(0.55)),
//         child: SizedBox(
//           width: double.maxFinite,
//           child: ListView.separated(
//             shrinkWrap: true,
//             itemCount: widget.subjects.length,
//             separatorBuilder: (_, __) {
//               return Divider(
//                 height: 1,
//                 color: isDark
//                     ? AppPalette.borderFieldColorNDark
//                     : AppPalette.borderFieldColorNLight,
//               );
//             },
//             itemBuilder: (context, index) {
//               final subject = widget.subjects[index];

//               final isSelected = subject.id == _selectedSubjectId;

//               return RadioListTile<int>(
//                 value: subject.id,
//                 groupValue: _selectedSubjectId,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedSubjectId = value;
//                   });
//                 },
//                 title: Text(
//                   subject.name,
//                   textAlign: TextAlign.right,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 secondary: Icon(
//                   Icons.menu_book_outlined,
//                   color: isSelected
//                       ? Theme.of(context).colorScheme.primary
//                       : AppPalette.greyMedium,
//                 ),
//                 controlAffinity: ListTileControlAffinity.leading,
//                 selected: isSelected,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//               );
//             },
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('إلغاء'),
//         ),
//         FilledButton(
//           onPressed: _selectedSubjectId == null
//               ? null
//               : () {
//                   Navigator.of(context).pop(_selectedSubjectId);
//                 },
//           child: const Text('اختيار'),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_subjects_section.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subjects/study_task_subject_option.dart';

class CreateStudyTaskSubjectsSection extends StatelessWidget {
  const CreateStudyTaskSubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.availableSubjects != current.availableSubjects ||
            previous.selectedStudyPlanSubjectId !=
                current.selectedStudyPlanSubjectId ||
            previous.subjectsStatus != current.subjectsStatus;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        final subjectOptions = state.availableSubjects.map((subject) {
          return StudyTaskSubjectOption(id: subject.id, name: subject.name);
        }).toList();

        return StudyTaskSubjectsSection(
          subjects: subjectOptions,
          selectedSubjectId: state.selectedStudyPlanSubjectId,
          isLoading: state.isSubjectsLoading,
          errorMessage: state.isSubjectsFailure ? state.errorMessage : null,
          //onRetry: cubit.load,
          onSubjectChanged: (subjectId) {
            cubit.changeSelectedSubject(subjectId);
          },
        );
      },
    );
  }
}
