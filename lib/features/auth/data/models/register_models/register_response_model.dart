import 'package:quiz_app_grad/features/auth/data/models/register_models/register_user_model.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/register_response_entity.dart';

class RegisterResponseModel {
  final RegisterUserModel user;
  final String otpCode;
  final String title;

  const RegisterResponseModel({
    required this.user,
    required this.otpCode,
    required this.title,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return RegisterResponseModel(
      user: RegisterUserModel.fromJson(data['user'] ?? {}),
      otpCode: data['otpCode'] ?? '',
      title: json['title'] ?? '',
    );
  }

  RegisterResponseEntity toEntity() {
    return RegisterResponseEntity(
      name: user.name,
      email: user.email,
      gender: user.gender,
      otpCode: otpCode,
      title: title,
    );
  }
}