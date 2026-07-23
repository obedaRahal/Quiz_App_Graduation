import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/study_alarm/data/models/study_alarm_model.dart';
import 'package:quiz_app_grad/features/study_alarm/data/models/study_alarm_schedule_response_model.dart';

abstract class StudyAlarmRemoteDataSource {
  Future<StudyAlarmScheduleModel> getStudyAlarmSchedule();
}

class StudyAlarmRemoteDataSourceImpl implements StudyAlarmRemoteDataSource {
  final ApiConsumer apiConsumer;

  const StudyAlarmRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<StudyAlarmScheduleModel> getStudyAlarmSchedule() async {
    debugPrint(
      '============ StudyAlarmRemoteDataSourceImpl.getStudyAlarmSchedule ============',
    );

    debugPrint('→ endpoint: ${EndPoints.studyAlarmReminderSchedule}');
    debugPrint('→ method: GET');

    final response = await apiConsumer.get(
      EndPoints.studyAlarmReminderSchedule,
    );

    debugPrint('← response: $response');

    final responseModel = StudyAlarmScheduleResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );

    debugPrint('✓ study alarm schedule fetched');
    debugPrint('→ success: ${responseModel.success}');
    debugPrint('→ title: ${responseModel.title}');
    debugPrint('→ statusCode: ${responseModel.statusCode}');
    debugPrint('→ timezone: ${responseModel.data.timezone}');
    debugPrint(
      '→ taskRemindersEnabled: '
      '${responseModel.data.taskRemindersEnabled}',
    );
    debugPrint(
      '→ shouldCancelExistingAlarms: '
      '${responseModel.data.shouldCancelExistingAlarms}',
    );
    debugPrint('→ alarms count: ${responseModel.data.alarms.length}');

    debugPrint(
      '=============================================================================',
    );

    return responseModel.data;
  }
}
