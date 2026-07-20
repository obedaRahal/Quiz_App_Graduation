// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_subtask_item.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_subtask_row.dart';

// class StudyTaskSubtasksSection extends StatelessWidget {
//   final List<StudyTaskSubtaskItem> subtasks;

//   final int maxSubtasksCount;
//   final int maxSubtaskTitleLength;

//   final VoidCallback onAddSubtask;
//   final ValueChanged<int> onRemoveSubtask;

//   final void Function(int index, String title) onSubtaskTitleChanged;

//   final void Function(int index, bool isCompleted)? onSubtaskCompletedChanged;
//   final String sectionDescription;

//   final bool showCompletedCheckbox;

//   const StudyTaskSubtasksSection({
//     super.key,
//     required this.subtasks,
//     required this.maxSubtasksCount,
//     required this.maxSubtaskTitleLength,
//     required this.onAddSubtask,
//     required this.onRemoveSubtask,
//     required this.onSubtaskTitleChanged,
//     required this.onSubtaskCompletedChanged,
//     this.sectionDescription =
//         'قسّم المهمة إلى خطوات صغيرة لتسهيل متابعتها وإنجازها.',

//     this.showCompletedCheckbox = true,
//   });

//   bool get _canAdd {
//     return subtasks.length < maxSubtasksCount;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         StudyPlanFormSectionHeader(
//           title: 'المهام الفرعية',
//           description: sectionDescription,
//           image: AppImage.menu,
//         ),

//         SizedBox(height: SizeConfig.h(0.016)),

//         ...List.generate(subtasks.length, (index) {
//           final subtask = subtasks[index];

//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: index == subtasks.length - 1 ? 0 : 12,
//             ),
//             child: StudyTaskSubtaskRow(
//               key: ValueKey(subtask.id ?? 'new-subtask-$index'),
//               index: index,
//               title: subtask.title,
//               isCompleted: subtask.isCompleted,
//               maxTitleLength: maxSubtaskTitleLength,
//               canRemove: subtasks.length > 1,
//               showCompletedCheckbox: showCompletedCheckbox,
//               onTitleChanged: (title) {
//                 onSubtaskTitleChanged(index, title);
//               },
//               onCompletedChanged: onSubtaskCompletedChanged == null
//                   ? null
//                   : (isCompleted) {
//                       onSubtaskCompletedChanged!(index, isCompleted);
//                     },
//               onRemove: () {
//                 onRemoveSubtask(index);
//               },
//             ),
//           );
//         }),

//         SizedBox(height: SizeConfig.h(0.014)),

//         OutlinedButton.icon(
//           onPressed: _canAdd ? onAddSubtask : null,
//           icon: const Icon(Icons.add_rounded),
//           label: Text(_canAdd ? 'إضافة مهمة فرعية' : 'وصلت إلى الحد الأقصى'),
//         ),

//         SizedBox(height: SizeConfig.h(0.006)),

//         Text(
//           '${subtasks.length}/$maxSubtasksCount',
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_add_subtask_button.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_subtask_item.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/subtasks/study_task_subtask_row.dart';

class StudyTaskSubtasksSection extends StatelessWidget {
  final List<StudyTaskSubtaskItem> subtasks;

  final int maxSubtasksCount;
  final int maxSubtaskTitleLength;

  final VoidCallback onAddSubtask;
  final ValueChanged<int> onRemoveSubtask;

  final void Function(int index, String title) onSubtaskTitleChanged;

  final void Function(int index, bool isCompleted)? onSubtaskCompletedChanged;

  final bool showCompletedCheckbox;

  const StudyTaskSubtasksSection({
    super.key,
    required this.subtasks,
    required this.maxSubtasksCount,
    required this.maxSubtaskTitleLength,
    required this.onAddSubtask,
    required this.onRemoveSubtask,
    required this.onSubtaskTitleChanged,
    this.onSubtaskCompletedChanged,
    this.showCompletedCheckbox = true,
  });

  bool get canAddSubtask {
    return subtasks.length < maxSubtasksCount;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         StudyPlanFormSectionHeader(
          title: 'المهام الفرعية',
          description:
              'يمكنك تقسيم هذه المهمة إلى خطوات صغيرة ليسهل عليك إنجازها ومتابعتها.',
          image: AppImage.layers,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        _SubtasksContainer(
          subtasks: subtasks,
          maxSubtaskTitleLength: maxSubtaskTitleLength,
          canAddSubtask: canAddSubtask,
          showCompletedCheckbox: showCompletedCheckbox,
          onAddSubtask: onAddSubtask,
          onRemoveSubtask: onRemoveSubtask,
          onSubtaskTitleChanged: onSubtaskTitleChanged,
          onSubtaskCompletedChanged: onSubtaskCompletedChanged,
        ),

        SizedBox(height: SizeConfig.h(0.006)),

        Align(
          alignment: Alignment.centerLeft,
          child: CustomTextWidget(
            '${subtasks.length}/'
            '$maxSubtasksCount',
            fontSize: SizeConfig.text(0.028),
            fontWeight: FontWeight.w700,
            color: AppPalette.greyMedium,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}

class _SubtasksContainer extends StatelessWidget {
  final List<StudyTaskSubtaskItem> subtasks;

  final int maxSubtaskTitleLength;
  final bool canAddSubtask;
  final bool showCompletedCheckbox;

  final VoidCallback onAddSubtask;
  final ValueChanged<int> onRemoveSubtask;

  final void Function(int index, String title) onSubtaskTitleChanged;

  final void Function(int index, bool isCompleted)? onSubtaskCompletedChanged;

  const _SubtasksContainer({
    required this.subtasks,
    required this.maxSubtaskTitleLength,
    required this.canAddSubtask,
    required this.showCompletedCheckbox,
    required this.onAddSubtask,
    required this.onRemoveSubtask,
    required this.onSubtaskTitleChanged,
    required this.onSubtaskCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.030),
        vertical: SizeConfig.h(0.012),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark
              ? AppPalette.borderFieldColorNDark
              : AppPalette.borderFieldColorNLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...List.generate(subtasks.length, (index) {
            final subtask = subtasks[index];

            return Column(
              children: [
                StudyTaskSubtaskRow(
                  key: ValueKey(subtask.id ?? 'study-task-subtask-$index'),
                  index: index,
                  value: subtask.title,
                  isCompleted: subtask.isCompleted,
                  maxTitleLength: maxSubtaskTitleLength,
                  showCompletedCheckbox: showCompletedCheckbox,

                  onTitleChanged: (value) {
                    onSubtaskTitleChanged(index, value);
                  },

                  onCompletedChanged: onSubtaskCompletedChanged == null
                      ? null
                      : (value) {
                          onSubtaskCompletedChanged!(index, value);
                        },

                  onRemove: () {
                    if (subtasks.length > 1) {
                      onRemoveSubtask(index);
                      return;
                    }

                    onSubtaskTitleChanged(index, '');
                  },
                ),

                if (index != subtasks.length - 1)
                  Divider(
                    height: SizeConfig.h(0.020),
                    color: isDark
                        ? AppPalette.borderFieldColorNDark
                        : AppPalette.borderFieldColorNLight,
                  ),
              ],
            );
          }),

          if (subtasks.isNotEmpty) SizedBox(height: SizeConfig.h(0.008)),

          StudyTaskAddSubtaskButton(
            enabled: canAddSubtask,
            onTap: () {
              debugPrint('============ Add Study Task Subtask ============');

              onAddSubtask();
            },
          ),
        ],
      ),
    );
  }
}
