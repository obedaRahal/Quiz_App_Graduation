import 'package:quiz_app_grad/features/auth/domain/entities/login_entities/login_user_entity.dart';

class LoginResponseEntity {
  final bool success;
  final String title;
  final LoginUserEntity user;
  final String token;
  final int expiresIn;
  final int statusCode;

  const LoginResponseEntity({
    required this.success,
    required this.title,
    required this.user,
    required this.token,
    required this.expiresIn,
    required this.statusCode,
  });
}