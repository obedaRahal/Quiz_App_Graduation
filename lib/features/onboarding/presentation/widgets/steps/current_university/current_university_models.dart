class UniversityOption {
  final String title;
  final bool isPrivate;
  final List<DepartmentOption> departments;

  const UniversityOption({
    required this.title,
    required this.isPrivate,
    required this.departments,
  });
}

class DepartmentOption {
  final String title;
  final int yearsCount;

  const DepartmentOption({
    required this.title,
    required this.yearsCount,
  });
}