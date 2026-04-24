import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_resend_otp_response_entity.dart';

class ForgotPasswordResendOtpResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ForgotPasswordResendOtpResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory ForgotPasswordResendOtpResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ForgotPasswordResendOtpResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  ForgotPasswordResendOtpResponseEntity toEntity() {
    return ForgotPasswordResendOtpResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}