

import 'package:intl/intl.dart';

class StudyPlanDateUtils {
  const StudyPlanDateUtils._();

  static final DateFormat _apiDateFormat =
      DateFormat('yyyy-MM-dd');

  static DateTime? tryParseApiDate(
    String value,
  ) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) return null;

    try {
      return _apiDateFormat.parseStrict(
        cleanValue,
      );
    } catch (_) {
      return DateTime.tryParse(cleanValue);
    }
  }

  static String formatApiDate(
    DateTime date,
  ) {
    final normalized = DateTime(
      date.year,
      date.month,
      date.day,
    );

    return _apiDateFormat.format(normalized);
  }

  static int weekDayNumberFromArabicName(
    String value,
  ) {
    switch (value.trim()) {
      case 'الاثنين':
        return DateTime.monday;

      case 'الثلاثاء':
        return DateTime.tuesday;

      case 'الأربعاء':
        return DateTime.wednesday;

      case 'الخميس':
        return DateTime.thursday;

      case 'الجمعة':
        return DateTime.friday;

      case 'السبت':
        return DateTime.saturday;

      case 'الأحد':
        return DateTime.sunday;

      default:
        return DateTime.saturday;
    }
  }

  static DateTime calculateWeekStart({
    required DateTime date,
    required String weekStartsOn,
  }) {
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final weekStartDay =
        weekDayNumberFromArabicName(
      weekStartsOn,
    );

    final difference =
        (normalizedDate.weekday -
                weekStartDay +
                7) %
            7;

    return normalizedDate.subtract(
      Duration(days: difference),
    );
  }

  static DateTime calculateWeekEnd({
    required DateTime weekStart,
  }) {
    return weekStart.add(
      const Duration(days: 6),
    );
  }

  static String arabicDayName(
    DateTime date,
  ) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'الاثنين';

      case DateTime.tuesday:
        return 'الثلاثاء';

      case DateTime.wednesday:
        return 'الأربعاء';

      case DateTime.thursday:
        return 'الخميس';

      case DateTime.friday:
        return 'الجمعة';

      case DateTime.saturday:
        return 'السبت';

      case DateTime.sunday:
        return 'الأحد';

      default:
        return '';
    }
  }

  static List<DateTime> buildWeekDates({
    required DateTime weekStart,
  }) {
    return List.generate(
      7,
      (index) => weekStart.add(
        Duration(days: index),
      ),
    );
  }
}