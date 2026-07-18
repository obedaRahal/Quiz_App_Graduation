import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_details_task_group_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_tasks_entity.dart';

class StudyPlanDetailsTasksModel extends StudyPlanDetailsTasksEntity {
  const StudyPlanDetailsTasksModel({
    required super.success,
    required super.title,
    required super.old,
    required super.upcoming,
    required super.completed,
    required super.statusCode,
  });

  factory StudyPlanDetailsTasksModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);

    return StudyPlanDetailsTasksModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      old: StudyPlanDetailsTaskGroupModel.fromJson(_asMap(data['old'])),
      upcoming: StudyPlanDetailsTaskGroupModel.fromJson(
        _asMap(data['upcoming']),
      ),
      completed: StudyPlanDetailsTaskGroupModel.fromJson(
        _asMap(data['completed']),
      ),
      statusCode: _parseInt(json['status_code']),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
