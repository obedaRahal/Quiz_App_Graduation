import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_request_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_resend_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_reset_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_verify_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/login_entities/login_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/resend_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/verify_email_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/register_response_entity.dart';

abstract class AuthRepository {
  Future<RegisterResponseEntity> register({
    required String name,
    required String email,
    required String password,
    required String gender,
  });
  Future<VerifyEmailResponseEntity> verifyEmail({
    required String email,
    required String otpCode,
  });
  Future<LoginResponseEntity> login({
    required String email,
    required String password,
  });
  Future<ResendOtpResponseEntity> resendOtp({required String email});
  Future<ForgotPasswordRequestOtpResponseEntity> forgotPasswordRequestOtp({
  required String email,
});
Future<ForgotPasswordVerifyOtpResponseEntity> forgotPasswordVerifyOtp({
  required String email,
  required String otpCode,
});
Future<ForgotPasswordResendOtpResponseEntity> forgotPasswordResendOtp({
  required String email,
});
Future<ForgotPasswordResetResponseEntity> forgotPasswordReset({
  required String email,
  required String otpCode,
  required String password,
  required String passwordConfirmation,
});
}
