import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_review_action_entity.dart';

class UpdateTestReviewModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const UpdateTestReviewModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory UpdateTestReviewModel.fromJson(Map<String, dynamic> json) {
    return UpdateTestReviewModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  UpdateTestReviewEntity toEntity() {
    return UpdateTestReviewEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}