enum StudyTaskPriority { low, medium, high, unknown }

extension StudyTaskPriorityExtension on StudyTaskPriority {
  String get label {
    switch (this) {
      case StudyTaskPriority.low:
        return 'منخفضة';

      case StudyTaskPriority.medium:
        return 'متوسطة';

      case StudyTaskPriority.high:
        return 'عالية';

      case StudyTaskPriority.unknown:
        return 'غير محددة';
    }
  }
}

StudyTaskPriority studyTaskPriorityFromApi(String value) {
  switch (value.trim()) {
    case 'منخفضة':
      return StudyTaskPriority.low;

    case 'متوسطة':
      return StudyTaskPriority.medium;

    case 'عالية':
      return StudyTaskPriority.high;

    default:
      return StudyTaskPriority.unknown;
  }
}
