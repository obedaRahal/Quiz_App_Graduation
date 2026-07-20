// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
// import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';

// class UpdateStudyTaskOptionsSection extends StatelessWidget {
//   const UpdateStudyTaskOptionsSection({super.key});

//   static const List<int> _durationOptions = [
//     10,
//     15,
//     20,
//     30,
//     45,
//     60,
//     90,
//     120,
//     180,
//     240,
//     300,
//     360,
//     480,
//     600,
//     720,
//   ];

//   static const List<int?> _reminderOptions = [
//     null,
//     0,
//     5,
//     15,
//     30,
//     45,
//     60,
//     120,
//     240,
//     720,
//     1440,
//     2880,
//     10080,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
//       buildWhen: (previous, current) {
//         return previous.startTime != current.startTime ||
//             previous.durationMinutes != current.durationMinutes ||
//             previous.priority != current.priority ||
//             previous.reminderOffsetMinutes != current.reminderOffsetMinutes;
//       },
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             StudyPlanFormSectionHeader(
//               title: 'إعدادات المهمة',
//               description:
//                   'عدّل وقت البداية ومدة المهمة وأولويتها وموعد التذكير المناسب.',
//               image: AppImage.timer,
//             ),

//             SizedBox(height: SizeConfig.h(0.016)),

//             Row(
//               textDirection: TextDirection.rtl,
//               children: [
//                 Expanded(
//                   child: StudyPlanSelectionBox(
//                     title: 'وقت البداية',
//                     value: state.startTime.trim().isEmpty
//                         ? null
//                         : _formatTimeForDisplay(state.startTime),
//                     icon: Icons.access_time_rounded,
//                     onTap: () {
//                       _selectStartTime(context, state);
//                     },
//                   ),
//                 ),

//                 SizedBox(width: SizeConfig.w(0.025)),

//                 Expanded(
//                   child: StudyPlanSelectionBox(
//                     title: 'مدة المهمة',
//                     value: state.durationMinutes == null
//                         ? null
//                         : _formatDuration(state.durationMinutes!),
//                     icon: Icons.timer_outlined,
//                     onTap: () {
//                       _showDurationSheet(context, state.durationMinutes);
//                     },
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: SizeConfig.h(0.014)),

//             Row(
//               textDirection: TextDirection.rtl,
//               children: [
//                 Expanded(
//                   child: StudyPlanSelectionBox(
//                     title: 'أولوية المهمة',
//                     value: state.priority?.apiValue,
//                     icon: Icons.flag_outlined,
//                     onTap: () {
//                       _showPrioritySheet(context, state.priority);
//                     },
//                   ),
//                 ),

//                 SizedBox(width: SizeConfig.w(0.025)),

//                 Expanded(
//                   child: StudyPlanSelectionBox(
//                     title: 'التذكير',
//                     value: _formatReminder(state.reminderOffsetMinutes),
//                     icon: Icons.notifications_outlined,
//                     onTap: () {
//                       _showReminderSheet(context, state.reminderOffsetMinutes);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _selectStartTime(
//     BuildContext context,
//     UpdateStudyTaskState state,
//   ) async {
//     final initialTime = _parseTime(state.startTime) ?? TimeOfDay.now();

//     final selectedTime = await showTimePicker(
//       context: context,
//       initialTime: initialTime,
//       helpText: 'اختر وقت بداية المهمة',
//       cancelText: 'إلغاء',
//       confirmText: 'اختيار',
//     );

//     if (selectedTime == null || !context.mounted) {
//       return;
//     }

//     final formattedTime =
//         '${selectedTime.hour.toString().padLeft(2, '0')}:'
//         '${selectedTime.minute.toString().padLeft(2, '0')}';

//     debugPrint('============ Update Study Task Start Time ============');
//     debugPrint('→ selected time: $formattedTime');
//     debugPrint('=====================================================');

//     context.read<UpdateStudyTaskCubit>().startTimeChanged(formattedTime);
//   }

//   Future<void> _showDurationSheet(
//     BuildContext context,
//     int? selectedDuration,
//   ) async {
//     final value = await showModalBottomSheet<int>(
//       context: context,
//       showDragHandle: true,
//       builder: (sheetContext) {
//         return _SelectionBottomSheet<int>(
//           title: 'مدة المهمة',
//           values: _durationOptions,
//           selectedValue: selectedDuration,
//           labelBuilder: _formatDuration,
//         );
//       },
//     );

//     if (value == null || !context.mounted) {
//       return;
//     }

//     context.read<UpdateStudyTaskCubit>().durationChanged(value);
//   }

//   Future<void> _showPrioritySheet(
//     BuildContext context,
//     StudyTaskPriority? selectedPriority,
//   ) async {
//     final value = await showModalBottomSheet<StudyTaskPriority>(
//       context: context,
//       showDragHandle: true,
//       builder: (sheetContext) {
//         return _SelectionBottomSheet<StudyTaskPriority>(
//           title: 'أولوية المهمة',
//           values: selectableStudyTaskPriorities,
//           selectedValue: selectedPriority,
//           labelBuilder: (priority) {
//             return priority.apiValue;
//           },
//         );
//       },
//     );

//     if (value == null || !context.mounted) {
//       return;
//     }

//     context.read<UpdateStudyTaskCubit>().priorityChanged(value);
//   }

