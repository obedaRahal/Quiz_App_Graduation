import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/delete_study_plan_entity.dart';

class DeleteStudyPlanModel extends DeleteStudyPlanEntity {
  const DeleteStudyPlanModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory DeleteStudyPlanModel.fromJson(Map<String, dynamic> json) {
    debugPrint('============ DeleteStudyPlanModel.fromJson ============');
    debugPrint('→ json: $json');

    final model = DeleteStudyPlanModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      message: _asString(json['message']),
      statusCode: _asInt(json['status_code']),
    );

    debugPrint('→ parsed model: $model');
    debugPrint('=======================================================');

    return model;
  }

  static bool _asBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' || normalized == '1';
    }

    return false;
  }

  static String _asString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static int _asInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
