// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
// import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';

// class CreateStudyTaskRepeatSection extends StatelessWidget {
//   const CreateStudyTaskRepeatSection({super.key});

//   /*
//    * قيم الأيام حسب الـ API:
//    *
//    * 0 = الأحد
//    * 1 = الإثنين
//    * 2 = الثلاثاء
//    * 3 = الأربعاء
//    * 4 = الخميس
//    * 5 = الجمعة
//    * 6 = السبت
//    */
//   static const Map<int, String> weekdays = {
//     0: 'الأحد',
//     1: 'الإثنين',
//     2: 'الثلاثاء',
//     3: 'الأربعاء',
//     4: 'الخميس',
//     5: 'الجمعة',
//     6: 'السبت',
//   };

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
//       buildWhen: (previous, current) {
//         return previous.repeatPattern != current.repeatPattern ||
//             previous.repeatWeekday != current.repeatWeekday;
//       },
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             StudyPlanFormSectionHeader(
//               title: 'تكرار المهمة',
//               description: 'حدد نمط تكرار المهمة واليوم الذي تريد تكرارها فيه.',
//               image: AppImage.reportedIcon,
//             ),
//             SizedBox(height: SizeConfig.h(0.016)),
//             StudyPlanSelectionBox(
//               title: 'نمط التكرار',
//               value: _formatRepeatValue(
//                 pattern: state.repeatPattern,
//                 weekday: state.repeatWeekday,
//               ),
//               icon: Icons.repeat_rounded,
//               onTap: () {
//                 _openRepeatDialog(context, state);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _openRepeatDialog(
//     BuildContext context,
//     CreateStudyTaskState state,
//   ) async {
//     debugPrint(
//       '============ '
//       'Open Study Task Repeat Dialog '
//       '============',
//     );
//     debugPrint(
//       '→ current pattern: '
//       '${state.repeatPattern}',
//     );
//     debugPrint(
//       '→ current weekday: '
//       '${state.repeatWeekday}',
//     );

//     final result = await showSelectStudyTaskRepeatDialog(
//       context,
//       initialPattern: state.repeatPattern,
//       initialWeekday: state.repeatWeekday,
//     );

//     if (result == null || !context.mounted) {
//       debugPrint('→ repeat selection cancelled');
//       return;
//     }

//     debugPrint(
//       '→ selected pattern: '
//       '${result.pattern}',
//     );
//     debugPrint(
//       '→ selected weekday: '
//       '${result.weekday}',
//     );

//     final cubit = context.read<CreateStudyTaskCubit>();

//     cubit.changeRepeatPattern(result.pattern);

//     if (result.pattern != StudyTaskRepeatPattern.none &&
//         result.weekday != null) {
//       cubit.changeRepeatWeekday(result.weekday!);
//     }
//   }

//   static String _formatRepeatValue({
//     required StudyTaskRepeatPattern pattern,
//     required int? weekday,
//   }) {
//     if (pattern == StudyTaskRepeatPattern.none) {
//       return pattern.apiValue;
//     }

//     final weekdayText = weekdays[weekday];

//     if (weekdayText == null) {
//       return pattern.apiValue;
//     }

//     return '${pattern.apiValue} - $weekdayText';
//   }
// }

// Future<StudyTaskRepeatDialogResult?> showSelectStudyTaskRepeatDialog(
//   BuildContext context, {
//   required StudyTaskRepeatPattern initialPattern,
//   required int? initialWeekday,
// }) async {
//   debugPrint(
//     '============ '
//     'showSelectStudyTaskRepeatDialog '
//     '============',
//   );
//   debugPrint('→ initial pattern: $initialPattern');
//   debugPrint('→ initial weekday: $initialWeekday');

//   final result = await showDialog<StudyTaskRepeatDialogResult>(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) {
//       return SelectStudyTaskRepeatDialog(
//         initialPattern: initialPattern,
//         initialWeekday: initialWeekday,
//       );
//     },
//   );

//   debugPrint('→ dialog result: $result');
//   debugPrint(
//     '================================'
//     '=========================',
//   );

//   return result;
// }

// class StudyTaskRepeatDialogResult {
//   final StudyTaskRepeatPattern pattern;
//   final int? weekday;

//   const StudyTaskRepeatDialogResult({
//     required this.pattern,
//     required this.weekday,
//   });

//   @override
//   String toString() {
//     return 'StudyTaskRepeatDialogResult('
//         'pattern: $pattern, '
//         'weekday: $weekday'
//         ')';
//   }
// }

// class SelectStudyTaskRepeatDialog extends StatefulWidget {
//   final StudyTaskRepeatPattern initialPattern;
//   final int? initialWeekday;

//   const SelectStudyTaskRepeatDialog({
//     super.key,
//     required this.initialPattern,
//     required this.initialWeekday,
//   });

//   @override
//   State<SelectStudyTaskRepeatDialog> createState() {
//     return _SelectStudyTaskRepeatDialogState();
//   }
// }

// class _SelectStudyTaskRepeatDialogState
//     extends State<SelectStudyTaskRepeatDialog> {
//   static const Map<int, String> _weekdays = {
//     0: 'الأحد',
//     1: 'الإثنين',
//     2: 'الثلاثاء',
//     3: 'الأربعاء',
//     4: 'الخميس',
//     5: 'الجمعة',
//     6: 'السبت',
//   };

//   late StudyTaskRepeatPattern _selectedPattern;

//   int? _selectedWeekday;

//   @override
//   void initState() {
//     super.initState();

//     _selectedPattern = widget.initialPattern;

//     /*
//      * نحافظ فقط على القيم المقبولة من API.
//      * أي قيمة قديمة مثل 7 سيتم تجاهلها.
//      */
//     _selectedWeekday = _isValidWeekday(widget.initialWeekday)
//         ? widget.initialWeekday
//         : null;

//     if (!_requiresWeekday) {
//       _selectedWeekday = null;
//     }
//   }

//   bool get _requiresWeekday {
//     return _selectedPattern != StudyTaskRepeatPattern.none;
//   }

//   bool get _canConfirm {
//     if (!_requiresWeekday) {
//       return true;
//     }

//     return _isValidWeekday(_selectedWeekday);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(
//         horizontal: SizeConfig.w(0.045),
//         vertical: SizeConfig.h(0.080),
//       ),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxHeight: SizeConfig.h(0.75)),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _DialogHeader(
//               isDark: isDark,
//               onCloseTap: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             Divider(
//               height: 1,
//               color: isDark
//                   ? AppPalette.borderFieldColorNDark
//                   : AppPalette.borderFieldColorNLight,
//             ),
//             Flexible(
//               child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: SizeConfig.w(0.045),
//                   vertical: SizeConfig.h(0.020),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const _FieldTitle(title: 'نمط التكرار'),
//                     SizedBox(height: SizeConfig.h(0.010)),
//                     Wrap(
//                       textDirection: TextDirection.rtl,
//                       spacing: SizeConfig.w(0.018),
//                       runSpacing: SizeConfig.h(0.010),
//                       children: StudyTaskRepeatPattern.values.map((pattern) {
//                         return _SelectionChip(
//                           title: pattern.apiValue,
//                           isSelected: pattern == _selectedPattern,
//                           onTap: () {
//                             _changePattern(pattern);
//                           },
//                         );
//                       }).toList(),
//                     ),
//                     AnimatedSize(
//                       duration: const Duration(milliseconds: 220),
//                       curve: Curves.easeInOut,
//                       alignment: Alignment.topCenter,
//                       child: !_requiresWeekday
//                           ? const SizedBox.shrink()
//                           : Padding(
//                               padding: EdgeInsets.only(
//                                 top: SizeConfig.h(0.022),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                                 children: [
//                                   const _FieldTitle(title: 'يوم التكرار'),
//                                   SizedBox(height: SizeConfig.h(0.010)),
//                                   Wrap(
//                                     textDirection: TextDirection.rtl,
//                                     spacing: SizeConfig.w(0.018),
//                                     runSpacing: SizeConfig.h(0.010),
//                                     children: _weekdays.entries.map((entry) {
//                                       return _SelectionChip(
//                                         title: entry.value,
//                                         isSelected:
//                                             entry.key == _selectedWeekday,
//                                         onTap: () {
//                                           setState(() {
//                                             _selectedWeekday = entry.key;
//                                           });
//                                         },
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                     ),
//                     SizedBox(height: SizeConfig.h(0.024)),
//                     const _FieldTitle(title: 'النتيجة'),
//                     SizedBox(height: SizeConfig.h(0.008)),
//                     CustomTextWidget(
//                       _buildResultText(),
//                       fontSize: SizeConfig.text(0.034),
//                       fontWeight: FontWeight.w500,
//                       color: AppPalette.greyMedium,
//                       textAlign: TextAlign.right,
//                       maxLines: 2,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _ConfirmButton(enabled: _canConfirm, onTap: _confirm),
//           ],
//         ),
//       ),
//     );
//   }

