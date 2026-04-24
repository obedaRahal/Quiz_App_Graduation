import 'package:quiz_app_grad/features/auth/domain/entities/verify_email_response_entity.dart';

class VerifyEmailResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const VerifyEmailResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  VerifyEmailResponseEntity toEntity() {
    return VerifyEmailResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}