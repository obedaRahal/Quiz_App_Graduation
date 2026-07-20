enum StudyTaskStatus { todo, inProgress, completed, missed }

extension StudyTaskStatusExtension on StudyTaskStatus {
  String get label {
    switch (this) {
      case StudyTaskStatus.todo:
        return 'للقيام';

      case StudyTaskStatus.inProgress:
        return 'قيد المعالجة';

      case StudyTaskStatus.completed:
        return 'تم الإنجاز';

      case StudyTaskStatus.missed:
        return 'فائتة';
    }
  }

  StudyTaskStatus get nextStatus {
    switch (this) {
      case StudyTaskStatus.todo:
        return StudyTaskStatus.inProgress;

      case StudyTaskStatus.inProgress:
        return StudyTaskStatus.completed;

      case StudyTaskStatus.completed:
        return StudyTaskStatus.todo;

      case StudyTaskStatus.missed:
        return StudyTaskStatus.missed;
    }
  }

  bool get isCompleted {
    return this == StudyTaskStatus.completed;
  }
}

StudyTaskStatus studyTaskStatusFromApi(String value) {
  switch (value.trim()) {
    case 'قيد المعالجة':
    case 'قيد التنفيذ':
      return StudyTaskStatus.inProgress;

    case 'تم الإنجاز':
    case 'تم إنجازها':
    case 'تم انجازها':
    case 'منجزة':
    case 'مكتملة':
      return StudyTaskStatus.completed;

    case 'فائتة':
    case 'فشلت':
      return StudyTaskStatus.missed;

    case 'للقيام':
      return StudyTaskStatus.todo;

    default:
      return StudyTaskStatus.todo;
  }
}
