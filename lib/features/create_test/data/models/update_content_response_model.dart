import '../../domain/entities/update_content_response_entity.dart';

class UpdateContentResponseModel extends UpdateContentResponseEntity {
  const UpdateContentResponseModel({
    required super.success,
    required super.title,
    required super.message,
    required super.statusCode,
  });

  factory UpdateContentResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateContentResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }
}