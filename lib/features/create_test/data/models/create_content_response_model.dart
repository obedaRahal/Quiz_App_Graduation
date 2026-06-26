import 'package:quiz_app_grad/features/create_test/domain/entities/create_content_response_entity.dart';

class CreateContentResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const CreateContentResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory CreateContentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateContentResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      statusCode: _asInt(json['status_code']),
    );
  }

  CreateContentResponseEntity toEntity() {
    return CreateContentResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}