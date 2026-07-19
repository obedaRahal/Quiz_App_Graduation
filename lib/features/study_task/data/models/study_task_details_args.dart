class StudyTaskDetailsArgs {
  final int planId;
  final int taskId;

  const StudyTaskDetailsArgs({required this.planId, required this.taskId});

  @override
  String toString() {
    return 'StudyTaskDetailsArgs('
        'planId: $planId, '
        'taskId: $taskId'
        ')';
  }
}
