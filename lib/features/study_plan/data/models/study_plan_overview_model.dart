import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';

class StudyPlanOverviewModel extends StudyPlanOverviewEntity {
  const StudyPlanOverviewModel({
    required super.success,
    required super.title,
    required super.data,
    required super.statusCode,
  });

  factory StudyPlanOverviewModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return StudyPlanOverviewModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      data: StudyPlanOverviewDataModel.fromJson(
        rawData is Map<String, dynamic> ? rawData : const <String, dynamic>{},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }
}

class StudyPlanOverviewDataModel extends StudyPlanOverviewDataEntity {
  const StudyPlanOverviewDataModel({
    required super.userSettings,
    required super.serverToday,
    required super.selectedDate,
    required super.range,
    required super.hasDefaultPlan,
    required super.isSelectedDateInsidePlan,
    required super.plan,
    required super.days,
    required super.tasks,
  });

  factory StudyPlanOverviewDataModel.fromJson(Map<String, dynamic> json) {
    final rawSettings = json['userSettings'];
    final rawRange = json['range'];
    final rawPlan = json['plan'];
    final rawDays = json['days'];
    final rawTasks = json['tasks'];

    return StudyPlanOverviewDataModel(
      userSettings: StudyPlanUserSettingsModel.fromJson(
        rawSettings is Map<String, dynamic>
            ? rawSettings
            : const <String, dynamic>{},
      ),
      serverToday: _asString(json['server_today']),
      selectedDate: _asString(json['selected_date']),
      range: StudyPlanRangeModel.fromJson(
        rawRange is Map<String, dynamic> ? rawRange : const <String, dynamic>{},
      ),
      hasDefaultPlan: _asBool(json['has_default_plan']),
      isSelectedDateInsidePlan: json.containsKey('is_selected_date_inside_plan')
          ? _asBool(json['is_selected_date_inside_plan'])
          : null,
      plan: rawPlan is Map<String, dynamic>
          ? StudyPlanSummaryModel.fromJson(rawPlan)
          : null,
      days: rawDays is List
          ? rawDays
                .whereType<Map<String, dynamic>>()
                .map(StudyPlanDayModel.fromJson)
                .toList()
          : const [],
      tasks: rawTasks is List
          ? rawTasks
                .whereType<Map<String, dynamic>>()
                .map(StudyPlanDailyTaskModel.fromJson)
                .toList()
          : const [],
    );
  }
}

class StudyPlanUserSettingsModel extends StudyPlanUserSettingsEntity {
  const StudyPlanUserSettingsModel({
    required super.id,
    required super.weekStartsOn,
    required super.timeFormat,
  });

  factory StudyPlanUserSettingsModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanUserSettingsModel(
      id: _asInt(json['id']),
      weekStartsOn: _asString(json['week_starts_on'], fallback: 'السبت'),
      timeFormat: _asString(json['time_format'], fallback: '12 ساعة'),
    );
  }
}

class StudyPlanRangeModel extends StudyPlanRangeEntity {
  const StudyPlanRangeModel({required super.start, required super.end});

  factory StudyPlanRangeModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanRangeModel(
      start: _asString(json['start']),
      end: _asString(json['end']),
    );
  }
}

class StudyPlanSummaryModel extends StudyPlanSummaryEntity {
  const StudyPlanSummaryModel({
    required super.id,
    required super.emoji,
    required super.title,
    required super.subjectsCount,
    required super.dailyStudyMinutes,
    required super.dailyStudyHours,
    required super.durationDays,
    required super.startDate,
    required super.endDate,
    required super.startsInDays,
    required super.remainingDays,
    required super.isDefault,
    required super.statistics,
    required super.startDateLabel,
    required super.endDateLabel,
  });

  factory StudyPlanSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawStatistics = json['statistics'];

    return StudyPlanSummaryModel(
      id: _asInt(json['id']),
      emoji: _asString(json['emoji']),
      title: _asString(json['title']),
      subjectsCount: _asInt(json['subjects_count']),
      dailyStudyMinutes: _asInt(json['daily_study_minutes']),
      dailyStudyHours: _asInt(json['daily_study_hours']),
      durationDays: _asInt(json['duration_days']),
      startDate: _asString(json['start_date']),
      endDate: _asString(json['end_date']),
      startsInDays: _asInt(json['starts_in_days']),
      remainingDays: _asInt(json['remaining_days']),
      isDefault: _asBool(json['is_default']),
      statistics: StudyPlanStatisticsModel.fromJson(
        rawStatistics is Map<String, dynamic>
            ? rawStatistics
            : const <String, dynamic>{},
      ),

      startDateLabel: json['start_date_label'] ?? '',
      endDateLabel: json['end_date_label'] ?? '',
    );
  }
}

