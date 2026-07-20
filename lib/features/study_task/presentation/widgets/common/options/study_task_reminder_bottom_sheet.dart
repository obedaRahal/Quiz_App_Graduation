import 'package:flutter/material.dart';

const List<int?> studyTaskReminderOptions = [
  null,
  0,
  5,
  15,
  30,
  45,
  60,
  120,
  240,
  720,
  1440,
  2880,
  10080,
];

class StudyTaskReminderSelection {
  final int? minutes;

  const StudyTaskReminderSelection({required this.minutes});
}

Future<StudyTaskReminderSelection?> showStudyTaskReminderBottomSheet({
  required BuildContext context,
  required int? selectedReminder,
}) {
  return showModalBottomSheet<StudyTaskReminderSelection>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        top: false,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 14),
              child: Text(
                'التذكير قبل المهمة',
                textAlign: TextAlign.right,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            ...studyTaskReminderOptions.map((minutes) {
              final isSelected = selectedReminder == minutes;

              return ListTile(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pop(StudyTaskReminderSelection(minutes: minutes));
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(
                  formatStudyTaskReminder(minutes),
                  textAlign: TextAlign.right,
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}

String formatStudyTaskReminder(int? minutes) {
  switch (minutes) {
    case null:
      return 'بدون تذكير';
    case 0:
      return 'عند بداية المهمة';
    case 5:
      return 'قبل 5 دقائق';
    case 15:
      return 'قبل 15 دقيقة';
    case 30:
      return 'قبل 30 دقيقة';
    case 45:
      return 'قبل 45 دقيقة';
    case 60:
      return 'قبل ساعة';
    case 120:
      return 'قبل ساعتين';
    case 240:
      return 'قبل 4 ساعات';
    case 720:
      return 'قبل 12 ساعة';
    case 1440:
      return 'قبل يوم';
    case 2880:
      return 'قبل يومين';
    case 10080:
      return 'قبل أسبوع';
    default:
      return 'قبل $minutes دقيقة';
  }
}
