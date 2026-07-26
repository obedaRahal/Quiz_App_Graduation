import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/services/app_date_time_settings.dart';
import 'package:quiz_app_grad/core/utils/app_time_formatter.dart';

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
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(alwaysUse24HourFormat: AppDateTimeSettings.use24HourFormat),
        child: child ?? const SizedBox.shrink(),
      );
    },
  );

  if (selectedTime == null) {
    return null;
  }

  return AppTimeFormatter.toApiValue(selectedTime);
}

TimeOfDay? parseStudyTaskTime(String value) {
  return AppTimeFormatter.tryParse(value);
}

String formatStudyTaskTime(String value) {
  return AppTimeFormatter.format(value);
}
