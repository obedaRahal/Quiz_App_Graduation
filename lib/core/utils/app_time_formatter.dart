import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/services/app_date_time_settings.dart';

class AppTimeFormatter {
  AppTimeFormatter._();

  static String format(String value, {bool? use24HourFormat}) {
    final time = tryParse(value);

    if (time == null) {
      return value;
    }

    return formatTimeOfDay(
      time,
      use24HourFormat: use24HourFormat ?? AppDateTimeSettings.use24HourFormat,
    );
  }

  static String formatTimeOfDay(TimeOfDay time, {bool? use24HourFormat}) {
    final shouldUse24Hours =
        use24HourFormat ?? AppDateTimeSettings.use24HourFormat;
    final minute = time.minute.toString().padLeft(2, '0');

    if (shouldUse24Hours) {
      final hour = time.hour.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final period = time.hour >= 12 ? 'م' : 'ص';
    final displayedHour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;

    return '$displayedHour:$minute $period';
  }

  static String toApiValue(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  static TimeOfDay? tryParse(String value) {
    var normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      return null;
    }

    final isPm = RegExp(
      r'(^|\s)(م|PM)(\s|$)',
      caseSensitive: false,
    ).hasMatch(normalizedValue);
    final isAm = RegExp(
      r'(^|\s)(ص|AM)(\s|$)',
      caseSensitive: false,
    ).hasMatch(normalizedValue);

    normalizedValue = normalizedValue
        .replaceAll(RegExp(r'\s*(ص|م|AM|PM)\s*', caseSensitive: false), '')
        .trim();

    final parts = normalizedValue.split(':');

    if (parts.length < 2) {
      return null;
    }

    var hour = int.tryParse(parts[0]);
    final minutePart = RegExp(r'^\d{1,2}').firstMatch(parts[1])?.group(0);
    final minute = int.tryParse(minutePart ?? '');

    if (hour == null || minute == null || minute < 0 || minute > 59) {
      return null;
    }

    if (isAm || isPm) {
      if (hour < 1 || hour > 12) {
        return null;
      }

      if (isPm && hour < 12) {
        hour += 12;
      } else if (isAm && hour == 12) {
        hour = 0;
      }
    } else if (hour < 0 || hour > 23) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
