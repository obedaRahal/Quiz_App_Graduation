class UpdateStudyTaskArgs {
  final int planId;
  final int taskId;

  const UpdateStudyTaskArgs({required this.planId, required this.taskId});

  bool get isValid {
    return planId > 0 && taskId > 0;
  }

  @override
  String toString() {
    return 'UpdateStudyTaskArgs('
        'planId: $planId, '
        'taskId: $taskId'
        ')';
  }
}
