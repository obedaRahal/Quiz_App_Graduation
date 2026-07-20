class DeleteStudyTaskParams {
  final int planId;
  final int taskId;

  const DeleteStudyTaskParams({required this.planId, required this.taskId});

  bool get isValid {
    return planId > 0 && taskId > 0;
  }

  @override
  String toString() {
    return 'DeleteStudyTaskParams('
        'planId: $planId, '
        'taskId: $taskId'
        ')';
  }
}
