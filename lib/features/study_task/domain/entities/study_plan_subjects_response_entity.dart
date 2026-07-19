class StudyPlanSubjectEntity {
  final int id;
  final String name;

  const StudyPlanSubjectEntity({required this.id, required this.name});

  @override
  String toString() {
    return 'StudyPlanSubjectEntity('
        'id: $id, '
        'name: $name'
        ')';
  }
}

class StudyPlanSubjectsResponseEntity {
  final bool success;
  final String title;
  final List<StudyPlanSubjectEntity> subjects;
  final int statusCode;

  const StudyPlanSubjectsResponseEntity({
    required this.success,
    required this.title,
    required this.subjects,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'StudyPlanSubjectsResponseEntity('
        'success: $success, '
        'title: $title, '
        'subjectsCount: ${subjects.length}, '
        'statusCode: $statusCode'
        ')';
  }
}
