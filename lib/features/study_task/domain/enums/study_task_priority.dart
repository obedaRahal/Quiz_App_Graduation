enum StudyTaskPriority { low, medium, high, unknown }

const selectableStudyTaskPriorities = <StudyTaskPriority>[
  StudyTaskPriority.low,
  StudyTaskPriority.medium,
  StudyTaskPriority.high,
];

extension StudyTaskPriorityExtension on StudyTaskPriority {
  bool get isKnown => this != StudyTaskPriority.unknown;

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

  String get apiValue {
    switch (this) {
      case StudyTaskPriority.low:
        return 'منخفضة';

      case StudyTaskPriority.medium:
        return 'متوسطة';

      case StudyTaskPriority.high:
        return 'عالية';

      case StudyTaskPriority.unknown:
        return '';
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
