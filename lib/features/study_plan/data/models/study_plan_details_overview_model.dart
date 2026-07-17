import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_details_progress_model.dart';
import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_details_subjects_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

class StudyPlanDetailsOverviewModel extends StudyPlanDetailsOverviewEntity {
  const StudyPlanDetailsOverviewModel({
    required super.success,
    required super.title,
    required super.statusCode,
    required super.id,
    required super.planTitle,
    required super.emoji,
    required super.subjects,
    required super.progress,
  });

  factory StudyPlanDetailsOverviewModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    final Map<String, dynamic> data = rawData is Map<String, dynamic>
        ? rawData
        : <String, dynamic>{};

    final rawSubjects = data['subjects'];

    final Map<String, dynamic> subjectsJson =
        rawSubjects is Map<String, dynamic> ? rawSubjects : <String, dynamic>{};

    final rawProgress = data['progress'];

    final Map<String, dynamic> progressJson =
        rawProgress is Map<String, dynamic> ? rawProgress : <String, dynamic>{};

    return StudyPlanDetailsOverviewModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      statusCode: _asInt(json['status_code']),
      id: _asInt(data['id']),
      planTitle: _asString(data['title']),
      emoji: _asString(data['emoji'], fallback: '📚'),
      subjects: StudyPlanDetailsSubjectsModel.fromJson(subjectsJson),
      progress: StudyPlanDetailsProgressModel.fromJson(progressJson),
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

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) {
    return value;
  }

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
