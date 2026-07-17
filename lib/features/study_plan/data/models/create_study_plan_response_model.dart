import 'package:quiz_app_grad/features/study_plan/domain/entities/create_update/create_study_plan_response_entity.dart';

class CreateStudyPlanResponseModel
    extends CreateStudyPlanResponseEntity {
  const CreateStudyPlanResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory CreateStudyPlanResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateStudyPlanResponseModel(
      success: _asBool(json['success']),
      title: _asString(json['title']),
      message: _asString(json['message']),
      statusCode: _asInt(json['status_code']),
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