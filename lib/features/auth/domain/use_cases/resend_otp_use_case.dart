import 'package:quiz_app_grad/features/auth/domain/entities/resend_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository authRepository;

  ResendOtpUseCase(this.authRepository);

  Future<ResendOtpResponseEntity> call({
    required String email,
  }) {
    return authRepository.resendOtp(email: email);
  }
}