import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_verify_otp_response_entity.dart';

class ForgotPasswordVerifyOtpResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ForgotPasswordVerifyOtpResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory ForgotPasswordVerifyOtpResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordVerifyOtpResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  ForgotPasswordVerifyOtpResponseEntity toEntity() {
    return ForgotPasswordVerifyOtpResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}