import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plan_statistics_entity.dart';

class ManagedStudyPlanStatisticsModel
    extends StudyPlanStatisticsEntity {
  const ManagedStudyPlanStatisticsModel({
    required super.tasksCount,
    required super.completedTasksCount,
    required super.missedTasksCount,
    required super.pendingTasksCount,
  });

  factory ManagedStudyPlanStatisticsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ManagedStudyPlanStatisticsModel(
      tasksCount: _asInt(json['tasks_count']),
      completedTasksCount:
          _asInt(json['completed_tasks_count']),
      missedTasksCount:
          _asInt(json['missed_tasks_count']),
      pendingTasksCount:
          _asInt(json['pending_tasks_count']),
    );
  }
}

int _asInt(
  dynamic value, {
  int fallback = 0,
}) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value?.toString() ?? '',
      ) ??
      fallback;
}