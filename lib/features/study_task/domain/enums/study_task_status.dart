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
      return StudyTaskStatus.inProgress;

    case 'تم الإنجاز':
      return StudyTaskStatus.completed;

    case 'فائتة':
      return StudyTaskStatus.missed;

    case 'للقيام':
      return StudyTaskStatus.todo;

    default:
      return StudyTaskStatus.todo;
  }
}
