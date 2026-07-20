import 'package:flutter/material.dart';

const List<int> studyTaskDurationOptions = [
  10,
  15,
  20,
  30,
  45,
  60,
  90,
  120,
  180,
  240,
  300,
  360,
  480,
  600,
  720,
];

Future<int?> showStudyTaskDurationBottomSheet({
  required BuildContext context,
  required int? selectedDuration,
}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        top: false,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            const _BottomSheetTitle(title: 'مدة المهمة'),
            ...studyTaskDurationOptions.map((duration) {
              final isSelected = duration == selectedDuration;

              return ListTile(
                onTap: () {
                  Navigator.of(context).pop(duration);
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(
                  formatStudyTaskDuration(duration),
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

String formatStudyTaskDuration(int minutes) {
  if (minutes < 60) {
    return '$minutes دقيقة';
  }

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (remainingMinutes == 0) {
    switch (hours) {
      case 1:
        return 'ساعة واحدة';
      case 2:
        return 'ساعتان';
      default:
        return '$hours ساعات';
    }
  }

  return '$hours ساعة و$remainingMinutes دقيقة';
}

class _BottomSheetTitle extends StatelessWidget {
  final String title;

  const _BottomSheetTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 14),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
