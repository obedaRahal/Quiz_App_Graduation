import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/login_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
final ResendOtpUseCase resendOtpUseCase;
 LoginCubit({
  required this.loginUseCase,
  required this.resendOtpUseCase,
}) : super(const LoginState());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    debugPrint(
      "LoginCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
    );
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  Future<void> submitLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint("========== LoginCubit.submitLogin ==========");
    debugPrint("email => $email");
    debugPrint("password length => ${password.length}");

    if (email.isEmpty) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: 'يرجى إدخال البريد الإلكتروني.',
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: 'يرجى إدخال كلمة المرور.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        loginStatus: LoginStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final result = await loginUseCase(email: email, password: password);

      debugPrint("LOGIN SUCCESS => token length: ${result.token.length}");
      debugPrint("LOGIN USER => ${result.user.name}");

      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
          successMessage: result.title,
          errorMessage: null,
        ),
      );
    }
    // catch (e, s) {
    //   debugPrint("LOGIN ERROR => $e");
    //   debugPrint("LOGIN STACK => $s");
    //   emit(
    //     state.copyWith(
    //       loginStatus: LoginStatus.failure,
    //       errorMessage: e.toString(),
    //     ),
    //   );
    // }
    catch (e, s) {
      debugPrint("LOGIN ERROR => $e");
      debugPrint("LOGIN STACK => $s");

      String message = e.toString();
      LoginFailureType failureType = LoginFailureType.general;

      String? reason;
      String? startsAt;
      String? endsAt;
      int? lastCompletedStep;
      String title = 'خطأ';
      if (e is ForbiddenException) {
        final error = e.errorModel;
        title = error.errorTitle;
        message = error.errorMessage;
        reason = error.reason;
        startsAt = error.startsAt;
        endsAt = error.endsAt;
        lastCompletedStep = error.lastCompletedStep;

        if (lastCompletedStep != null) {
          failureType = LoginFailureType.onboardingNotCompleted;
        } else if (reason != null && reason.isNotEmpty) {
          if (error.isPermanent) {
            failureType = LoginFailureType.permanentBan;
            message = 'تم حظر حسابك بتاريخ ${startsAt ?? ''} بشكل دائم';
          } else {
            failureType = LoginFailureType.temporaryBan;
            message =
                'تم حظر حسابك من تاريخ ${startsAt ?? ''} إلى تاريخ ${endsAt ?? ''}';
          }
        } else if (error.errorTitle.contains('البريد') ||
            error.errorMessage.contains('تأكيد بريدك')) {
          failureType = LoginFailureType.emailNotVerified;
          message = error.errorMessage;
        }
      }

      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorTitle: title,
          errorMessage: message,
          failureType: failureType,
          reason: reason,
          startsAt: startsAt,
          endsAt: endsAt,
          lastCompletedStep: lastCompletedStep,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
  Future<void> resendVerifyEmailOtp() async {
  final email = emailController.text.trim();

  if (email.isEmpty) {
    debugPrint('resendVerifyEmailOtp aborted => email is empty');
    return;
  }

  try {
    debugPrint('LOGIN resend verify email OTP => $email');

    await resendOtpUseCase(email: email);

    debugPrint('LOGIN resend verify email OTP success');
  } catch (e, s) {
    debugPrint('LOGIN resend verify email OTP error => $e');
    debugPrint('LOGIN resend verify email OTP stack => $s');
  }
}
}
