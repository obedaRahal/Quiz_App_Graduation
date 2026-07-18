import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';

class StudyPlanDetailsTaskGroupEntity {
  final int count;
  final List<StudyPlanDailyTaskEntity> tasks;

  const StudyPlanDetailsTaskGroupEntity({
    required this.count,
    required this.tasks,
  });

  bool get isEmpty => tasks.isEmpty;

  bool get isNotEmpty => tasks.isNotEmpty;
}
