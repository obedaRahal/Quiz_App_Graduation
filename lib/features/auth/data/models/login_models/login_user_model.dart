import 'package:quiz_app_grad/features/auth/domain/entities/login_entities/login_user_entity.dart';

class LoginUserModel {
  final int id;
  final String name;
  final String gender;

  const LoginUserModel({
    required this.id,
    required this.name,
    required this.gender,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  LoginUserEntity toEntity() {
    return LoginUserEntity(
      id: id,
      name: name,
      gender: gender,
    );
  }
}