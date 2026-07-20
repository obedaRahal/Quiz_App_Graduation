import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';

class ChangeStudyTaskStatusParams {
  final int planId;
  final int taskId;
  final StudyTaskStatus targetStatus;

  const ChangeStudyTaskStatusParams({
    required this.planId,
    required this.taskId,
    required this.targetStatus,
  });

  bool get isValid {
    return planId > 0 && taskId > 0 && targetStatus != StudyTaskStatus.missed;
  }

  @override
  String toString() {
    return 'ChangeStudyTaskStatusParams('
        'planId: $planId, '
        'taskId: $taskId, '
        'targetStatus: $targetStatus'
        ')';
  }
}
