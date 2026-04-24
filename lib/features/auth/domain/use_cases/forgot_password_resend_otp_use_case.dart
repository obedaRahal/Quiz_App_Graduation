import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_resend_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordResendOtpUseCase {
  final AuthRepository authRepository;

  ForgotPasswordResendOtpUseCase(this.authRepository);

  Future<ForgotPasswordResendOtpResponseEntity> call({
    required String email,
  }) {
    return authRepository.forgotPasswordResendOtp(email: email);
  }
}