import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';

class StudyTaskDetailsModel extends StudyTaskDetailsEntity {
  const StudyTaskDetailsModel({
    required super.success,
    required super.title,
    required super.data,
    required super.statusCode,
  });

  factory StudyTaskDetailsModel.fromJson(Map<String, dynamic> json) {
    return StudyTaskDetailsModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: StudyTaskDetailsDataModel.fromJson(_asMap(json['data'])),
      statusCode: _parseInt(json['status_code']),
    );
  }
}

class StudyTaskDetailsDataModel extends StudyTaskDetailsDataEntity {
  const StudyTaskDetailsDataModel({
    required super.basicInfo,
    required super.timingInfo,
    required super.subtasks,
  });

  factory StudyTaskDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return StudyTaskDetailsDataModel(
      basicInfo: StudyTaskBasicInfoModel.fromJson(
        _asMap(json['basic_info']),
      ),
      timingInfo: StudyTaskTimingInfoModel.fromJson(
        _asMap(json['timing_info']),
      ),
      subtasks: (json['subtasks'] as List? ?? [])
          .map(
            (e) => StudySubTaskModel.fromJson(
              _asMap(e),
            ),
          )
          .toList(),
    );
  }
}

class StudyTaskBasicInfoModel extends StudyTaskBasicInfoEntity {
  const StudyTaskBasicInfoModel({
    required super.id,
    required super.title,
    required super.status,
    required super.taskNumber,
    required super.subtasksCount,
    required super.startDate,
    required super.endDate,
    required super.priority,
    required super.description,
    required super.subject,
  });

  factory StudyTaskBasicInfoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyTaskBasicInfoModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      status: studyTaskStatusFromApi(
        json['status']?.toString() ?? '',
      ),
      taskNumber: _parseInt(json['task_number']),
      subtasksCount: StudyTaskSubtasksCountModel.fromJson(
        _asMap(json['subtasks_count']),
      ),
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      priority: studyTaskPriorityFromApi(
        json['priority']?.toString() ?? '',
      ),
      description: json['description']?.toString() ?? '',
      subject: StudyTaskSubjectModel.fromJson(
        _asMap(json['subject']),
      ),
    );
  }
}

class StudyTaskSubtasksCountModel
    extends StudyTaskSubtasksCountEntity {
  const StudyTaskSubtasksCountModel({
    required super.completed,
    required super.total,
    required super.label,
  });

  factory StudyTaskSubtasksCountModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyTaskSubtasksCountModel(
      completed: _parseInt(json['completed']),
      total: _parseInt(json['total']),
      label: json['label']?.toString() ?? '',
    );
  }
}

class StudyTaskSubjectModel extends StudyTaskSubjectEntity {
  const StudyTaskSubjectModel({
    required super.id,
    required super.name,
  });

  factory StudyTaskSubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyTaskSubjectModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}

class StudyTaskTimingInfoModel extends StudyTaskTimingInfoEntity {
  const StudyTaskTimingInfoModel({
    required super.startTime,
    required super.duration,
    required super.repeatPattern,
    required super.reminder,
  });

  factory StudyTaskTimingInfoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyTaskTimingInfoModel(
      startTime: json['start_time']?.toString() ?? '',
      duration: StudyTaskDurationModel.fromJson(
        _asMap(json['duration']),
      ),
      repeatPattern:
          json['repeat_pattern']?.toString() ?? '',
      reminder: StudyTaskReminderModel.fromJson(
        _asMap(json['reminder']),
      ),
    );
  }
}

class StudyTaskDurationModel extends StudyTaskDurationEntity {
  const StudyTaskDurationModel({
    required super.seconds,
    required super.minutes,
    required super.label,
  });

  factory StudyTaskDurationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyTaskDurationModel(
      seconds: _parseInt(json['seconds']),
      minutes: _parseInt(json['minutes']),
      label: json['label']?.toString() ?? '',
    );
  }
}

class StudyTaskReminderModel extends StudyTaskReminderEntity {
  const StudyTaskReminderModel({
    required super.offsetMinutes,
    required super.label,
  });

  factory StudyTaskReminderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudyTaskReminderModel(
      offsetMinutes: _parseInt(json['offset_minutes']),
      label: json['label']?.toString() ?? '',
    );
  }
}

class StudySubTaskModel extends StudySubTaskEntity {
  const StudySubTaskModel({
    required super.id,
    required super.title,
    required super.isCompleted,
  });

  factory StudySubTaskModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudySubTaskModel(
      id: _parseInt(json['id']),
      title: json['title']?.toString() ?? '',
      isCompleted: json['is_completed'] == true,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

int _parseInt(dynamic value) {
  if (value is int) return value;

  return int.tryParse(value?.toString() ?? '') ?? 0;
}