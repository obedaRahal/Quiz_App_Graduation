import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';

class StudySubjectModel extends StudySubjectEntity {
  const StudySubjectModel({
    required super.id,
    required super.name,
  });

  factory StudySubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudySubjectModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
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