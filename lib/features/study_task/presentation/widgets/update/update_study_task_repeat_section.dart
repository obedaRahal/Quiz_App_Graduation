// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
// import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
// import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
// import 'package:quiz_app_grad/features/study_task/presentation/widgets/create/create_study_task_repeat_section.dart'
//     show StudyTaskRepeatDialogResult, showSelectStudyTaskRepeatDialog;

// class UpdateStudyTaskRepeatSection extends StatelessWidget {
//   const UpdateStudyTaskRepeatSection({super.key});

//   static const Map<int, String> _weekdays = {
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
//     return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
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
//               description: 'عدّل نمط تكرار المهمة وحدد يوم التكرار عند الحاجة.',
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

//             /*
//              * الـBackend يعيد نمط التكرار لكنه لا يعيد اليوم.
//              * لذلك نظهر تنبيهًا صغيرًا عند وجود تكرار دون يوم.
//              */
//             if (state.repeatPattern != StudyTaskRepeatPattern.none &&
//                 state.repeatWeekday == null) ...[
//               SizedBox(height: SizeConfig.h(0.010)),
//               Text(
//                 'يجب اختيار يوم التكرار قبل حفظ أي تعديل على التكرار.',
//                 textAlign: TextAlign.right,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                   color: Theme.of(context).colorScheme.error,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _openRepeatDialog(
//     BuildContext context,
//     UpdateStudyTaskState state,
//   ) async {
//     debugPrint(
//       '============ Open Update Study Task Repeat Dialog ============',
//     );
//     debugPrint('→ current pattern: ${state.repeatPattern}');
//     debugPrint('→ current weekday: ${state.repeatWeekday}');

//     final StudyTaskRepeatDialogResult? result =
//         await showSelectStudyTaskRepeatDialog(
//           context,
//           initialPattern: state.repeatPattern,
//           initialWeekday: state.repeatWeekday,
//         );

//     if (result == null || !context.mounted) {
//       debugPrint('→ repeat selection cancelled');
//       return;
//     }

//     debugPrint('→ selected pattern: ${result.pattern}');
//     debugPrint('→ selected weekday: ${result.weekday}');
//     debugPrint(
//       '================================================================',
//     );

//     final cubit = context.read<UpdateStudyTaskCubit>();

//     /*
//      * يجب تنفيذ تغيير النمط أولًا، لأنه يمسح اليوم.
//      * ثم نعيد وضع اليوم المختار إن كان التكرار فعالًا.
//      */
//     cubit.repeatPatternChanged(result.pattern);

//     if (result.pattern == StudyTaskRepeatPattern.none) {
//       /*
//        * إذا كان النمط نفسه none فلن يصدر repeatPatternChanged
//        * حالة جديدة، لذلك نتأكد يدويًا من مسح اليوم.
//        */
//       cubit.repeatWeekdayChanged(null);
//       return;
//     }

//     cubit.repeatWeekdayChanged(result.weekday);
//   }

//   static String _formatRepeatValue({
//     required StudyTaskRepeatPattern pattern,
//     required int? weekday,
//   }) {
//     if (pattern == StudyTaskRepeatPattern.none) {
//       return pattern.apiValue;
//     }

//     final weekdayText = _weekdays[weekday];

//     if (weekdayText == null) {
//       return '${pattern.apiValue} - اختر اليوم';
//     }

//     return '${pattern.apiValue} - $weekdayText';
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_cubit.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/update_study_task/update_study_task_state.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/study_task_repeat_section.dart';

class UpdateStudyTaskRepeatSection extends StatelessWidget {
  const UpdateStudyTaskRepeatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateStudyTaskCubit, UpdateStudyTaskState>(
      buildWhen: (previous, current) {
        return previous.repeatPattern != current.repeatPattern ||
            previous.repeatWeekday != current.repeatWeekday;
      },
      builder: (context, state) {
        final cubit = context.read<UpdateStudyTaskCubit>();

        return StudyTaskRepeatSection(
          repeatPattern: state.repeatPattern,
          repeatWeekday: state.repeatWeekday,
          showMissingWeekdayWarning: true,
          sectionDescription: 'عدّل نمط التكرار وحدد يوم التكرار عند الحاجة.',
          onRepeatChanged: (pattern, weekday) {
            /*
             * repeatPatternChanged يمسح اليوم،
             * لذلك يجب استدعاؤه أولًا.
             */
            cubit.repeatPatternChanged(pattern);

            cubit.repeatWeekdayChanged(
              pattern == StudyTaskRepeatPattern.none ? null : weekday,
            );
          },
        );
      },
    );
  }
}