class StudyPlanStatisticsModel extends StudyPlanStatisticsEntity {
  const StudyPlanStatisticsModel({
    required super.tasksCount,
    required super.completedTasksCount,
    required super.missedTasksCount,
    required super.pendingTasksCount,
  });

  factory StudyPlanStatisticsModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanStatisticsModel(
      tasksCount: _asInt(json['tasks_count']),
      completedTasksCount: _asInt(json['completed_tasks_count']),
      missedTasksCount: _asInt(json['missed_tasks_count']),
      pendingTasksCount: _asInt(json['pending_tasks_count']),
    );
  }
}

class StudyPlanDayModel extends StudyPlanDayEntity {
  const StudyPlanDayModel({
    required super.date,
    required super.dayNumber,
    required super.dayName,
    required super.isToday,
    required super.hasTasks,
    required super.totalTasks,
    required super.completedTasks,
    required super.completionState,
    required super.displayState,
  });

  factory StudyPlanDayModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanDayModel(
      date: _asString(json['date']),
      dayNumber: _asInt(json['day_number']),
      dayName: _asString(json['day_name']),
      isToday: _asBool(json['is_today']),
      hasTasks: _asBool(json['has_tasks']),
      totalTasks: _asInt(json['total_tasks']),
      completedTasks: _asInt(json['completed_tasks']),
      completionState: _asString(json['completion_state'], fallback: 'empty'),
      displayState: _asString(json['display_state'], fallback: 'empty'),
    );
  }
}

class StudyPlanDailyTaskModel extends StudyPlanDailyTaskEntity {
  const StudyPlanDailyTaskModel({
    required super.id,
    required super.occurrenceId,
    required super.taskNumber,
    required super.title,
    required super.status,
    required super.priority,
    required super.subtasks,
    required super.time,
  });

  factory StudyPlanDailyTaskModel.fromJson(Map<String, dynamic> json) {
    final rawSubtasks = json['subtasks'];
    final rawTime = json['time'];

    return StudyPlanDailyTaskModel(
      id: _asInt(json['id']),
      occurrenceId: _asInt(json['occurrence_id']),
      taskNumber: _asInt(json['task_number']),
      title: _asString(json['title']),
      status: _normalizeStatus(json['status']),
      priority: _asString(json['priority']),
      subtasks: StudyPlanTaskSubtasksModel.fromJson(
        rawSubtasks is Map<String, dynamic>
            ? rawSubtasks
            : const <String, dynamic>{},
      ),
      time: StudyPlanTaskTimeModel.fromJson(
        rawTime is Map<String, dynamic> ? rawTime : const <String, dynamic>{},
      ),
    );
  }
  static String _normalizeStatus(dynamic value) {
    final status = value?.toString().trim() ?? '';

    switch (status) {
      case 'تم انجازها':
      case 'تم إنجازها':
        return 'تم الإنجاز';

      default:
        return status;
    }
  }
}

class StudyPlanTaskSubtasksModel extends StudyPlanTaskSubtasksEntity {
  const StudyPlanTaskSubtasksModel({
    required super.completed,
    required super.total,
    required super.label,
  });

  factory StudyPlanTaskSubtasksModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanTaskSubtasksModel(
      completed: _asInt(json['completed']),
      total: _asInt(json['total']),
      label: _asString(json['label'], fallback: '0/0'),
    );
  }
}

class StudyPlanTaskTimeModel extends StudyPlanTaskTimeEntity {
  const StudyPlanTaskTimeModel({
    required super.start,
    required super.end,
    required super.durationSeconds,
    required super.durationMinutes,
  });

  factory StudyPlanTaskTimeModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanTaskTimeModel(
      start: _asString(json['start']),
      end: _asString(json['end']),
      durationSeconds: _asInt(json['duration_seconds']),
      durationMinutes: _asInt(json['duration_minutes']),
    );
  }
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;

  if (value is num) {
    return value != 0;
  }

  final normalized = value?.toString().trim().toLowerCase();

  if (normalized == 'true' || normalized == '1') {
    return true;
  }

  if (normalized == 'false' || normalized == '0') {
    return false;
  }

  return fallback;
}
