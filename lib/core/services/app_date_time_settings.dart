import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';

class AppDateTimeSettings {
  AppDateTimeSettings._();

  static const String defaultWeekStartsOn = 'السبت';
  static const String twelveHourFormat = '12 ساعة';
  static const String twentyFourHourFormat = '24 ساعة';
  static const String defaultTimeFormat = twelveHourFormat;

  static const Set<String> _supportedWeekDays = {
    'الأحد',
    'الإتنين',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  };

  static String get weekStartsOn {
    final storedValue = CacheHelper.getString(key: CacheHelper.weekStartsOnKey);

    return normalizeWeekStartsOn(storedValue);
  }

  static String get timeFormat {
    final storedValue = CacheHelper.getString(key: CacheHelper.timeFormatKey);

    return normalizeTimeFormat(storedValue);
  }

  static bool get use24HourFormat => timeFormat == twentyFourHourFormat;

  static Future<void> save({
    required String weekStartsOn,
    required String timeFormat,
  }) async {
    final normalizedWeekStartsOn = normalizeWeekStartsOn(weekStartsOn);
    final normalizedTimeFormat = normalizeTimeFormat(timeFormat);

    try {
      await Future.wait([
        CacheHelper.saveData(
          key: CacheHelper.weekStartsOnKey,
          value: normalizedWeekStartsOn,
        ),
        CacheHelper.saveData(
          key: CacheHelper.timeFormatKey,
          value: normalizedTimeFormat,
        ),
      ]);
    } catch (error, stackTrace) {
      debugPrint('Failed to cache date/time settings: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static String normalizeWeekStartsOn(String? value) {
    final normalizedValue = value?.trim() ?? '';

    if (!_supportedWeekDays.contains(normalizedValue)) {
      return defaultWeekStartsOn;
    }

    return normalizedValue == 'الاثنين' ? 'الإتنين' : normalizedValue;
  }

  static String normalizeTimeFormat(String? value) {
    return value?.trim() == twentyFourHourFormat
        ? twentyFourHourFormat
        : defaultTimeFormat;
  }
}
