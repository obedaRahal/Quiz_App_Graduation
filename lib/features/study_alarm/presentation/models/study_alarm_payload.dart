import 'dart:convert';

import 'package:alarm/alarm.dart';

class StudyAlarmPayload {
  final String type;
  final String alarmKey;
  final int taskId;
  final int occurrenceId;
  final int studyPlanId;
  final bool isSnoozed;

  const StudyAlarmPayload({
    required this.type,
    required this.alarmKey,
    required this.taskId,
    required this.occurrenceId,
    required this.studyPlanId,
    required this.isSnoozed,
  });

  bool get isStudyAlarm => type == 'study_alarm';

  bool get canOpenTask => taskId > 0 && studyPlanId > 0;

  factory StudyAlarmPayload.fromSettings(AlarmSettings settings) {
    final rawPayload = settings.payload;

    if (rawPayload == null || rawPayload.trim().isEmpty) {
      return const StudyAlarmPayload.empty();
    }

    try {
      final decoded = jsonDecode(rawPayload);

      if (decoded is! Map) {
        return const StudyAlarmPayload.empty();
      }

      final json = Map<String, dynamic>.from(decoded);

      return StudyAlarmPayload(
        type: json['type']?.toString().trim() ?? '',
        alarmKey: json['alarm_key']?.toString().trim() ?? '',
        taskId: _asPositiveInt(json['task_id']),
        occurrenceId: _asPositiveInt(json['occurrence_id']),
        studyPlanId: _asPositiveInt(json['study_plan_id']),
        isSnoozed: json['snoozed'] == true,
      );
    } catch (_) {
      return const StudyAlarmPayload.empty();
    }
  }

  const StudyAlarmPayload.empty()
    : type = '',
      alarmKey = '',
      taskId = 0,
      occurrenceId = 0,
      studyPlanId = 0,
      isSnoozed = false;
}

int _asPositiveInt(dynamic value) {
  final parsed = value is int
      ? value
      : int.tryParse(value?.toString().trim() ?? '');

  return parsed != null && parsed > 0 ? parsed : 0;
}
