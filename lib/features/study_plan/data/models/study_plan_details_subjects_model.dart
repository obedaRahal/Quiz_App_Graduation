import 'package:quiz_app_grad/features/study_plan/data/models/study_plan_details_subject_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

class StudyPlanDetailsSubjectsModel extends StudyPlanDetailsSubjectsEntity {
  const StudyPlanDetailsSubjectsModel({
    required super.count,
    required super.label,
    required super.items,
  });

  factory StudyPlanDetailsSubjectsModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    final List<StudyPlanDetailsSubjectEntity> items;

    if (rawItems is List) {
      items = rawItems
          .whereType<Map<String, dynamic>>()
          .map<StudyPlanDetailsSubjectEntity>(
            StudyPlanDetailsSubjectModel.fromJson,
          )
          .toList();
    } else {
      items = const <StudyPlanDetailsSubjectEntity>[];
    }

    return StudyPlanDetailsSubjectsModel(
      count: _asInt(json['count'], fallback: items.length),
      label: _asString(json['label'], fallback: '${items.length}/10'),
      items: items,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) {
    return fallback;
  }

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
}
