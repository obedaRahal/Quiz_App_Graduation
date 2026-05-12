import '../../domain/entities/delete_test_review_entity.dart';

class DeleteTestReviewModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const DeleteTestReviewModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory DeleteTestReviewModel.fromJson(Map<String, dynamic> json) {
    return DeleteTestReviewModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  DeleteTestReviewEntity toEntity() {
    return DeleteTestReviewEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}
