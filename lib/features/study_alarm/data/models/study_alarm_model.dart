import 'package:quiz_app_grad/features/study_alarm/data/models/study_alarm_date_parser.dart';
import 'package:quiz_app_grad/features/study_alarm/data/models/study_alarm_task_model.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';

class StudyAlarmScheduleModel extends StudyAlarmScheduleEntity {
  const StudyAlarmScheduleModel({
    required super.timezone,
    required super.taskRemindersEnabled,
    required super.shouldCancelExistingAlarms,
    required super.days,
    required super.generatedAt,
    required super.alarms,
  });

  factory StudyAlarmScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final alarmsJson = json['alarms'] as List<dynamic>? ?? const [];

    return StudyAlarmScheduleModel(
      timezone: json['timezone'] as String? ?? 'Asia/Damascus',
      taskRemindersEnabled:
          json['task_reminders_enabled'] as bool? ?? false,
      shouldCancelExistingAlarms:
          json['should_cancel_existing_alarms'] as bool? ?? false,
      days: json['days'] as int? ?? 0,
      generatedAt: parseStudyAlarmDateTime(
        json['generated_at'] as String,
      ),
      alarms: alarmsJson
          .whereType<Map<String, dynamic>>()
          .map(StudyAlarmModel.fromJson)
          .toList(),
    );
  }
}


class StudyAlarmModel extends StudyAlarmEntity {
  const StudyAlarmModel({
    required super.alarmKey,
    required super.shouldScheduleAlarm,
    required super.alarmAt,
    required super.reminderOffsetMinutes,
    required super.occurrence,
    required super.task,
    required super.studyPlan,
  });

  factory StudyAlarmModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyAlarmModel(
      alarmKey: json['alarm_key'] as String? ?? '',
      shouldScheduleAlarm:
          json['should_schedule_alarm'] as bool? ?? false,
      alarmAt: parseStudyAlarmDateTime(
        json['alarm_at'] as String,
      ),
      reminderOffsetMinutes:
          json['reminder_offset_minutes'] as int? ?? 0,
      occurrence: StudyAlarmOccurrenceModel.fromJson(
        json['occurrence'] as Map<String, dynamic>,
      ),
      task: StudyAlarmTaskModel.fromJson(
        json['task'] as Map<String, dynamic>,
      ),
      studyPlan: StudyAlarmPlanModel.fromJson(
        json['study_plan'] as Map<String, dynamic>,
      ),
    );
  }
}