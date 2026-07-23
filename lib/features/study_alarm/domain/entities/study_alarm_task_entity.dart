
class StudyAlarmScheduleEntity {
  final String timezone;
  final bool taskRemindersEnabled;
  final bool shouldCancelExistingAlarms;
  final int days;
  final DateTime generatedAt;
  final List<StudyAlarmEntity> alarms;

  const StudyAlarmScheduleEntity({
    required this.timezone,
    required this.taskRemindersEnabled,
    required this.shouldCancelExistingAlarms,
    required this.days,
    required this.generatedAt,
    required this.alarms,
  });

  bool get shouldScheduleAlarms {
    return taskRemindersEnabled && !shouldCancelExistingAlarms;
  }

  List<StudyAlarmEntity> get schedulableAlarms {
    if (!shouldScheduleAlarms) {
      return const [];
    }

    return alarms.where((alarm) => alarm.canBeScheduled).toList();
  }
}

class StudyAlarmEntity {
  final String alarmKey;
  final bool shouldScheduleAlarm;
  final DateTime alarmAt;
  final int reminderOffsetMinutes;
  final StudyAlarmOccurrenceEntity occurrence;
  final StudyAlarmTaskEntity task;
  final StudyAlarmPlanEntity studyPlan;

  const StudyAlarmEntity({
    required this.alarmKey,
    required this.shouldScheduleAlarm,
    required this.alarmAt,
    required this.reminderOffsetMinutes,
    required this.occurrence,
    required this.task,
    required this.studyPlan,
  });

  bool get isExpired {
    return alarmAt.isBefore(DateTime.now());
  }

  bool get canBeScheduled {
    return shouldScheduleAlarm && !isExpired;
  }
}

class StudyAlarmTaskEntity {
  final int id;
  final String title;
  final String? description;
  final String status;

  const StudyAlarmTaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
}

class StudyAlarmOccurrenceEntity {
  final int id;
  final DateTime date;
  final DateTime scheduledStartAt;
  final DateTime scheduledEndAt;

  const StudyAlarmOccurrenceEntity({
    required this.id,
    required this.date,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
  });
}

class StudyAlarmPlanEntity {
  final int id;
  final String title;
  final bool isDefault;

  const StudyAlarmPlanEntity({
    required this.id,
    required this.title,
    required this.isDefault,
  });
}
