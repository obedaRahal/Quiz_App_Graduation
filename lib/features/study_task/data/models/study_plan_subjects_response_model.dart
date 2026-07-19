import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';

class StudyPlanSubjectModel extends StudyPlanSubjectEntity {
  const StudyPlanSubjectModel({required super.id, required super.name});

  factory StudyPlanSubjectModel.fromJson(Map<String, dynamic> json) {
    return StudyPlanSubjectModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  String toString() {
    return 'StudyPlanSubjectModel('
        'id: $id, '
        'name: $name'
        ')';
  }
}

class StudyPlanSubjectsResponseModel extends StudyPlanSubjectsResponseEntity {
  const StudyPlanSubjectsResponseModel({
    required super.success,
    required super.title,
    required super.subjects,
    required super.statusCode,
  });

  factory StudyPlanSubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    final subjects = rawData is List
        ? rawData
              .whereType<Map>()
              .map(
                (item) => StudyPlanSubjectModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .where(
                (subject) => subject.id > 0 && subject.name.trim().isNotEmpty,
              )
              .toList(growable: false)
        : <StudyPlanSubjectModel>[];

    return StudyPlanSubjectsResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      subjects: subjects,
      statusCode: _parseInt(json['status_code']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  String toString() {
    return 'StudyPlanSubjectsResponseModel('
        'success: $success, '
        'title: $title, '
        'subjectsCount: ${subjects.length}, '
        'statusCode: $statusCode'
        ')';
  }
}
