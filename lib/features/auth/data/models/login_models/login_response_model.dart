import 'package:quiz_app_grad/features/auth/data/models/login_models/login_user_model.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/login_entities/login_response_entity.dart';

class LoginResponseModel {
  final bool success;
  final String title;
  final LoginUserModel user;
  final String token;
  final int expiresIn;
  final int statusCode;

  const LoginResponseModel({
    required this.success,
    required this.title,
    required this.user,
    required this.token,
    required this.expiresIn,
    required this.statusCode,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return LoginResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      user: LoginUserModel.fromJson(data['user'] ?? {}),
      token: data['token'] ?? '',
      expiresIn: data['expires_in'] ?? 0,
      statusCode: json['status_code'] ?? 0,
    );
  }

  LoginResponseEntity toEntity() {
    return LoginResponseEntity(
      success: success,
      title: title,
      user: user.toEntity(),
      token: token,
      expiresIn: expiresIn,
      statusCode: statusCode,
    );
  }
}