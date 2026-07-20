import 'package:flutter/material.dart';

Future<String?> showStudyTaskTimePicker({
  required BuildContext context,
  required String currentTime,
}) async {
  final initialTime = parseStudyTaskTime(currentTime) ?? TimeOfDay.now();

  final selectedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
    helpText: 'اختر وقت بداية المهمة',
    cancelText: 'إلغاء',
    confirmText: 'اختيار',
  );

  if (selectedTime == null) {
    return null;
  }

  final hour = selectedTime.hour.toString().padLeft(2, '0');

  final minute = selectedTime.minute.toString().padLeft(2, '0');

  return '$hour:$minute';
}

TimeOfDay? parseStudyTaskTime(String value) {
  final normalizedValue = value.trim();

  if (normalizedValue.isEmpty) {
    return null;
  }

  final parts = normalizedValue.split(':');

  if (parts.length < 2) {
    return null;
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null ||
      minute == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59) {
    return null;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

String formatStudyTaskTime(String value) {
  final time = parseStudyTaskTime(value);

  if (time == null) {
    return value;
  }

  final period = time.hour >= 12 ? 'م' : 'ص';

  var displayedHour = time.hour % 12;

  if (displayedHour == 0) {
    displayedHour = 12;
  }

  final minute = time.minute.toString().padLeft(2, '0');

  return '$displayedHour:$minute $period';
}
