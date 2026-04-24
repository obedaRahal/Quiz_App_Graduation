import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_reset_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordResetUseCase {
  final AuthRepository authRepository;

  ForgotPasswordResetUseCase(this.authRepository);

  Future<ForgotPasswordResetResponseEntity> call({
    required String email,
    required String otpCode,
    required String password,
    required String passwordConfirmation,
  }) {
    return authRepository.forgotPasswordReset(
      email: email,
      otpCode: otpCode,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}