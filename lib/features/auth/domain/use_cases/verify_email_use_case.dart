import 'package:quiz_app_grad/features/auth/domain/entities/verify_email_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository authRepository;

  VerifyEmailUseCase(this.authRepository);

  Future<VerifyEmailResponseEntity> call({
    required String email,
    required String otpCode,
  }) {
    return authRepository.verifyEmail(
      email: email,
      otpCode: otpCode,
    );
  }
}