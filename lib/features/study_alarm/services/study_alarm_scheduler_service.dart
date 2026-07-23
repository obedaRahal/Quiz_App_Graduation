import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';

abstract class StudyAlarmSchedulerService {
  Future<void> syncStudyAlarms({required StudyAlarmScheduleEntity schedule});

  Future<void> scheduleAllStudyAlarms({required List<StudyAlarmEntity> alarms});

  Future<void> scheduleStudyAlarm({required StudyAlarmEntity alarm});

  Future<void> cancelStudyAlarm({required int alarmId});

  Future<void> cancelAllStudyAlarms();

  Future<void> stopStudyAlarm({required int alarmId});

  Future<void> snoozeStudyAlarm({
    required int alarmId,
    Duration duration = const Duration(minutes: 10),
  });
}

class StudyAlarmSchedulerServiceImpl implements StudyAlarmSchedulerService {
  static const String _studyAlarmPayloadType = 'study_alarm';

  StudyAlarmSchedulerServiceImpl() {
    debugPrint('============ StudyAlarmSchedulerServiceImpl INIT ============');
  }

  @override
  Future<void> syncStudyAlarms({
    required StudyAlarmScheduleEntity schedule,
  }) async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.syncStudyAlarms ============',
    );

    debugPrint('→ taskRemindersEnabled: ${schedule.taskRemindersEnabled}');
    debugPrint(
      '→ shouldCancelExistingAlarms: '
      '${schedule.shouldCancelExistingAlarms}',
    );
    debugPrint('→ alarmsCount: ${schedule.alarms.length}');
    debugPrint(
      '→ schedulableAlarmsCount: ${schedule.schedulableAlarms.length}',
    );

    if (schedule.shouldCancelExistingAlarms || !schedule.taskRemindersEnabled) {
      debugPrint('→ reminders disabled or cancellation requested');

      await cancelAllStudyAlarms();

      debugPrint('✓ study alarms cancelled');
      debugPrint(
        '=======================================================================',
      );
      return;
    }

    await cancelAllStudyAlarms();

    if (schedule.schedulableAlarms.isEmpty) {
      debugPrint('→ no schedulable study alarms found');
      debugPrint(
        '=======================================================================',
      );
      return;
    }

    await scheduleAllStudyAlarms(alarms: schedule.schedulableAlarms);

    debugPrint('✓ study alarms synchronized successfully');
    debugPrint(
      '=======================================================================',
    );
  }

  @override
  Future<void> scheduleAllStudyAlarms({
    required List<StudyAlarmEntity> alarms,
  }) async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.scheduleAllStudyAlarms ============',
    );

    debugPrint('→ alarmsCount: ${alarms.length}');

    var scheduledCount = 0;
    var skippedCount = 0;
    var failedCount = 0;

    for (final alarm in alarms) {
      try {
        if (!alarm.canBeScheduled) {
          skippedCount++;

          debugPrint('⚠ alarm skipped');
          debugPrint('→ alarmKey: ${alarm.alarmKey}');
          debugPrint('→ shouldScheduleAlarm: ${alarm.shouldScheduleAlarm}');
          debugPrint('→ alarmAt: ${alarm.alarmAt}');
          debugPrint('→ isExpired: ${alarm.isExpired}');
          continue;
        }

        await scheduleStudyAlarm(alarm: alarm);
        scheduledCount++;
      } catch (error, stackTrace) {
        failedCount++;

        debugPrint('✗ scheduleStudyAlarm failed inside list');
        debugPrint('→ alarmKey: ${alarm.alarmKey}');
        debugPrint('→ error: $error');
        debugPrint('→ stackTrace: $stackTrace');
      }
    }

    debugPrint('→ scheduledCount: $scheduledCount');
    debugPrint('→ skippedCount: $skippedCount');
    debugPrint('→ failedCount: $failedCount');
    debugPrint(
      '===============================================================================',
    );
  }

  @override
  Future<void> scheduleStudyAlarm({required StudyAlarmEntity alarm}) async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.scheduleStudyAlarm ============',
    );

    debugPrint('→ alarmKey: ${alarm.alarmKey}');
    debugPrint('→ alarmAt: ${alarm.alarmAt}');
    debugPrint('→ taskId: ${alarm.task.id}');
    debugPrint('→ taskTitle: ${alarm.task.title}');
    debugPrint('→ occurrenceId: ${alarm.occurrence.id}');
    debugPrint('→ studyPlanId: ${alarm.studyPlan.id}');
    debugPrint('→ studyPlanTitle: ${alarm.studyPlan.title}');

    if (!alarm.canBeScheduled) {
      debugPrint('⚠ alarm cannot be scheduled');
      debugPrint('→ shouldScheduleAlarm: ${alarm.shouldScheduleAlarm}');
      debugPrint('→ isExpired: ${alarm.isExpired}');
      debugPrint(
        '==========================================================================',
      );
      return;
    }

    final alarmId = _generateAlarmId(alarm.alarmKey);

    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: alarm.alarmAt,
      assetAudioPath: null,
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      androidStopAlarmOnTermination: false,
      allowAlarmOverlap: false,

      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 3),
        volumeEnforced: true,
      ),

      payload: jsonEncode({
        'type': _studyAlarmPayloadType,
        'alarm_key': alarm.alarmKey,
        'task_id': alarm.task.id,
        'occurrence_id': alarm.occurrence.id,
        'study_plan_id': alarm.studyPlan.id,
      }),

      notificationSettings: NotificationSettings(
        title: alarm.task.title,
        body: _buildNotificationBody(alarm),
        stopButton: 'إيقاف',
      ),
    );

    final didSetAlarm = await Alarm.set(alarmSettings: alarmSettings);

    if (!didSetAlarm) {
      throw Exception(
        'Alarm.set returned false for alarmKey: ${alarm.alarmKey}',
      );
    }

    debugPrint('✓ study alarm scheduled');
    debugPrint('→ alarmId: $alarmId');
    debugPrint(
      '==========================================================================',
    );
  }

  @override
  Future<void> cancelStudyAlarm({required int alarmId}) async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.cancelStudyAlarm ============',
    );

    debugPrint('→ alarmId: $alarmId');

    final didStopAlarm = await Alarm.stop(alarmId);

    debugPrint('→ didStopAlarm: $didStopAlarm');

    if (didStopAlarm) {
      debugPrint('✓ study alarm cancelled');
    } else {
      debugPrint('⚠ study alarm was not found or was already stopped');
    }

    debugPrint(
      '=========================================================================',
    );
  }

  @override
  Future<void> cancelAllStudyAlarms() async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.cancelAllStudyAlarms ============',
    );

    final scheduledAlarms = await Alarm.getAlarms();

    debugPrint('→ totalScheduledAlarms: ${scheduledAlarms.length}');

    final studyAlarms = scheduledAlarms.where(_isStudyAlarm).toList();

    debugPrint('→ studyAlarmsCount: ${studyAlarms.length}');

    if (studyAlarms.isEmpty) {
      debugPrint('→ no study alarms to cancel');
      debugPrint(
        '============================================================================',
      );
      return;
    }

    var cancelledCount = 0;
    var failedCount = 0;

    for (final alarmSettings in studyAlarms) {
      try {
        final didStopAlarm = await Alarm.stop(alarmSettings.id);

        if (didStopAlarm) {
          cancelledCount++;
          debugPrint('✓ cancelled study alarm id: ${alarmSettings.id}');
        } else {
          failedCount++;
          debugPrint('⚠ failed to cancel study alarm id: ${alarmSettings.id}');
        }
      } catch (error, stackTrace) {
        failedCount++;

        debugPrint(
          '✗ exception while cancelling alarm id: '
          '${alarmSettings.id}',
        );
        debugPrint('→ error: $error');
        debugPrint('→ stackTrace: $stackTrace');
      }
    }

    debugPrint('→ cancelledCount: $cancelledCount');
    debugPrint('→ failedCount: $failedCount');
    debugPrint(
      '============================================================================',
    );
  }

  @override
  Future<void> stopStudyAlarm({required int alarmId}) async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.stopStudyAlarm ============',
    );

    debugPrint('→ alarmId: $alarmId');

    final didStopAlarm = await Alarm.stop(alarmId);

    debugPrint('→ didStopAlarm: $didStopAlarm');

    if (didStopAlarm) {
      debugPrint('✓ ringing study alarm stopped');
    } else {
      debugPrint('⚠ ringing study alarm was not found or already stopped');
    }

    debugPrint(
      '=======================================================================',
    );
  }

  @override
  Future<void> snoozeStudyAlarm({
    required int alarmId,
    Duration duration = const Duration(minutes: 10),
  }) async {
    debugPrint(
      '============ StudyAlarmSchedulerServiceImpl.snoozeStudyAlarm ============',
    );

    debugPrint('→ alarmId: $alarmId');
    debugPrint('→ snoozeMinutes: ${duration.inMinutes}');

    // سننفذها لاحقاً بعد إنشاء شاشة الرنين،
    // لأنها تحتاج الاحتفاظ بإعدادات المنبه الأصلي
    // ثم إعادة جدولته بتاريخ جديد.
    throw UnimplementedError(
      'snoozeStudyAlarm will be implemented with the alarm ringing screen',
    );
  }

  int _generateAlarmId(String alarmKey) {
    var hash = 0;

    for (final codeUnit in alarmKey.codeUnits) {
      hash = ((hash * 31) + codeUnit) & 0x7fffffff;
    }

    if (hash == 0) {
      return 1;
    }

    return hash;
  }

  String _buildNotificationBody(StudyAlarmEntity alarm) {
    final description = alarm.task.description?.trim();

    if (description != null && description.isNotEmpty) {
      return description;
    }

    return 'حان وقت المهمة ضمن خطة ${alarm.studyPlan.title}';
  }

  bool _isStudyAlarm(AlarmSettings alarmSettings) {
    final payload = alarmSettings.payload;

    if (payload == null || payload.trim().isEmpty) {
      return false;
    }

    try {
      final decodedPayload = jsonDecode(payload);

      return decodedPayload is Map<String, dynamic> &&
          decodedPayload['type'] == _studyAlarmPayloadType;
    } catch (_) {
      return false;
    }
  }
}
