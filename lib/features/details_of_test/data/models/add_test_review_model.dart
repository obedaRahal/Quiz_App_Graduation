import '../../domain/entities/add_test_review_entity.dart';

class AddTestReviewModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const AddTestReviewModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory AddTestReviewModel.fromJson(Map<String, dynamic> json) {
    return AddTestReviewModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  AddTestReviewEntity toEntity() {
    return AddTestReviewEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}
