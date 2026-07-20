import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';

enum StudyPlanTaskPriority { low, medium, high, unknown }

extension StudyPlanTaskPriorityX on StudyPlanTaskPriority {
  static StudyPlanTaskPriority fromApi(String value) {
    switch (value.trim()) {
      case 'منخفضة':
        return StudyPlanTaskPriority.low;

      case 'متوسطة':
        return StudyPlanTaskPriority.medium;

      case 'عالية':
        return StudyPlanTaskPriority.high;

      default:
        return StudyPlanTaskPriority.unknown;
    }
  }
}

class StudyPlanDailyTaskEntity {
  final int id;
  final int occurrenceId;
  final int taskNumber;
  final String title;
  final String status;
  final String priority;
  final StudyPlanTaskSubtasksEntity subtasks;
  final StudyPlanTaskTimeEntity time;

  const StudyPlanDailyTaskEntity({
    required this.id,
    required this.occurrenceId,
    required this.taskNumber,
    required this.title,
    required this.status,
    required this.priority,
    required this.subtasks,
    required this.time,
  });

  StudyPlanTaskPriority get parsedPriority {
    return StudyPlanTaskPriorityX.fromApi(priority);
  }

  StudyTaskStatus get parsedStatus {
    return studyTaskStatusFromApi(status);
  }

  bool get hasSubtasks => subtasks.total > 0;

  bool get hasTime {
    return time.start.trim().isNotEmpty || time.end.trim().isNotEmpty;
  }

  bool get isCompleted {
    return parsedStatus.isCompleted;
  }

  StudyPlanDailyTaskEntity copyWith({
    int? id,
    int? occurrenceId,
    int? taskNumber,
    String? title,
    String? status,
    String? priority,
    StudyPlanTaskSubtasksEntity? subtasks,
    StudyPlanTaskTimeEntity? time,
  }) {
    return StudyPlanDailyTaskEntity(
      id: id ?? this.id,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      taskNumber: taskNumber ?? this.taskNumber,
      title: title ?? this.title,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      subtasks: subtasks ?? this.subtasks,
      time: time ?? this.time,
    );
  }
}

class StudyPlanTaskSubtasksEntity {
  final int completed;
  final int total;
  final String label;

  const StudyPlanTaskSubtasksEntity({
    required this.completed,
    required this.total,
    required this.label,
  });

  StudyPlanTaskSubtasksEntity copyWith({
    int? completed,
    int? total,
    String? label,
  }) {
    return StudyPlanTaskSubtasksEntity(
      completed: completed ?? this.completed,
      total: total ?? this.total,
      label: label ?? this.label,
    );
  }
}

class StudyPlanTaskTimeEntity {
  final String start;
  final String end;
  final int durationSeconds;
  final int durationMinutes;

  const StudyPlanTaskTimeEntity({
    required this.start,
    required this.end,
    required this.durationSeconds,
    required this.durationMinutes,
  });

  StudyPlanTaskTimeEntity copyWith({
    String? start,
    String? end,
    int? durationSeconds,
    int? durationMinutes,
  }) {
    return StudyPlanTaskTimeEntity(
      start: start ?? this.start,
      end: end ?? this.end,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
