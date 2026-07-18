import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_task_group_entity.dart';

class StudyPlanDetailsTasksEntity {
  final bool success;
  final String title;
  final StudyPlanDetailsTaskGroupEntity old;
  final StudyPlanDetailsTaskGroupEntity upcoming;
  final StudyPlanDetailsTaskGroupEntity completed;
  final int statusCode;

  const StudyPlanDetailsTasksEntity({
    required this.success,
    required this.title,
    required this.old,
    required this.upcoming,
    required this.completed,
    required this.statusCode,
  });

  int get totalCount {
    return old.count + upcoming.count + completed.count;
  }

  bool get hasTasks => totalCount > 0;
}