//   void _changePattern(StudyTaskRepeatPattern pattern) {
//     setState(() {
//       _selectedPattern = pattern;

//       /*
//        * نمسح اليوم فقط عند اختيار عدم التكرار.
//        *
//        * أما عند الانتقال من أسبوعي إلى كل أسبوعين
//        * مثلًا، فنحافظ على اليوم الحالي.
//        */
//       if (!_requiresWeekday) {
//         _selectedWeekday = null;
//       }
//     });
//   }

//   String _buildResultText() {
//     if (!_requiresWeekday) {
//       return 'لن يتم تكرار المهمة.';
//     }

//     final weekdayText = _weekdays[_selectedWeekday];

//     if (weekdayText == null) {
//       return 'اختر يوم تكرار المهمة.';
//     }

//     switch (_selectedPattern) {
//       case StudyTaskRepeatPattern.none:
//         return 'لن يتم تكرار المهمة.';

//       case StudyTaskRepeatPattern.weekly:
//         return 'سيتم تكرار المهمة كل أسبوع يوم $weekdayText.';

//       case StudyTaskRepeatPattern.everyTwoWeeks:
//         return 'سيتم تكرار المهمة كل أسبوعين يوم $weekdayText.';

//       case StudyTaskRepeatPattern.everyThreeWeeks:
//         return 'سيتم تكرار المهمة كل 3 أسابيع يوم $weekdayText.';

