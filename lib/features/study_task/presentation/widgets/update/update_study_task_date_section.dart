// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
// import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';

// class UpdateStudyTaskDateSection extends StatelessWidget {
//   const UpdateStudyTaskDateSection({super.key});

//   /// المدة القصوى للمهمة شاملة
//   /// تاريخ البداية والنهاية.
//   static const int _maxTaskRangeDays = 7;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
//       buildWhen: (previous, current) {
//         return previous.startDate != current.startDate ||
//             previous.endDate != current.endDate;
//       },
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             StudyPlanFormSectionHeader(
//               title: 'تاريخ ومدة المهمة',
//               description:
//                   'عدّل تاريخ بداية ونهاية المهمة، على ألا تتجاوز مدتها 7 أيام.',
//               image: AppImage.stopwatch,
//             ),

//             SizedBox(height: SizeConfig.h(0.016)),

//             Row(
//               textDirection: TextDirection.rtl,
//               children: [
//                 Expanded(
//                   child: StudyPlanSelectionBox(
//                     title: 'من',
//                     value: state.startDate == null
//                         ? null
//                         : _formatDate(state.startDate!),
//                     icon: Icons.calendar_month_outlined,
//                     onTap: () {
//                       _selectStartDate(context, state);
//                     },
//                   ),
//                 ),

//                 SizedBox(width: SizeConfig.w(0.025)),

//                 const Icon(
//                   Icons.arrow_back_rounded,
//                   color: AppPalette.greyMedium,
//                 ),

//                 SizedBox(width: SizeConfig.w(0.025)),

//                 Expanded(
//                   child: StudyPlanSelectionBox(
//                     title: 'إلى',
//                     value: state.endDate == null
//                         ? null
//                         : _formatDate(state.endDate!),
//                     icon: Icons.calendar_month_outlined,
//                     onTap: () {
//                       _selectEndDate(context, state);
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

//   Future<void> _selectStartDate(
//     BuildContext context,
//     UpdateStudyTaskState state,
//   ) async {
//     final today = _normalizeDate(DateTime.now());

//     final lastAllowedDate = DateTime(today.year + 10, 12, 31);

//     /*
//      * في حال كان التاريخ الحالي قديمًا،
//      * لا يمكن استخدامه مباشرة مع firstDate = today.
//      *
//      * لذلك نجعل initialDate اليوم.
//      */
//     var initialDate = state.startDate ?? today;

//     initialDate = _normalizeDate(initialDate);

//     initialDate = _clampDate(
//       date: initialDate,
//       firstDate: today,
//       lastDate: lastAllowedDate,
//     );

//     debugPrint(
//       '============ '
//       'Select Update Study Task Start Date '
//       '============',
//     );

//     debugPrint(
//       '→ current start date: '
//       '${state.startDate}',
//     );

//     debugPrint(
//       '→ current end date: '
//       '${state.endDate}',
//     );

//     debugPrint(
//       '→ picker initial date: '
//       '$initialDate',
//     );

//     debugPrint('→ picker first date: $today');

//     debugPrint(
//       '→ picker last date: '
//       '$lastAllowedDate',
//     );

//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: today,
//       lastDate: lastAllowedDate,
//       helpText: 'اختر تاريخ بداية المهمة',
//       cancelText: 'إلغاء',
//       confirmText: 'اختيار',
//     );

//     if (selectedDate == null || !context.mounted) {
//       debugPrint('→ start date selection cancelled');

//       return;
//     }

//     final normalizedDate = _normalizeDate(selectedDate);

//     debugPrint(
//       '→ selected start date: '
//       '$normalizedDate',
//     );

//     debugPrint('====================================================');

//     final cubit = context.read<UpdateStudyTaskCubit>();

//     cubit.startDateChanged(normalizedDate);

//     /*
//      * إذا أصبحت النهاية قبل البداية الجديدة،
//      * نعيد ضبط النهاية لتساوي البداية.
//      *
//      * هذا يمنع بقاء النموذج في حالة غير صالحة.
//      */
//     final currentEndDate = cubit.state.endDate;

//     if (currentEndDate != null &&
//         _normalizeDate(currentEndDate).isBefore(normalizedDate)) {
//       cubit.endDateChanged(normalizedDate);

//       return;
//     }

//     /*
//      * إذا تجاوزت النهاية الحد الأقصى
//      * بعد تغيير البداية، نضبطها على اليوم السابع.
//      */
//     if (currentEndDate != null) {
//       final lastAllowedEndDate = normalizedDate.add(
//         const Duration(days: _maxTaskRangeDays - 1),
//       );

//       if (_normalizeDate(currentEndDate).isAfter(lastAllowedEndDate)) {
//         cubit.endDateChanged(lastAllowedEndDate);
//       }
//     }
//   }

//   Future<void> _selectEndDate(
//     BuildContext context,
//     UpdateStudyTaskState state,
//   ) async {
//     final startDate = state.startDate;

//     if (startDate == null) {
//       showValidationTopSnackBar(
//         context,
//         title: 'تنبيه',
//         message: 'يرجى اختيار تاريخ بداية المهمة أولًا',
//         type: AppValidationSnackBarType.error,
//       );

//       return;
//     }

//     final normalizedStartDate = _normalizeDate(startDate);

//     final lastAllowedEndDate = normalizedStartDate.add(
//       const Duration(days: _maxTaskRangeDays - 1),
//     );

//     var initialDate = state.endDate ?? normalizedStartDate;

//     initialDate = _normalizeDate(initialDate);

//     initialDate = _clampDate(
//       date: initialDate,
//       firstDate: normalizedStartDate,
//       lastDate: lastAllowedEndDate,
//     );

//     debugPrint(
//       '============ '
//       'Select Update Study Task End Date '
//       '============',
//     );

//     debugPrint(
//       '→ start date: '
//       '$normalizedStartDate',
//     );

//     debugPrint(
//       '→ current end date: '
//       '${state.endDate}',
//     );

//     debugPrint(
//       '→ picker initial date: '
//       '$initialDate',
//     );

//     debugPrint(
//       '→ picker first date: '
//       '$normalizedStartDate',
//     );

//     debugPrint(
//       '→ picker last date: '
//       '$lastAllowedEndDate',
//     );

//     final selectedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: normalizedStartDate,
//       lastDate: lastAllowedEndDate,
//       helpText: 'اختر تاريخ نهاية المهمة',
//       cancelText: 'إلغاء',
//       confirmText: 'اختيار',
//     );

//     if (selectedDate == null || !context.mounted) {
//       debugPrint('→ end date selection cancelled');

//       return;
//     }

//     final normalizedDate = _normalizeDate(selectedDate);

//     debugPrint(
//       '→ selected end date: '
//       '$normalizedDate',
//     );

//     debugPrint('==================================================');

//     context.read<UpdateStudyTaskCubit>().endDateChanged(normalizedDate);
//   }

//   static DateTime _normalizeDate(DateTime date) {
//     return DateTime(date.year, date.month, date.day);
//   }

//   static DateTime _clampDate({
//     required DateTime date,
//     required DateTime firstDate,
//     required DateTime lastDate,
//   }) {
//     if (date.isBefore(firstDate)) {
//       return firstDate;
//     }

//     if (date.isAfter(lastDate)) {
//       return lastDate;
//     }

//     return date;
//   }

//   static String _formatDate(DateTime date) {
//     final normalizedDate = _normalizeDate(date);

//     final day = normalizedDate.day.toString().padLeft(2, '0');

//     final month = normalizedDate.month.toString().padLeft(2, '0');

//     final year = normalizedDate.year.toString();

//     return '$day/$month/$year';
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_date_section.dart';

class UpdateStudyTaskDateSection extends StatelessWidget {
  const UpdateStudyTaskDateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.startDate != current.startDate ||
            previous.endDate != current.endDate;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        final today = _normalizeDate(DateTime.now());

        final lastSelectableDate = DateTime(today.year + 10, 12, 31);

        return StudyTaskDateSection(
          startDate: state.startDate,
          endDate: state.endDate,

          /*
           * نعرض التاريخ القديم الموجود في state،
           * لكن عند فتح المنتقي يبدأ المجال من اليوم.
           *
           * الـWidget المشترك يقوم بعمل clamp
           * للـinitialDate لمنع assertion.
           */
          firstSelectableStartDate: today,

          lastSelectableStartDate: lastSelectableDate,

          maxRangeDays: 7,

          sectionDescription:
              'عدّل تاريخ بداية ونهاية المهمة، على ألا تتجاوز مدتها 7 أيام.',

          onStartDateChanged: cubit.startDateChanged,

          onEndDateChanged: cubit.endDateChanged,
        );
      },
    );
  }

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
