import 'package:alarm/alarm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/models/study_alarm_payload.dart';

void main() {
  group('StudyAlarmPayload', () {
    test('parses valid study alarm payload and task navigation ids', () {
      final payload = StudyAlarmPayload.fromSettings(
        _settings(
          payload: '''
          {
            "type": "study_alarm",
            "alarm_key": "task-12-occurrence-30",
            "task_id": "12",
            "occurrence_id": 30,
            "study_plan_id": 7,
            "snoozed": true
          }
          ''',
        ),
      );

      expect(payload.isStudyAlarm, isTrue);
      expect(payload.canOpenTask, isTrue);
      expect(payload.alarmKey, 'task-12-occurrence-30');
      expect(payload.taskId, 12);
      expect(payload.occurrenceId, 30);
      expect(payload.studyPlanId, 7);
      expect(payload.isSnoozed, isTrue);
    });

    test('returns safe empty payload for malformed json', () {
      final payload = StudyAlarmPayload.fromSettings(
        _settings(payload: '{invalid-json'),
      );

      expect(payload.isStudyAlarm, isFalse);
      expect(payload.canOpenTask, isFalse);
      expect(payload.taskId, 0);
      expect(payload.studyPlanId, 0);
    });

    test('does not allow opening a task when route ids are invalid', () {
      final payload = StudyAlarmPayload.fromSettings(
        _settings(
          payload: '''
          {
            "type": "study_alarm",
            "task_id": -1,
            "study_plan_id": "not-a-number"
          }
          ''',
        ),
      );

      expect(payload.isStudyAlarm, isTrue);
      expect(payload.canOpenTask, isFalse);
    });
  });
}

AlarmSettings _settings({required String payload}) {
  return AlarmSettings(
    id: 42,
    dateTime: DateTime(2030),
    assetAudioPath: null,
    loopAudio: true,
    vibrate: true,
    notificationSettings: const NotificationSettings(
      title: 'Study task',
      body: 'Time to study',
      stopButton: 'Stop',
    ),
    volumeSettings: const VolumeSettings.fixed(),
    payload: payload,
  );
}
