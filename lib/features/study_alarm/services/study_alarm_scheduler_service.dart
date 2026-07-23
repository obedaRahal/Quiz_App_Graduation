import 'dart:async';
import 'dart:convert';

import 'package:alarm/alarm.dart';
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
  static final Object _lockZoneKey = Object();

  Future<void> _operationQueue = Future<void>.value();
  String? _lastScheduleFingerprint;

  StudyAlarmSchedulerServiceImpl() {
    debugPrint('============ StudyAlarmSchedulerServiceImpl INIT ============');
  }

  @override
  Future<void> syncStudyAlarms({required StudyAlarmScheduleEntity schedule}) {
    return _withLock(() async {
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

      final fingerprint = _buildScheduleFingerprint(schedule);
      final scheduleChanged = _lastScheduleFingerprint != fingerprint;

      if (!scheduleChanged) {
        debugPrint(
          '→ study alarm schedule did not change; '
          'installed alarms will only be verified',
        );
      }

      if (schedule.shouldCancelExistingAlarms ||
          !schedule.taskRemindersEnabled) {
        debugPrint('→ reminders disabled or cancellation requested');

        await cancelAllStudyAlarms();
        _lastScheduleFingerprint = fingerprint;

        debugPrint('✓ study alarms cancelled');
        debugPrint(
          '=======================================================================',
        );
        return;
      }

      await _syncChangedStudyAlarms(schedule);
      _lastScheduleFingerprint = fingerprint;

      debugPrint('✓ study alarms synchronized successfully');
      debugPrint(
        '=======================================================================',
      );
    });
  }

  @override
  Future<void> scheduleAllStudyAlarms({
    required List<StudyAlarmEntity> alarms,
  }) {
    return _withLock(() async {
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

      if (failedCount > 0) {
        throw StudyAlarmSynchronizationException(
          'تعذر إعداد $failedCount منبه من أصل ${alarms.length}.',
        );
      }
    });
  }

  @override
  Future<void> scheduleStudyAlarm({required StudyAlarmEntity alarm}) {
    return _withLock(() => _scheduleStudyAlarmUnlocked(alarm));
  }

  Future<void> _scheduleStudyAlarmUnlocked(StudyAlarmEntity alarm) async {
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

    final alarmSettings = _buildAlarmSettings(alarm);

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
  Future<void> cancelStudyAlarm({required int alarmId}) {
    return _withLock(() async {
      debugPrint(
        '============ StudyAlarmSchedulerServiceImpl.cancelStudyAlarm ============',
      );

      debugPrint('→ alarmId: $alarmId');

      final didStopAlarm = await Alarm.stop(alarmId);

      debugPrint('→ didStopAlarm: $didStopAlarm');

      if (didStopAlarm) {
        _lastScheduleFingerprint = null;
        debugPrint('✓ study alarm cancelled');
      } else {
        debugPrint('⚠ study alarm was not found or was already stopped');
      }

      debugPrint(
        '=========================================================================',
      );
    });
  }

  @override
  Future<void> cancelAllStudyAlarms() {
    return _withLock(() async {
      _lastScheduleFingerprint = null;

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
            debugPrint(
              '⚠ failed to cancel study alarm id: ${alarmSettings.id}',
            );
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

      if (failedCount > 0) {
        throw StudyAlarmSynchronizationException(
          'تعذر إلغاء $failedCount منبه دراسة قديم.',
        );
      }
    });
  }

  @override
  Future<void> stopStudyAlarm({required int alarmId}) {
    return _withLock(() async {
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
    });
  }

  @override
  Future<void> snoozeStudyAlarm({
    required int alarmId,
    Duration duration = const Duration(minutes: 10),
  }) {
    return _withLock(() async {
      debugPrint(
        '============ StudyAlarmSchedulerServiceImpl.snoozeStudyAlarm ============',
      );

      debugPrint('→ alarmId: $alarmId');
      debugPrint('→ snoozeMinutes: ${duration.inMinutes}');

      if (duration <= Duration.zero) {
        throw ArgumentError.value(
          duration,
          'duration',
          'يجب أن تكون مدة الغفوة أكبر من صفر.',
        );
      }

      final originalSettings = await Alarm.getAlarm(alarmId);

      if (originalSettings == null || !_isStudyAlarm(originalSettings)) {
        throw StudyAlarmSynchronizationException(
          'تعذر العثور على إعدادات منبه الدراسة.',
        );
      }

      final snoozedAt = DateTime.now().add(duration);
      final snoozedPayload = _markPayloadAsSnoozed(
        originalSettings.payload,
        snoozedAt,
      );

      final didStopAlarm = await Alarm.stop(alarmId);

      if (!didStopAlarm) {
        throw StudyAlarmSynchronizationException(
          'تعذر إيقاف المنبه قبل تفعيل الغفوة.',
        );
      }

      final didSetAlarm = await Alarm.set(
        alarmSettings: originalSettings.copyWith(
          dateTime: snoozedAt,
          payload: () => snoozedPayload,
        ),
      );

      if (!didSetAlarm) {
        throw StudyAlarmSynchronizationException(
          'تعذر إعادة جدولة المنبه بعد الغفوة.',
        );
      }

      debugPrint('✓ study alarm snoozed');
      debugPrint('→ snoozedAt: $snoozedAt');
      debugPrint(
        '=======================================================================',
      );
    });
  }

  Future<T> _withLock<T>(Future<T> Function() action) async {
    if (identical(Zone.current[_lockZoneKey], this)) {
      return action();
    }

    final previousOperation = _operationQueue;
    final currentOperation = Completer<void>();
    _operationQueue = currentOperation.future;

    try {
      await previousOperation;
    } catch (_) {
      // A failed operation must not block the operations queued after it.
    }

    try {
      return await runZoned(
        action,
        zoneValues: <Object, Object>{_lockZoneKey: this},
      );
    } finally {
      if (!currentOperation.isCompleted) {
        currentOperation.complete();
      }
    }
  }

  Future<void> _syncChangedStudyAlarms(
    StudyAlarmScheduleEntity schedule,
  ) async {
    final desiredAlarms = schedule.schedulableAlarms;
    final snoozableAlarmKeys = schedule.alarms
        .where((alarm) => alarm.shouldScheduleAlarm)
        .map((alarm) => alarm.alarmKey)
        .toSet();
    final duplicateSeconds = <int, String>{};

    for (final alarm in desiredAlarms) {
      final second = alarm.alarmAt.millisecondsSinceEpoch ~/ 1000;
      final previousAlarmKey = duplicateSeconds[second];

      if (previousAlarmKey != null && previousAlarmKey != alarm.alarmKey) {
        throw StudyAlarmSynchronizationException(
          'يوجد منبهان دراسيان في الثانية نفسها. يرجى تعديل وقت إحدى المهمتين.',
        );
      }

      duplicateSeconds[second] = alarm.alarmKey;
    }

    final installedAlarms = await Alarm.getAlarms();
    final installedStudyAlarms = installedAlarms.where(_isStudyAlarm).toList();
    final installedById = <int, AlarmSettings>{
      for (final alarm in installedStudyAlarms) alarm.id: alarm,
    };
    final desiredIds = desiredAlarms
        .map((alarm) => _generateAlarmId(alarm.alarmKey))
        .toSet();
    final failures = <String>[];

    for (final installed in installedStudyAlarms) {
      final alarmKey = _alarmKeyFromSettings(installed);
      final preserveSnooze =
          _isActiveSnooze(installed) &&
          alarmKey != null &&
          snoozableAlarmKeys.contains(alarmKey);

      if (desiredIds.contains(installed.id) || preserveSnooze) {
        continue;
      }

      try {
        if (!await Alarm.stop(installed.id)) {
          failures.add('إلغاء المنبه ${installed.id}');
        }
      } catch (_) {
        failures.add('إلغاء المنبه ${installed.id}');
      }
    }

    for (final alarm in desiredAlarms) {
      final expected = _buildAlarmSettings(alarm);
      final installed = installedById[expected.id];

      if (installed != null && _isActiveSnooze(installed)) {
        continue;
      }

      if (installed != null && _sameAlarmSettings(installed, expected)) {
        continue;
      }

      try {
        if (!await Alarm.set(alarmSettings: expected)) {
          failures.add('إعداد منبه المهمة ${alarm.task.title}');
        }
      } catch (_) {
        failures.add('إعداد منبه المهمة ${alarm.task.title}');
      }
    }

    if (failures.isNotEmpty) {
      throw StudyAlarmSynchronizationException(
        'تعذرت مزامنة بعض منبهات الدراسة: ${failures.join('، ')}.',
      );
    }
  }

  AlarmSettings _buildAlarmSettings(StudyAlarmEntity alarm) {
    return AlarmSettings(
      id: _generateAlarmId(alarm.alarmKey),
      dateTime: alarm.alarmAt,
      assetAudioPath: null,
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: Alarm.iOS,
      androidFullScreenIntent: true,
      androidStopAlarmOnTermination: false,
      allowAlarmOverlap: false,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 3),
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: alarm.task.title,
        body: _buildNotificationBody(alarm),
        stopButton: 'إيقاف',
      ),
      payload: jsonEncode({
        'type': _studyAlarmPayloadType,
        'alarm_key': alarm.alarmKey,
        'task_id': alarm.task.id,
        'occurrence_id': alarm.occurrence.id,
        'study_plan_id': alarm.studyPlan.id,
      }),
    );
  }

  String _buildScheduleFingerprint(StudyAlarmScheduleEntity schedule) {
    final alarms =
        schedule.alarms
            .map(
              (alarm) => <String, Object?>{
                'alarm_key': alarm.alarmKey,
                'alarm_at': alarm.alarmAt.toUtc().microsecondsSinceEpoch,
                'should_schedule': alarm.shouldScheduleAlarm,
                'reminder_offset_minutes': alarm.reminderOffsetMinutes,
                'task_id': alarm.task.id,
                'task_title': alarm.task.title,
                'task_description': alarm.task.description,
                'occurrence_id': alarm.occurrence.id,
                'study_plan_id': alarm.studyPlan.id,
                'study_plan_title': alarm.studyPlan.title,
              },
            )
            .toList()
          ..sort(
            (first, second) => (first['alarm_key'] as String).compareTo(
              second['alarm_key'] as String,
            ),
          );

    return jsonEncode({
      'task_reminders_enabled': schedule.taskRemindersEnabled,
      'should_cancel_existing_alarms': schedule.shouldCancelExistingAlarms,
      'alarms': alarms,
    });
  }

  bool _sameAlarmSettings(AlarmSettings installed, AlarmSettings expected) {
    return installed.id == expected.id &&
        installed.dateTime.isAtSameMomentAs(expected.dateTime) &&
        installed.payload == expected.payload &&
        installed.notificationSettings.title ==
            expected.notificationSettings.title &&
        installed.notificationSettings.body ==
            expected.notificationSettings.body;
  }

  bool _isActiveSnooze(AlarmSettings alarmSettings) {
    if (!alarmSettings.dateTime.isAfter(DateTime.now())) {
      return false;
    }

    final payload = _decodePayload(alarmSettings.payload);
    return payload?['snoozed'] == true;
  }

  String? _alarmKeyFromSettings(AlarmSettings alarmSettings) {
    final payload = _decodePayload(alarmSettings.payload);
    final alarmKey = payload?['alarm_key'];
    return alarmKey is String && alarmKey.isNotEmpty ? alarmKey : null;
  }

  String _markPayloadAsSnoozed(String? payload, DateTime snoozedAt) {
    final decoded = _decodePayload(payload) ?? <String, dynamic>{};
    decoded['type'] = _studyAlarmPayloadType;
    decoded['snoozed'] = true;
    decoded['snoozed_at'] = snoozedAt.toUtc().toIso8601String();
    return jsonEncode(decoded);
  }

  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (_) {
      return null;
    }

    return null;
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
    return _decodePayload(alarmSettings.payload)?['type'] ==
        _studyAlarmPayloadType;
  }
}

class StudyAlarmSynchronizationException implements Exception {
  final String message;

  const StudyAlarmSynchronizationException(this.message);

  @override
  String toString() => message;
}
