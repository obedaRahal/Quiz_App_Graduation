import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/repeat/study_task_repeat_dialog.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/repeat/study_task_weekday_selector.dart';

class StudyTaskRepeatSection extends StatelessWidget {
  final StudyTaskRepeatPattern repeatPattern;
  final int? repeatWeekday;

  final void Function(StudyTaskRepeatPattern pattern, int? weekday)
  onRepeatChanged;

  final String sectionDescription;

  /// نستخدمها في شاشة التعديل عندما يعيد الخادم
  /// نمط التكرار دون يوم التكرار.
  final bool showMissingWeekdayWarning;

  const StudyTaskRepeatSection({
    super.key,
    required this.repeatPattern,
    required this.repeatWeekday,
    required this.onRepeatChanged,
    this.sectionDescription = 'حدد ما إذا كنت تريد تكرار المهمة في يوم معين.',
    this.showMissingWeekdayWarning = false,
  });

  bool get _hasMissingWeekday {
    return repeatPattern != StudyTaskRepeatPattern.none &&
        repeatWeekday == null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudyPlanFormSectionHeader(
          title: 'تكرار المهمة',
          description: sectionDescription,
          image: AppImage.reportedIcon,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        StudyPlanSelectionBox(
          title: 'نمط التكرار',
          value: formatStudyTaskRepeatValue(
            pattern: repeatPattern,
            weekday: repeatWeekday,
          ),
          icon: Icons.repeat_rounded,
          onTap: () {
            _selectRepeat(context);
          },
        ),

        if (showMissingWeekdayWarning && _hasMissingWeekday) ...[
          SizedBox(height: SizeConfig.h(0.010)),

          Text(
            'الخادم لم يُعد يوم التكرار لهذه المهمة. '
            'اختر اليوم عند تعديل إعدادات التكرار.',
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _selectRepeat(BuildContext context) async {
    final result = await showStudyTaskRepeatDialog(
      context: context,
      initialPattern: repeatPattern,
      initialWeekday: repeatWeekday,
    );

    if (result == null || !context.mounted) {
      return;
    }

    onRepeatChanged(result.pattern, result.weekday);
  }
}

String formatStudyTaskRepeatValue({
  required StudyTaskRepeatPattern pattern,
  required int? weekday,
}) {
  if (pattern == StudyTaskRepeatPattern.none) {
    return pattern.apiValue;
  }

  final weekdayLabel = studyTaskWeekdays[weekday];

  if (weekdayLabel == null) {
    return '${pattern.apiValue} - اختر اليوم';
  }

  return '${pattern.apiValue} - $weekdayLabel';
}
