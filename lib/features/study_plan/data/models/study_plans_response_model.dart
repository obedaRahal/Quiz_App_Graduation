import 'package:quiz_app_grad/features/study_plan/data/models/managed_study_plan_model.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plans_response_entity.dart';

class StudyPlansResponseModel
    extends StudyPlansResponseEntity {
  const StudyPlansResponseModel({
    required super.success,
    required super.title,
    required super.plansCount,
    required super.plans,
    required super.statusCode,
  });

  factory StudyPlansResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    final Map<String, dynamic> data =
        rawData is Map<String, dynamic>
            ? rawData
            : <String, dynamic>{};

    final rawPlans = data['plans'];

    final List<ManagedStudyPlanEntity> plans;

    if (rawPlans is List) {
      plans = rawPlans
          .whereType<Map<String, dynamic>>()
          .map<ManagedStudyPlanEntity>(
            (item) =>
                ManagedStudyPlanModel.fromJson(item),
          )
          .toList();
    } else {
      plans = const <ManagedStudyPlanEntity>[];
    }

    return StudyPlansResponseModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      plansCount:
          _asInt(data['plans_count']),
      plans: plans,
      statusCode:
          _asInt(json['status_code']),
    );
  }
}

String _asString(
  dynamic value, {
  String fallback = '',
}) {
  if (value == null) {
    return fallback;
  }

  final result = value.toString().trim();

  return result.isEmpty ? fallback : result;
}

int _asInt(
  dynamic value, {
  int fallback = 0,
}) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value?.toString() ?? '',
      ) ??
      fallback;
}

bool _asBool(
  dynamic value, {
  bool fallback = false,
}) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final normalized =
      value?.toString().trim().toLowerCase();

  if (normalized == 'true' ||
      normalized == '1') {
    return true;
  }

  if (normalized == 'false' ||
      normalized == '0') {
    return false;
  }

  return fallback;
}