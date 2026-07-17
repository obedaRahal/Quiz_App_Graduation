import 'package:quiz_app_grad/features/study_plan/data/models/study_subject_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subjects_response_entity.dart';

class StudySubjectsResponseModel
    extends StudySubjectsResponseEntity {
  const StudySubjectsResponseModel({
    required super.success,
    required super.title,
    required super.subjects,
    required super.statusCode,
  });

  factory StudySubjectsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    return StudySubjectsResponseModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      subjects: rawData is List
          ? rawData
                .whereType<Map<String, dynamic>>()
                .map(StudySubjectModel.fromJson)
                .toList()
          : const [],
      statusCode: _asInt(json['status_code']),
    );
  }
}

String _asString(
  dynamic value, {
  String fallback = '',
}) {
  if (value == null) return fallback;

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
}

int _asInt(
  dynamic value, {
  int fallback = 0,
}) {
  if (value is int) return value;

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
  if (value is bool) return value;

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