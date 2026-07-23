import 'package:quiz_app_grad/features/study_alarm/data/models/study_alarm_model.dart';

class StudyAlarmScheduleResponseModel {
  final bool success;
  final String title;
  final StudyAlarmScheduleModel data;
  final int statusCode;

  const StudyAlarmScheduleResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
  factory StudyAlarmScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = (json['data'] as Map).cast<String, dynamic>();

    return StudyAlarmScheduleResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      data: StudyAlarmScheduleModel.fromJson(dataJson),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }
}
