import 'package:quiz_app_grad/features/auth/domain/entities/resend_otp_response_entity.dart';

class ResendOtpResponseModel {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ResendOtpResponseModel({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['status_code'] ?? 0,
    );
  }

  ResendOtpResponseEntity toEntity() {
    return ResendOtpResponseEntity(
      success: success,
      title: title,
      message: message,
      statusCode: statusCode,
    );
  }
}