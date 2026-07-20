import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/show_study_task_time_picker.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/study_task_duration_bottom_sheet.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/study_task_priority_bottom_sheet.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/options/study_task_reminder_bottom_sheet.dart';

class StudyTaskOptionsSection extends StatelessWidget {
  final String startTime;
  final int? durationMinutes;
  final StudyTaskPriority? priority;
  final int? reminderOffsetMinutes;

  final ValueChanged<String> onStartTimeChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<StudyTaskPriority> onPriorityChanged;
  final ValueChanged<int?> onReminderChanged;

  final String sectionDescription;

  const StudyTaskOptionsSection({
    super.key,
    required this.startTime,
    required this.durationMinutes,
    required this.priority,
    required this.reminderOffsetMinutes,
    required this.onStartTimeChanged,
    required this.onDurationChanged,
    required this.onPriorityChanged,
    required this.onReminderChanged,
    this.sectionDescription =
        'حدد وقت البداية ومدة المهمة وأولويتها وموعد التذكير.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudyPlanFormSectionHeader(
          title: 'إعدادات المهمة',
          description: sectionDescription,
          image: AppImage.timer,
        ),
        SizedBox(height: SizeConfig.h(0.016)),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: StudyPlanSelectionBox(
                title: 'وقت البداية',
                value: startTime.trim().isEmpty
                    ? null
                    : formatStudyTaskTime(startTime),
                icon: Icons.access_time_rounded,
                onTap: () {
                  _selectStartTime(context);
                },
              ),
            ),
            SizedBox(width: SizeConfig.w(0.025)),
            Expanded(
              child: StudyPlanSelectionBox(
                title: 'مدة المهمة',
                value: durationMinutes == null
                    ? null
                    : formatStudyTaskDuration(durationMinutes!),
                icon: Icons.timer_outlined,
                onTap: () {
                  _selectDuration(context);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.h(0.014)),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: StudyPlanSelectionBox(
                title: 'أولوية المهمة',
                value: priority?.apiValue,
                icon: Icons.flag_outlined,
                onTap: () {
                  _selectPriority(context);
                },
              ),
            ),
            SizedBox(width: SizeConfig.w(0.025)),
            Expanded(
              child: StudyPlanSelectionBox(
                title: 'التذكير',
                value: formatStudyTaskReminder(reminderOffsetMinutes),
                icon: Icons.notifications_outlined,
                onTap: () {
                  _selectReminder(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final selectedTime = await showStudyTaskTimePicker(
      context: context,
      currentTime: startTime,
    );

    if (selectedTime == null || !context.mounted) {
      return;
    }

    onStartTimeChanged(selectedTime);
  }

  Future<void> _selectDuration(BuildContext context) async {
    final selectedDuration = await showStudyTaskDurationBottomSheet(
      context: context,
      selectedDuration: durationMinutes,
    );

    if (selectedDuration == null || !context.mounted) {
      return;
    }

    onDurationChanged(selectedDuration);
  }

  Future<void> _selectPriority(BuildContext context) async {
    final selectedPriority = await showStudyTaskPriorityBottomSheet(
      context: context,
      selectedPriority: priority,
    );

    if (selectedPriority == null || !context.mounted) {
      return;
    }

    onPriorityChanged(selectedPriority);
  }

  Future<void> _selectReminder(BuildContext context) async {
    final selection = await showStudyTaskReminderBottomSheet(
      context: context,
      selectedReminder: reminderOffsetMinutes,
    );

    if (selection == null || !context.mounted) {
      return;
    }

    onReminderChanged(selection.minutes);
  }
}
