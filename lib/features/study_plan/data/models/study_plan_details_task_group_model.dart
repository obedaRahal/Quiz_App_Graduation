import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_overview_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_task_group_entity.dart';

class StudyPlanDetailsTaskGroupModel extends StudyPlanDetailsTaskGroupEntity {
  const StudyPlanDetailsTaskGroupModel({
    required super.count,
    required super.tasks,
  });

  factory StudyPlanDetailsTaskGroupModel.fromJson(Map<String, dynamic> json) {
    final rawTasks = json['tasks'];

    final tasks = rawTasks is List
        ? rawTasks
              .whereType<Map<String, dynamic>>()
              .map(StudyPlanDailyTaskModel.fromJson)
              .toList()
        : const <StudyPlanDailyTaskModel>[];

    return StudyPlanDetailsTaskGroupModel(
      count: _parseInt(json['count'], fallback: tasks.length),
      tasks: tasks,
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  
}
