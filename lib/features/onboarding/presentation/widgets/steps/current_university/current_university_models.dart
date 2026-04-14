class UniversityOption {
  final String id;
  final String name;
  final String? logoPath;
  final bool isPrivate;
  final List<DepartmentOption> departments;

  const UniversityOption({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.isPrivate,
    required this.departments,
  });
}

class DepartmentOption {
  final String id;
  final String name;
  final int yearsCount;

  const DepartmentOption({
    required this.id,
    required this.name,
    required this.yearsCount,
  });
}