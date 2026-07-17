class CreateStudySubjectParams {
  final String name;

  const CreateStudySubjectParams({
    required this.name,
  });

  Map<String, dynamic> toBody() {
    return {
      'name': name.trim(),
    };
  }

  @override
  String toString() {
    return 'CreateStudySubjectParams(name: ${name.trim()})';
  }
}