class VerifyEmailRequestModel {
  final String email;
  final String otpCode;

  const VerifyEmailRequestModel({
    required this.email,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp_code': otpCode,
    };
  }
}