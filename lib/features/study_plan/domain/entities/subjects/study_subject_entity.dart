class StudySubjectEntity {
  final int id;
  final String name;

  const StudySubjectEntity({
    required this.id,
    required this.name,
  });

  StudySubjectEntity copyWith({
    int? id,
    String? name,
  }) {
    return StudySubjectEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'StudySubjectEntity(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StudySubjectEntity &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}