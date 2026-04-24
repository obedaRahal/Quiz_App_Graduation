import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_request_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordRequestOtpUseCase {
  final AuthRepository authRepository;

  ForgotPasswordRequestOtpUseCase(this.authRepository);

  Future<ForgotPasswordRequestOtpResponseEntity> call({
    required String email,
  }) {
    return authRepository.forgotPasswordRequestOtp(email: email);
  }
}