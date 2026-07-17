import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

class StudyPlanDetailsProgressModel extends StudyPlanDetailsProgressEntity {
  const StudyPlanDetailsProgressModel({
    required super.remainingDays,
    required super.elapsedDays,
    required super.totalDays,
    required super.elapsedLabel,
    required super.startDate,
    required super.endDate,
    required super.completedTasksCount,
    required super.totalTasksCount,
    required super.completedPercentage,
  });

  factory StudyPlanDetailsProgressModel.fromJson(Map<String, dynamic> json) {
    final elapsedDays = _asInt(json['elapsed_days']);

    final totalDays = _asInt(json['total_days']);

    return StudyPlanDetailsProgressModel(
      remainingDays: _asInt(json['remaining_days']),
      elapsedDays: elapsedDays,
      totalDays: totalDays,
      elapsedLabel: _asString(
        json['elapsed_label'],
        fallback: '$elapsedDays/$totalDays',
      ),
      startDate: _asString(json['start_date']),
      endDate: _asString(json['end_date']),
      completedTasksCount: _asInt(json['completed_tasks_count']),
      totalTasksCount: _asInt(json['total_tasks_count']),
      completedPercentage: _asDouble(json['completed_percentage']),
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
}
