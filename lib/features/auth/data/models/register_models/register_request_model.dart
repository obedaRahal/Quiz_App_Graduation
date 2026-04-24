class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String gender;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
    };
  }
}