import '../../domain/entities/review_feedback_action_entity.dart';

class ReviewFeedbackActionModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ReviewFeedbackActionModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory ReviewFeedbackActionModel.fromJson(Map<String, dynamic> json) {
    return ReviewFeedbackActionModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  ReviewFeedbackActionEntity toEntity() {
    return ReviewFeedbackActionEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}