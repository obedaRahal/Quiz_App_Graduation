class StudyPlanStatisticsEntity {
  final int tasksCount;
  final int completedTasksCount;
  final int missedTasksCount;
  final int pendingTasksCount;

  const StudyPlanStatisticsEntity({
    required this.tasksCount,
    required this.completedTasksCount,
    required this.missedTasksCount,
    required this.pendingTasksCount,
  });

  int get resolvedTasksCount {
    return completedTasksCount + missedTasksCount;
  }

  double get completionProgress {
    if (tasksCount <= 0) {
      return 0;
    }

    return (completedTasksCount / tasksCount).clamp(
      0.0,
      1.0,
    );
  }
}