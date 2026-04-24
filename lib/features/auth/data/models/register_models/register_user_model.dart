class RegisterUserModel {
  final String name;
  final String email;
  final String gender;

  const RegisterUserModel({
    required this.name,
    required this.email,
    required this.gender,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}