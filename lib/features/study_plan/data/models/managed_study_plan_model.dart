import 'package:quiz_app_grad/features/study_plan/data/models/managed_study_plan_statistics_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';

class ManagedStudyPlanModel
    extends ManagedStudyPlanEntity {
  const ManagedStudyPlanModel({
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
  });

  factory ManagedStudyPlanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawStatistics = json['statistics'];

    return ManagedStudyPlanModel(
      id: _asInt(json['id']),
      emoji: _asString(json['emoji']),
      title: _asString(json['title']),
      subjectsCount:
          _asInt(json['subjects_count']),
      dailyStudyMinutes:
          _asInt(json['daily_study_minutes']),
      dailyStudyHours:
          _asInt(json['daily_study_hours']),
      durationDays:
          _asInt(json['duration_days']),
      startDate:
          _asString(json['start_date']),
      endDate:
          _asString(json['end_date']),
      startsInDays:
          _asInt(json['starts_in_days']),
      remainingDays:
          _asInt(json['remaining_days']),
      isDefault:
          _asBool(json['is_default']),
      statistics:
          rawStatistics is Map<String, dynamic>
              ? ManagedStudyPlanStatisticsModel
                  .fromJson(
                  rawStatistics,
                )
              : const ManagedStudyPlanStatisticsModel(
                  tasksCount: 0,
                  completedTasksCount: 0,
                  missedTasksCount: 0,
                  pendingTasksCount: 0,
                ),
    );
  }
}

String _asString(
  dynamic value, {
  String fallback = '',
}) {
  if (value == null) {
    return fallback;
  }

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
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

bool _asBool(
  dynamic value, {
  bool fallback = false,
}) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized =
      value?.toString().trim().toLowerCase();

  if (normalized == 'true' ||
      normalized == '1') {
    return true;
  }

  if (normalized == 'false' ||
      normalized == '0') {
    return false;
  }

  return fallback;
}