enum StudyTaskStatus { todo, inProgress, completed }

extension StudyTaskStatusExtension on StudyTaskStatus {
  String get label {
    switch (this) {
      case StudyTaskStatus.todo:
        return 'للقيام';

      case StudyTaskStatus.inProgress:
        return 'قيد المعالجة';

      case StudyTaskStatus.completed:
        return 'تم الإنجاز';
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

    case 'للقيام':
    default:
      return StudyTaskStatus.todo;
  }
}
