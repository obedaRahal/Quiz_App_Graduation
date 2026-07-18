class StudyPlanSummaryEntity {
  final int id;
  final String emoji;
  final String title;
  final int subjectsCount;
  final int dailyStudyMinutes;
  final int dailyStudyHours;
  final int durationDays;
  final String startDate;
  final String endDate;
  final int startsInDays;
  final int remainingDays;
  final bool isDefault;
  final StudyPlanStatisticsEntity statistics;

  final String startDateLabel;
  final String endDateLabel;

  const StudyPlanSummaryEntity({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subjectsCount,
    required this.dailyStudyMinutes,
    required this.dailyStudyHours,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.startsInDays,
    required this.remainingDays,
    required this.isDefault,
    required this.statistics,
    required this.startDateLabel,
    required this.endDateLabel,
  });

  bool get shouldDisplayHours => dailyStudyHours > 0;

  String get dailyStudyDurationText {
    if (shouldDisplayHours) {
      return '$dailyStudyHours ساعات يوميًا';
    }

    return '$dailyStudyMinutes دقيقة يوميًا';
  }

  StudyPlanSummaryEntity copyWith({
    int? id,
    String? emoji,
    String? title,
    int? subjectsCount,
    int? dailyStudyMinutes,
    int? dailyStudyHours,
    int? durationDays,
    String? startDate,
    String? endDate,
    int? startsInDays,
    int? remainingDays,
    bool? isDefault,
    StudyPlanStatisticsEntity? statistics,

    String? startDateLabel,
    String? endDateLabel,
  }) {
    return StudyPlanSummaryEntity(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      subjectsCount: subjectsCount ?? this.subjectsCount,
      dailyStudyMinutes: dailyStudyMinutes ?? this.dailyStudyMinutes,
      dailyStudyHours: dailyStudyHours ?? this.dailyStudyHours,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startsInDays: startsInDays ?? this.startsInDays,
      remainingDays: remainingDays ?? this.remainingDays,
      isDefault: isDefault ?? this.isDefault,
      statistics: statistics ?? this.statistics,
      startDateLabel: startDateLabel ?? this.startDateLabel,
      endDateLabel: endDateLabel ?? this.endDateLabel,
    );
  }
}

class StudyPlanStatisticsEntity {
  final int tasksCount;
  final int completedTasksCount;
  final int missedTasksCount;
  final int pendingTasksCount;

  const StudyPlanStatisticsEntity({
    required this.tasksCount,
    required this.completedTasksCount,
    required this.missedTasksCount,
    required this.pendingTasksCount,
  });

  StudyPlanStatisticsEntity copyWith({
    int? tasksCount,
    int? completedTasksCount,
    int? missedTasksCount,
    int? pendingTasksCount,
  }) {
    return StudyPlanStatisticsEntity(
      tasksCount: tasksCount ?? this.tasksCount,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      missedTasksCount: missedTasksCount ?? this.missedTasksCount,
      pendingTasksCount: pendingTasksCount ?? this.pendingTasksCount,
    );
  }
}
