import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';

class StudySubjectsResponseEntity {
  final bool success;
  final String title;
  final List<StudySubjectEntity> subjects;
  final int statusCode;

  const StudySubjectsResponseEntity({
    required this.success,
    required this.title,
    required this.subjects,
    required this.statusCode,
  });

  bool get hasSubjects => subjects.isNotEmpty;

  bool get isEmpty => subjects.isEmpty;

  StudySubjectsResponseEntity copyWith({
    bool? success,
    String? title,
    List<StudySubjectEntity>? subjects,
    int? statusCode,
  }) {
    return StudySubjectsResponseEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      subjects: subjects ?? this.subjects,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}