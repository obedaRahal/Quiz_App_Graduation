import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_request_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_resend_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_reset_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_verify_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/login_models/login_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/register_models/register_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/resend_otp_models/resend_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/verify_email_models/verify_email_request_model.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_request_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_resend_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_reset_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/forgot_password_entities/forgot_password_verify_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/login_entities/login_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/resend_otp_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/verify_email_response_entity.dart';
import 'package:quiz_app_grad/features/auth/domain/entities/register_response_entity.dart';

import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<RegisterResponseEntity> register({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    final result = await authRemoteDataSource.register(
      RegisterRequestModel(
        name: name,
        email: email,
        password: password,
        gender: gender,
      ),
    );
    debugPrint(result.otpCode);

    return result.toEntity();
  }

  @override
  Future<VerifyEmailResponseEntity> verifyEmail({
    required String email,
    required String otpCode,
  }) async {
    final result = await authRemoteDataSource.verifyEmail(
      VerifyEmailRequestModel(email: email, otpCode: otpCode),
    );
    return result.toEntity();
  }

  @override
  Future<LoginResponseEntity> login({
    required String email,
    required String password,
  }) async {
    debugPrint("============ AuthRepositoryImpl.login ============");
    debugPrint("→ email: $email");

    final result = await authRemoteDataSource.login(
      LoginRequestModel(email: email, password: password),
    );

    debugPrint("✓ login API success: ${result.title}");
    debugPrint("→ token length: ${result.token.length}");
    debugPrint("→ expiresIn: ${result.expiresIn}");

    await TokenStorage.saveAccessToken(
      token: result.token,
      expiresInSeconds: result.expiresIn,
    );

    debugPrint("✓ access token saved successfully");
    debugPrint("=================================================");

    return result.toEntity();
  }

  @override
  Future<ResendOtpResponseEntity> resendOtp({required String email}) async {
    final result = await authRemoteDataSource.resendOtp(
      ResendOtpRequestModel(email: email),
    );

    return result.toEntity();
  }

  @override
  Future<ForgotPasswordRequestOtpResponseEntity> forgotPasswordRequestOtp({
    required String email,
  }) async {
    final result = await authRemoteDataSource.forgotPasswordRequestOtp(
      ForgotPasswordRequestOtpRequestModel(email: email),
    );

    return result.toEntity();
  }

  @override
  Future<ForgotPasswordVerifyOtpResponseEntity> forgotPasswordVerifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final result = await authRemoteDataSource.forgotPasswordVerifyOtp(
      ForgotPasswordVerifyOtpRequestModel(email: email, otpCode: otpCode),
    );

    return result.toEntity();
  }

  @override
  Future<ForgotPasswordResendOtpResponseEntity> forgotPasswordResendOtp({
    required String email,
  }) async {
    final result = await authRemoteDataSource.forgotPasswordResendOtp(
      ForgotPasswordResendOtpRequestModel(email: email),
    );

    return result.toEntity();
  }

  @override
  Future<ForgotPasswordResetResponseEntity> forgotPasswordReset({
    required String email,
    required String otpCode,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await authRemoteDataSource.forgotPasswordReset(
      ForgotPasswordResetRequestModel(
        email: email,
        otpCode: otpCode,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );

    return result.toEntity();
  }

  @override
  Future<bool> refreshAccessToken() async {
    debugPrint(
      "============ AuthRepositoryImpl.refreshAccessToken ============",
    );

    final currentToken = await TokenStorage.getAccessToken();

    if (currentToken == null || currentToken.isEmpty) {
      debugPrint("✗ no stored access token found");
      debugPrint("=================================================");
      return false;
    }

    debugPrint("→ current token length: ${currentToken.length}");

    final result = await authRemoteDataSource.refreshAccessToken(
      oldAccessToken: currentToken,
    );

    debugPrint("✓ refresh API success: ${result.title}");
    debugPrint("→ new token length: ${result.newToken.length}");
    debugPrint("→ expiresIn: ${result.expiresIn}");

    await TokenStorage.saveAccessToken(
      token: result.newToken,
      expiresInSeconds: result.expiresIn,
    );

    debugPrint("✓ refreshed token saved successfully");
    debugPrint("=================================================");
    return true;
  }
}