//   Future<void> _showReminderSheet(
//     BuildContext context,
//     int? selectedReminder,
//   ) async {
//     /*
//      * نستخدم _ReminderResult بدل إعادة int? مباشرة.
//      *
//      * لأن null قد تعني أحد أمرين:
//      * 1- المستخدم أغلق النافذة.
//      * 2- المستخدم اختار "بدون تذكير".
//      *
//      * التغليف يسمح لنا بالتمييز بين الحالتين.
//      */
//     final result = await showModalBottomSheet<_ReminderResult>(
//       context: context,
//       showDragHandle: true,
//       builder: (sheetContext) {
//         return SafeArea(
//           top: false,
//           child: ListView(
//             shrinkWrap: true,
//             padding: const EdgeInsets.only(bottom: 16),
//             children: [
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 14),
//                 child: Text(
//                   'التذكير قبل المهمة',
//                   style: Theme.of(
//                     sheetContext,
//                   ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
//                 ),
//               ),

//               ..._reminderOptions.map((minutes) {
//                 final isSelected = selectedReminder == minutes;

//                 return ListTile(
//                   onTap: () {
//                     Navigator.of(
//                       sheetContext,
//                     ).pop(_ReminderResult(minutes: minutes));
//                   },
//                   leading: Icon(
//                     isSelected
//                         ? Icons.radio_button_checked_rounded
//                         : Icons.radio_button_unchecked_rounded,
//                   ),
//                   title: Text(_formatReminder(minutes)),
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );

//     if (result == null || !context.mounted) {
//       return;
//     }

//     context.read<UpdateStudyTaskCubit>().reminderChanged(result.minutes);
//   }

//   static TimeOfDay? _parseTime(String value) {
//     final normalized = value.trim();

//     final parts = normalized.split(':');

//     if (parts.length < 2) {
//       return null;
//     }

//     final hour = int.tryParse(parts[0]);
//     final minute = int.tryParse(parts[1]);

//     if (hour == null ||
//         minute == null ||
//         hour < 0 ||
//         hour > 23 ||
//         minute < 0 ||
//         minute > 59) {
//       return null;
//     }

//     return TimeOfDay(hour: hour, minute: minute);
//   }

//   static String _formatTimeForDisplay(String value) {
//     final time = _parseTime(value);

//     if (time == null) {
//       return value;
//     }

//     final period = time.hour >= 12 ? 'م' : 'ص';

//     var hour = time.hour % 12;

//     if (hour == 0) {
//       hour = 12;
//     }

//     final minute = time.minute.toString().padLeft(2, '0');

//     return '$hour:$minute $period';
//   }

//   static String _formatDuration(int minutes) {
//     if (minutes < 60) {
//       return '$minutes دقيقة';
//     }

//     if (minutes % 60 == 0) {
//       final hours = minutes ~/ 60;

//       if (hours == 1) {
//         return 'ساعة واحدة';
//       }

//       if (hours == 2) {
//         return 'ساعتان';
//       }

//       return '$hours ساعات';
//     }

//     final hours = minutes ~/ 60;
//     final remainingMinutes = minutes % 60;

//     return '$hours ساعة و$remainingMinutes دقيقة';
//   }

//   static String _formatReminder(int? minutes) {
//     if (minutes == null) {
//       return 'بدون تذكير';
//     }

//     switch (minutes) {
//       case 0:
//         return 'عند بداية المهمة';

//       case 5:
//         return 'قبل 5 دقائق';

//       case 15:
//         return 'قبل 15 دقيقة';

//       case 30:
//         return 'قبل 30 دقيقة';

//       case 45:
//         return 'قبل 45 دقيقة';

//       case 60:
//         return 'قبل ساعة';

//       case 120:
//         return 'قبل ساعتين';

//       case 240:
//         return 'قبل 4 ساعات';

//       case 720:
//         return 'قبل 12 ساعة';

//       case 1440:
//         return 'قبل يوم';

//       case 2880:
//         return 'قبل يومين';

//       case 10080:
//         return 'قبل أسبوع';

//       default:
//         return 'قبل $minutes دقيقة';
//     }
//   }
// }

// class _SelectionBottomSheet<T> extends StatelessWidget {
//   final String title;
//   final List<T> values;
//   final T? selectedValue;
//   final String Function(T value) labelBuilder;

//   const _SelectionBottomSheet({
//     required this.title,
//     required this.values,
//     required this.selectedValue,
//     required this.labelBuilder,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: ListView(
//         shrinkWrap: true,
//         padding: const EdgeInsets.only(bottom: 16),
//         children: [
//           Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 14),
//             child: Text(
//               title,
//               style: Theme.of(
//                 context,
//               ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
//             ),
//           ),

//           ...values.map((value) {
//             final isSelected = value == selectedValue;

//             return ListTile(
//               onTap: () {
//                 Navigator.of(context).pop(value);
//               },
//               leading: Icon(
//                 isSelected
//                     ? Icons.radio_button_checked_rounded
//                     : Icons.radio_button_unchecked_rounded,
//               ),
//               title: Text(labelBuilder(value)),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// class _ReminderResult {
//   final int? minutes;

//   const _ReminderResult({required this.minutes});
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/study_task_options_section.dart';

class UpdateStudyTaskOptionsSection extends StatelessWidget {
  const UpdateStudyTaskOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.startTime != current.startTime ||
            previous.durationMinutes != current.durationMinutes ||
            previous.priority != current.priority ||
            previous.reminderOffsetMinutes != current.reminderOffsetMinutes;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        return StudyTaskOptionsSection(
          startTime: state.startTime,
          durationMinutes: state.durationMinutes,
          priority: state.priority,
          reminderOffsetMinutes: state.reminderOffsetMinutes,
          sectionDescription:
              'عدّل وقت البداية والمدة والأولوية وموعد التذكير.',
          onStartTimeChanged: cubit.startTimeChanged,
          onDurationChanged: cubit.durationChanged,
          onPriorityChanged: cubit.priorityChanged,
          onReminderChanged: cubit.reminderChanged,
        );
      },
    );
  }
}
