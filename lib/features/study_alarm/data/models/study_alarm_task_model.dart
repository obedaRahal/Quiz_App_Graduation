
import 'package:quiz_app_grad/features/study_alarm/data/models/study_alarm_date_parser.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';

class StudyAlarmPlanModel extends StudyAlarmPlanEntity {
  const StudyAlarmPlanModel({
    required super.id,
    required super.title,
    required super.isDefault,
  });

  factory StudyAlarmPlanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyAlarmPlanModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
    );
  }
}
class StudyAlarmTaskModel extends StudyAlarmTaskEntity {
  const StudyAlarmTaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
  });

  factory StudyAlarmTaskModel.fromJson(Map<String, dynamic> json) {
    return StudyAlarmTaskModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      status: json['status'] as String? ?? '',
    );
  }
}


class StudyAlarmOccurrenceModel extends StudyAlarmOccurrenceEntity {
  const StudyAlarmOccurrenceModel({
    required super.id,
    required super.date,
    required super.scheduledStartAt,
    required super.scheduledEndAt,
  });

  factory StudyAlarmOccurrenceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyAlarmOccurrenceModel(
      id: json['id'] as int,
      date: parseStudyAlarmDateTime(
        json['date'] as String,
      ),
      scheduledStartAt: parseStudyAlarmDateTime(
        json['scheduled_start_at'] as String,
      ),
      scheduledEndAt: parseStudyAlarmDateTime(
        json['scheduled_end_at'] as String,
      ),
    );
  }
}