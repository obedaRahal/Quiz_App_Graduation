class RegisterResponseEntity {
  final String name;
  final String email;
  final String gender;
  final String otpCode;
  final String title;

  const RegisterResponseEntity({
    required this.name,
    required this.email,
    required this.gender,
    required this.otpCode,
    required this.title,
  });
}