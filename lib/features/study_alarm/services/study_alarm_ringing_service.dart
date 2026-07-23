import 'dart:async';
import 'dart:collection';

import 'package:alarm/alarm.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/models/study_alarm_payload.dart';

typedef StudyAlarmRingingCallback =
    Future<void> Function(AlarmSettings alarmSettings);

class StudyAlarmRingingService {
  StreamSubscription<dynamic>? _subscription;
  final Queue<AlarmSettings> _pendingAlarms = Queue<AlarmSettings>();
  final Set<int> _queuedAlarmIds = <int>{};

  StudyAlarmRingingCallback? _onAlarmRinging;
  bool _isPresenting = false;

  void init({required StudyAlarmRingingCallback onAlarmRinging}) {
    _onAlarmRinging = onAlarmRinging;
    _subscription ??= Alarm.ringing.listen((alarmSet) {
      for (final alarmSettings in alarmSet.alarms) {
        final payload = StudyAlarmPayload.fromSettings(alarmSettings);

        if (!payload.isStudyAlarm ||
            _queuedAlarmIds.contains(alarmSettings.id)) {
          continue;
        }

        _queuedAlarmIds.add(alarmSettings.id);
        _pendingAlarms.add(alarmSettings);
      }

      unawaited(_drainQueue());
    });
  }

  Future<void> _drainQueue() async {
    if (_isPresenting || _pendingAlarms.isEmpty) {
      return;
    }

    _isPresenting = true;

    try {
      while (_pendingAlarms.isNotEmpty) {
        final alarmSettings = _pendingAlarms.removeFirst();
        final callback = _onAlarmRinging;

        try {
          if (callback != null) {
            await callback(alarmSettings);
          }
        } finally {
          _queuedAlarmIds.remove(alarmSettings.id);
        }
      }
    } finally {
      _isPresenting = false;
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _pendingAlarms.clear();
    _queuedAlarmIds.clear();
    _onAlarmRinging = null;
  }
}
