import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

class StudyPlanDetailsSubjectModel extends StudyPlanDetailsSubjectEntity {
  const StudyPlanDetailsSubjectModel({required super.id, required super.name});

  factory StudyPlanDetailsSubjectModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanDetailsSubjectModel(
      id: _asInt(json['id']),
      name: _asString(json['name']),
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



