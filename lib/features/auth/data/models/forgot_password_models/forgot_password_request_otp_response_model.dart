import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_request_otp_response_entity.dart';

class ForgotPasswordRequestOtpResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ForgotPasswordRequestOtpResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory ForgotPasswordRequestOtpResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordRequestOtpResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  ForgotPasswordRequestOtpResponseEntity toEntity() {
    return ForgotPasswordRequestOtpResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}