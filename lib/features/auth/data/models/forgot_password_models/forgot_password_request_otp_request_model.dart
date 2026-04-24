class ForgotPasswordRequestOtpRequestModel {
  final String email;

  const ForgotPasswordRequestOtpRequestModel({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}