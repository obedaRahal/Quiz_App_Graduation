class GetStudyTaskDetailsParams {
  final int planId;
  final int taskId;

  const GetStudyTaskDetailsParams({required this.planId, required this.taskId});

  @override
  String toString() {
    return 'GetStudyTaskDetailsParams('
        'planId: $planId, '
        'taskId: $taskId'
        ')';
  }
}
