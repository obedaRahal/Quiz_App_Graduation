import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_verify_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordVerifyOtpUseCase {
  final AuthRepository authRepository;

  ForgotPasswordVerifyOtpUseCase(this.authRepository);

  Future<ForgotPasswordVerifyOtpResponseEntity> call({
    required String email,
    required String otpCode,
  }) {
    return authRepository.forgotPasswordVerifyOtp(
      email: email,
      otpCode: otpCode,
    );
  }
}