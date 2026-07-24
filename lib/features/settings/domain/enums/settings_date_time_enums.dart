enum WeekStartDay {
  saturday,
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
}

extension WeekStartDayExtension on WeekStartDay {
  String get apiValue {
    switch (this) {
      case WeekStartDay.saturday:
        return 'السبت';

      case WeekStartDay.sunday:
        return 'الأحد';

      case WeekStartDay.monday:
        return 'الإتنين';

      case WeekStartDay.tuesday:
        return 'الثلاثاء';

      case WeekStartDay.wednesday:
        return 'الأربعاء';

      case WeekStartDay.thursday:
        return 'الخميس';

      case WeekStartDay.friday:
        return 'الجمعة';
    }
  }
}

enum AppTimeFormat { twelveHours, twentyFourHours }

extension AppTimeFormatExtension on AppTimeFormat {
  String get apiValue {
    switch (this) {
      case AppTimeFormat.twelveHours:
        return '12 ساعة';

      case AppTimeFormat.twentyFourHours:
        return '24 ساعة';
    }
  }
}

WeekStartDay weekStartDayFromApi(String value) {
  switch (value.trim()) {
    case 'السبت':
      return WeekStartDay.saturday;

    case 'الأحد':
      return WeekStartDay.sunday;

    case 'الإتنين':
    case 'الاثنين':
      return WeekStartDay.monday;

    case 'الثلاثاء':
      return WeekStartDay.tuesday;

    case 'الأربعاء':
      return WeekStartDay.wednesday;

    case 'الخميس':
      return WeekStartDay.thursday;

    case 'الجمعة':
      return WeekStartDay.friday;

    default:
      return WeekStartDay.saturday;
  }
}

AppTimeFormat appTimeFormatFromApi(String value) {
  switch (value.trim()) {
    case '12 ساعة':
      return AppTimeFormat.twelveHours;

    case '24 ساعة':
      return AppTimeFormat.twentyFourHours;

    default:
      return AppTimeFormat.twentyFourHours;
  }
}
