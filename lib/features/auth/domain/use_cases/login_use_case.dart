import 'package:quiz_app_grad/features/auth/domain/entities/login_entities/login_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<LoginResponseEntity> call({
    required String email,
    required String password,
  }) {
    return authRepository.login(
      email: email,
      password: password,
    );
  }
}