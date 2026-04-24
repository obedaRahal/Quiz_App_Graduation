class ForgotPasswordVerifyOtpResponseEntity {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const ForgotPasswordVerifyOtpResponseEntity({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });
}