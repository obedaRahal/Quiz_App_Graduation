import 'package:quiz_app_grad/features/create_test/domain/entities/update_test_response_entity.dart';

class UpdateTestResponseModel {
  final bool success;
  final String title;
  final UpdateTestDataModel data;
  final int statusCode;

  const UpdateTestResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory UpdateTestResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateTestResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      data: UpdateTestDataModel.fromJson(
        (json['data'] as Map?)?.cast<String, dynamic>() ?? {},
      ),
      statusCode: _asInt(json['status_code']),
    );
  }

  UpdateTestResponseEntity toEntity() {
    return UpdateTestResponseEntity(
      success: success,
      title: title,
      data: data.toEntity(),
      statusCode: statusCode,
    );
  }
}

class UpdateTestDataModel {
  final int testId;
  final String reviewStatus;
  final bool requiresReview;
  final bool statusChanged;
  final String message;

  const UpdateTestDataModel({
    required this.testId,
    required this.reviewStatus,
    required this.requiresReview,
    required this.statusChanged,
    required this.message,
  });

  factory UpdateTestDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateTestDataModel(
      testId: _asInt(json['test_id']),
      reviewStatus: json['review_status']?.toString() ?? '',
      requiresReview: json['requires_review'] == true,
      statusChanged: json['status_changed'] == true,
      message: json['message']?.toString() ?? '',
    );
  }

  UpdateTestDataEntity toEntity() {
    return UpdateTestDataEntity(
      testId: testId,
      reviewStatus: reviewStatus,
      requiresReview: requiresReview,
      statusChanged: statusChanged,
      message: message,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}