//       case StudyTaskRepeatPattern.everyFourWeeks:
//         return 'سيتم تكرار المهمة كل 4 أسابيع يوم $weekdayText.';
//     }
//   }

//   void _confirm() {
//     if (!_canConfirm) {
//       return;
//     }

//     Navigator.of(context).pop(
//       StudyTaskRepeatDialogResult(
//         pattern: _selectedPattern,
//         weekday: _requiresWeekday ? _selectedWeekday : null,
//       ),
//     );
//   }

//   static bool _isValidWeekday(int? value) {
//     return value != null && value >= 0 && value <= 6;
//   }
// }

// class _DialogHeader extends StatelessWidget {
//   final bool isDark;
//   final VoidCallback onCloseTap;

//   const _DialogHeader({required this.isDark, required this.onCloseTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsetsDirectional.fromSTEB(
//         SizeConfig.w(0.025),
//         SizeConfig.h(0.012),
//         SizeConfig.w(0.040),
//         SizeConfig.h(0.012),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CustomTextWidget(
//             'التكرار',
//             fontSize: SizeConfig.text(0.042),
//             fontWeight: FontWeight.w800,
//             color: isDark
//                 ? AppPalette.textWhiteINDark
//                 : AppPalette.textColorInHome,
//             textAlign: TextAlign.center,
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: IconButton(
//               onPressed: onCloseTap,
//               icon: const Icon(Icons.close_rounded),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FieldTitle extends StatelessWidget {
//   final String title;

//   const _FieldTitle({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return CustomTextWidget(
//       title,
//       fontSize: SizeConfig.text(0.034),
//       fontWeight: FontWeight.w700,
//       color: isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome,
//       textAlign: TextAlign.right,
//     );
//   }
// }

// class _SelectionChip extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _SelectionChip({
//     required this.title,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Material(
//       color: isSelected
//           ? colorScheme.primary.withValues(alpha: 0.12)
//           : colorScheme.surface,
//       borderRadius: BorderRadius.circular(7),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(7),
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: SizeConfig.w(0.025),
//             vertical: SizeConfig.h(0.008),
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(7),
//             border: Border.all(
//               color: isSelected
//                   ? colorScheme.primary
//                   : colorScheme.outlineVariant,
//               width: isSelected ? 1.4 : 1,
//             ),
//           ),
//           child: CustomTextWidget(
//             title,
//             fontSize: SizeConfig.text(0.030),
//             fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
//             color: isSelected
//                 ? colorScheme.primary
//                 : colorScheme.onSurfaceVariant,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ConfirmButton extends StatelessWidget {
//   final bool enabled;
//   final VoidCallback onTap;

//   const _ConfirmButton({required this.enabled, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(
//         SizeConfig.w(0.040),
//         SizeConfig.h(0.012),
//         SizeConfig.w(0.040),
//         SizeConfig.h(0.020),
//       ),
//       child: SizedBox(
//         width: double.infinity,
//         height: SizeConfig.h(0.052),
//         child: FilledButton(
//           onPressed: enabled ? onTap : null,
//           child: const Text('تأكيد'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/create_study_task/create_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_repeat_section.dart';

class CreateStudyTaskRepeatSection extends StatelessWidget {
  const CreateStudyTaskRepeatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateStudyTaskCubit, CreateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.repeatPattern != current.repeatPattern ||
            previous.repeatWeekday != current.repeatWeekday;
      },
      builder: (context, state) {
        final cubit = context.read<CreateStudyTaskCubit>();

        return StudyTaskRepeatSection(
          repeatPattern: state.repeatPattern,
          repeatWeekday: state.repeatWeekday,
          sectionDescription:
              'حدد نمط التكرار واليوم الذي تريد تكرار المهمة فيه.',
          onRepeatChanged: (pattern, weekday) {
            cubit.changeRepeatPattern(pattern);

            if (pattern != StudyTaskRepeatPattern.none && weekday != null) {
              cubit.changeRepeatWeekday(weekday);
            }
          },
        );
      },
    );
  }
}
