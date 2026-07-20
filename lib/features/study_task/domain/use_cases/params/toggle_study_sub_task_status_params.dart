class ToggleStudySubTaskStatusParams {
  final int planId;
  final int taskId;
  final int subTaskId;
  final bool complete;

  const ToggleStudySubTaskStatusParams({
    required this.planId,
    required this.taskId,
    required this.subTaskId,
    required this.complete,
  });

  bool get isValid {
    return planId > 0 && taskId > 0 && subTaskId > 0;
  }

  @override
  String toString() {
    return 'ToggleStudySubTaskStatusParams('
        'planId: $planId, '
        'taskId: $taskId, '
        'subTaskId: $subTaskId, '
        'complete: $complete'
        ')';
  }
}
