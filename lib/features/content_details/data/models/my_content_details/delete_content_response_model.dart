import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/delete_content_response_entity.dart';

class DeleteContentResponseModel extends DeleteContentResponseEntity {
  const DeleteContentResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory DeleteContentResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteContentResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }
}