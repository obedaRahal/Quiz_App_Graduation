enum StudyPlanDayDisplayState {
  today,
  empty,
  completed,
  incompleted,
  scheduled,
  unknown,
}

extension StudyPlanDayDisplayStateX
    on StudyPlanDayDisplayState {
  static StudyPlanDayDisplayState fromApi(String value) {
    switch (value.trim().toLowerCase()) {
      case 'today':
        return StudyPlanDayDisplayState.today;

      case 'empty':
        return StudyPlanDayDisplayState.empty;

      case 'completed':
        return StudyPlanDayDisplayState.completed;

      case 'incompleted':
        return StudyPlanDayDisplayState.incompleted;

      case 'scheduled':
        return StudyPlanDayDisplayState.scheduled;

      default:
        return StudyPlanDayDisplayState.unknown;
    }
  }

  String get apiValue {
    switch (this) {
      case StudyPlanDayDisplayState.today:
        return 'today';

      case StudyPlanDayDisplayState.empty:
        return 'empty';

      case StudyPlanDayDisplayState.completed:
        return 'completed';

      case StudyPlanDayDisplayState.incompleted:
        return 'incompleted';

      case StudyPlanDayDisplayState.scheduled:
        return 'scheduled';

      case StudyPlanDayDisplayState.unknown:
        return 'unknown';
    }
  }
}

class StudyPlanDayEntity {
  final String date;
  final int dayNumber;
  final String dayName;
  final bool isToday;
  final bool hasTasks;
  final int totalTasks;
  final int completedTasks;

  /// القيمة الخام القادمة من الباك.
  final String completionState;

  /// القيمة الخام القادمة من الباك.
  final String displayState;

  const StudyPlanDayEntity({
    required this.date,
    required this.dayNumber,
    required this.dayName,
    required this.isToday,
    required this.hasTasks,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionState,
    required this.displayState,
  });

  StudyPlanDayDisplayState get parsedDisplayState {
    return StudyPlanDayDisplayStateX.fromApi(
      displayState,
    );
  }

  bool isSelected(String selectedDate) {
    return date == selectedDate;
  }

  StudyPlanDayEntity copyWith({
    String? date,
    int? dayNumber,
    String? dayName,
    bool? isToday,
    bool? hasTasks,
    int? totalTasks,
    int? completedTasks,
    String? completionState,
    String? displayState,
  }) {
    return StudyPlanDayEntity(
      date: date ?? this.date,
      dayNumber: dayNumber ?? this.dayNumber,
      dayName: dayName ?? this.dayName,
      isToday: isToday ?? this.isToday,
      hasTasks: hasTasks ?? this.hasTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks:
          completedTasks ?? this.completedTasks,
      completionState:
          completionState ?? this.completionState,
      displayState: displayState ?? this.displayState,
    );
  }
}