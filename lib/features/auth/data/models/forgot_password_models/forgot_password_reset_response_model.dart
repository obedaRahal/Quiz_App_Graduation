import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_reset_response_entity.dart';

class ForgotPasswordResetResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ForgotPasswordResetResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory ForgotPasswordResetResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordResetResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  ForgotPasswordResetResponseEntity toEntity() {
    return ForgotPasswordResetResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}