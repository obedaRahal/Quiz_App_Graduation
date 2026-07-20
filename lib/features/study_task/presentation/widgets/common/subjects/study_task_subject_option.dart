class StudyTaskSubjectOption {
  final int id;
  final String name;

  const StudyTaskSubjectOption({required this.id, required this.name});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StudyTaskSubjectOption &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
