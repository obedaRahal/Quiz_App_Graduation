import 'current_university_models.dart';

DepartmentOption buildDepartmentOption(String id, String name) {
  return DepartmentOption(
    id: id,
    name: name,
    yearsCount: yearsForDepartment(name),
  );
}

int yearsForDepartment(String departmentName) {
  if (departmentName == 'طب بشري') return 6;

  if (departmentName == 'طب الأسنان' ||
      departmentName == 'الصيدلة' ||
      departmentName.contains('هندسة') ||
      departmentName.contains('الهندسة')) {
    return 5;
  }

  return 4;
}

UniversityOption? findSelectedUniversity({
  required List<UniversityOption> universities,
  required String? universityId,
}) {
  if (universityId == null) return null;

  try {
    return universities.firstWhere((item) => item.id == universityId);
  } catch (_) {
    return null;
  }
}

DepartmentOption? findSelectedDepartment({
  required List<DepartmentOption> departments,
  required String? departmentId,
}) {
  if (departmentId == null) return null;

  try {
    return departments.firstWhere((item) => item.id == departmentId);
  } catch (_) {
    return null;
  }
}

String yearLabel(int year) {
  switch (year) {
    case 1:
      return 'السنة الأولى';
    case 2:
      return 'السنة الثانية';
    case 3:
      return 'السنة الثالثة';
    case 4:
      return 'السنة الرابعة';
    case 5:
      return 'السنة الخامسة';
    case 6:
      return 'السنة السادسة';
    default:
      return 'السنة $year';
  }
}
