import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_request_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_request_otp_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_resend_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_resend_otp_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_reset_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_reset_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_verify_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/forgot_password_models/forgot_password_verify_otp_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/login_models/login_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/login_models/login_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/refresh_token_model/refresh_token_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/register_models/register_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/register_models/register_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/resend_otp_models/resend_otp_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/resend_otp_models/resend_otp_response_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/verify_email_models/verify_email_request_model.dart';
import 'package:quiz_app_grad/features/auth/data/models/verify_email_models/verify_email_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<VerifyEmailResponseModel> verifyEmail(VerifyEmailRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<ResendOtpResponseModel> resendOtp(ResendOtpRequestModel request);
  Future<ForgotPasswordRequestOtpResponseModel> forgotPasswordRequestOtp(
    ForgotPasswordRequestOtpRequestModel request,
  );
  Future<ForgotPasswordVerifyOtpResponseModel> forgotPasswordVerifyOtp(
    ForgotPasswordVerifyOtpRequestModel request,
  );
  Future<ForgotPasswordResendOtpResponseModel> forgotPasswordResendOtp(
    ForgotPasswordResendOtpRequestModel request,
  );
  Future<ForgotPasswordResetResponseModel> forgotPasswordReset(
    ForgotPasswordResetRequestModel request,
  );

  Future<RefreshTokenResponseModel> refreshAccessToken({
    required String oldAccessToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;
  final Dio refreshDio;

  AuthRemoteDataSourceImpl({
    required this.apiConsumer,
    required this.refreshDio,
  });

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await apiConsumer.post(
      EndPoints.register,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    return RegisterResponseModel.fromJson(response);
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(
    VerifyEmailRequestModel request,
  ) async {
    debugPrint(
      'VERIFY FULL URL => ${EndPoints.baseUrl}${EndPoints.verifyEmail}',
    );
    debugPrint('VERIFY DATA => ${request.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.verifyEmail,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    debugPrint('VERIFY RESPONSE => $response');

    return VerifyEmailResponseModel.fromJson(response);
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    return LoginResponseModel.fromJson(response);
  }

  @override
  Future<ResendOtpResponseModel> resendOtp(
    ResendOtpRequestModel request,
  ) async {
    debugPrint('================ RESEND OTP REQUEST ================');
    debugPrint('RESEND FULL URL => ${EndPoints.baseUrl}${EndPoints.resendOtp}');
    debugPrint('RESEND DATA => ${request.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.resendOtp,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    debugPrint('RESEND RESPONSE => $response');
    debugPrint('================ END RESEND OTP REQUEST ================');

    return ResendOtpResponseModel.fromJson(response);
  }

  @override
  Future<ForgotPasswordRequestOtpResponseModel> forgotPasswordRequestOtp(
    ForgotPasswordRequestOtpRequestModel request,
  ) async {
    debugPrint(
      'FORGOT PASSWORD REQUEST OTP URL => ${EndPoints.baseUrl}${EndPoints.forgotPasswordRequestOtp}',
    );
    debugPrint('FORGOT PASSWORD REQUEST OTP DATA => ${request.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.forgotPasswordRequestOtp,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    return ForgotPasswordRequestOtpResponseModel.fromJson(response);
  }

  @override
  Future<ForgotPasswordVerifyOtpResponseModel> forgotPasswordVerifyOtp(
    ForgotPasswordVerifyOtpRequestModel request,
  ) async {
    debugPrint(
      'FORGOT PASSWORD VERIFY OTP URL => ${EndPoints.baseUrl}${EndPoints.forgotPasswordVerifyOtp}',
    );
    debugPrint('FORGOT PASSWORD VERIFY OTP DATA => ${request.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.forgotPasswordVerifyOtp,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    return ForgotPasswordVerifyOtpResponseModel.fromJson(response);
  }

  @override
  Future<ForgotPasswordResendOtpResponseModel> forgotPasswordResendOtp(
    ForgotPasswordResendOtpRequestModel request,
  ) async {
    debugPrint(
      'FORGOT PASSWORD RESEND OTP URL => ${EndPoints.baseUrl}${EndPoints.forgotPasswordResendOtp}',
    );
    debugPrint('FORGOT PASSWORD RESEND OTP DATA => ${request.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.forgotPasswordResendOtp,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    return ForgotPasswordResendOtpResponseModel.fromJson(response);
  }

  @override
  Future<ForgotPasswordResetResponseModel> forgotPasswordReset(
    ForgotPasswordResetRequestModel request,
  ) async {
    debugPrint(
      'FORGOT PASSWORD RESET URL => ${EndPoints.baseUrl}${EndPoints.forgotPasswordReset}',
    );
    debugPrint('FORGOT PASSWORD RESET DATA => ${request.toJson()}');

    final response = await apiConsumer.post(
      EndPoints.forgotPasswordReset,
      data: request.toJson(),
      isFormData: true,
      options: Options(extra: {'requiresAuth': false}),
    );

    return ForgotPasswordResetResponseModel.fromJson(response);
  }

  @override
  Future<RefreshTokenResponseModel> refreshAccessToken({
    required String oldAccessToken,
  }) async {
    debugPrint(
      "============ AuthRemoteDataSourceImpl.refreshAccessToken ============",
    );
    debugPrint("→ endpoint: ${EndPoints.refreshToken}");
    debugPrint("→ using old access token as Bearer token");

    try {
      final response = await refreshDio.post(
        EndPoints.refreshToken,
        options: Options(
          headers: {
            'Authorization': 'Bearer $oldAccessToken',
            'Accept': 'application/json',
          },
        ),
      );

      debugPrint("← response (refreshAccessToken): ${response.data}");
      debugPrint("=================================================");

      return RefreshTokenResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
