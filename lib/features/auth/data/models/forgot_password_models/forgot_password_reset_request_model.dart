class ForgotPasswordResetRequestModel {
  final String email;
  final String otpCode;
  final String password;
  final String passwordConfirmation;

  const ForgotPasswordResetRequestModel({
    required this.email,
    required this.otpCode,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp_code': otpCode,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}