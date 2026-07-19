import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';

class StudyTaskDetailsEntity {
  final bool success;
  final String title;
  final StudyTaskDetailsDataEntity data;
  final int statusCode;

  const StudyTaskDetailsEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class StudyTaskDetailsDataEntity {
  final StudyTaskBasicInfoEntity basicInfo;
  final StudyTaskTimingInfoEntity timingInfo;
  final List<StudySubTaskEntity> subtasks;

  const StudyTaskDetailsDataEntity({
    required this.basicInfo,
    required this.timingInfo,
    required this.subtasks,
  });

  StudyTaskDetailsDataEntity copyWith({
    StudyTaskBasicInfoEntity? basicInfo,
    StudyTaskTimingInfoEntity? timingInfo,
    List<StudySubTaskEntity>? subtasks,
  }) {
    return StudyTaskDetailsDataEntity(
      basicInfo: basicInfo ?? this.basicInfo,
      timingInfo: timingInfo ?? this.timingInfo,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}

class StudyTaskBasicInfoEntity {
  final int id;
  final String title;
  final StudyTaskStatus status;
  final int taskNumber;
  final StudyTaskSubtasksCountEntity subtasksCount;
  final String startDate;
  final String endDate;
  final StudyTaskPriority priority;
  final String description;
  final StudyTaskSubjectEntity subject;

  const StudyTaskBasicInfoEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.taskNumber,
    required this.subtasksCount,
    required this.startDate,
    required this.endDate,
    required this.priority,
    required this.description,
    required this.subject,
  });

  StudyTaskBasicInfoEntity copyWith({
    int? id,
    String? title,
    StudyTaskStatus? status,
    int? taskNumber,
    StudyTaskSubtasksCountEntity? subtasksCount,
    String? startDate,
    String? endDate,
    StudyTaskPriority? priority,
    String? description,
    StudyTaskSubjectEntity? subject,
  }) {
    return StudyTaskBasicInfoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      taskNumber: taskNumber ?? this.taskNumber,
      subtasksCount: subtasksCount ?? this.subtasksCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
      description: description ?? this.description,
      subject: subject ?? this.subject,
    );
  }
}

class StudyTaskSubtasksCountEntity {
  final int completed;
  final int total;
  final String label;

  const StudyTaskSubtasksCountEntity({
    required this.completed,
    required this.total,
    required this.label,
  });

  StudyTaskSubtasksCountEntity copyWith({
    int? completed,
    int? total,
    String? label,
  }) {
    return StudyTaskSubtasksCountEntity(
      completed: completed ?? this.completed,
      total: total ?? this.total,
      label: label ?? this.label,
    );
  }
}

class StudyTaskSubjectEntity {
  final int id;
  final String name;

  const StudyTaskSubjectEntity({required this.id, required this.name});
}

class StudyTaskTimingInfoEntity {
  final String startTime;
  final StudyTaskDurationEntity duration;
  final String repeatPattern;
  final StudyTaskReminderEntity reminder;

  const StudyTaskTimingInfoEntity({
    required this.startTime,
    required this.duration,
    required this.repeatPattern,
    required this.reminder,
  });
}

class StudyTaskDurationEntity {
  final int seconds;
  final int minutes;
  final String label;

  const StudyTaskDurationEntity({
    required this.seconds,
    required this.minutes,
    required this.label,
  });
}

class StudyTaskReminderEntity {
  final int offsetMinutes;
  final String label;

  const StudyTaskReminderEntity({
    required this.offsetMinutes,
    required this.label,
  });
}

class StudySubTaskEntity {
  final int id;
  final String title;
  final bool isCompleted;

  const StudySubTaskEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  StudySubTaskEntity copyWith({int? id, String? title, bool? isCompleted}) {
    return StudySubTaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
