class ForgotPasswordResendOtpRequestModel {
  final String email;

  const ForgotPasswordResendOtpRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}