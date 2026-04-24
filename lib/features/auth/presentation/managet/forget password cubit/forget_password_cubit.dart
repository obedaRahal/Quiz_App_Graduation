// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';

// class ForgetPasswordCubit extends Cubit<ForgetPasswordState>{
// Timer? _timer;
//  ForgetPasswordCubit() : super(const ForgetPasswordState()) {
//     debugPrint("============ VerifyRegisterCubit INIT ============");
//     debugPrint("VerifyRegisterCubit created for email: ");
//     _startTimer();
//   }
//   void _startTimer() {
//     debugPrint("VerifyRegisterCubit._startTimer() -> reset to 300s");
//     _timer?.cancel();
//     if (isClosed) return;
//     emit(state.copyWith(remainingSeconds: 300));

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (state.remainingSeconds <= 1) {
//         debugPrint("VerifyRegisterCubit timer finished (0s left)");
//         timer.cancel();
//         if (isClosed) return;
//         emit(state.copyWith(remainingSeconds: 0));
//         if (isClosed) return;
//       } else {
//         if (isClosed) return;
//         emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
//         if (isClosed) return;
//       }
//     });
//   }
//   void togglePasswordVisibility() {
//     debugPrint(
//       "LoginCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
//     );
//     emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_request_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_reset_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/forgot_password_verify_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  Timer? _timer;

  final ForgotPasswordRequestOtpUseCase forgotPasswordRequestOtpUseCase;
  final ForgotPasswordVerifyOtpUseCase forgotPasswordVerifyOtpUseCase;
  final ForgotPasswordResendOtpUseCase forgotPasswordResendOtpUseCase;
  final ForgotPasswordResetUseCase forgotPasswordResetUseCase;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  String email = '';
  ForgetPasswordCubit({
    required this.forgotPasswordRequestOtpUseCase,
    required this.forgotPasswordVerifyOtpUseCase,
    required this.forgotPasswordResendOtpUseCase,
    required this.forgotPasswordResetUseCase,
  }) : super(const ForgetPasswordState()) {
    debugPrint("============ ForgetPasswordCubit INIT ============");
    _startTimer();
  }

  final TextEditingController emailController = TextEditingController();

  void _startTimer() {
    debugPrint("ForgetPasswordCubit._startTimer() -> reset to 300s");
    _timer?.cancel();

    if (isClosed) return;

    emit(state.copyWith(remainingSeconds: 300));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        timer.cancel();
        if (isClosed) return;
        emit(state.copyWith(remainingSeconds: 0));
      } else {
        if (isClosed) return;
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      }
    });
  }

  void togglePasswordVisibility() {
    debugPrint(
      "ForgetPasswordCubit.togglePasswordVisibility -> ${!state.isPasswordObscure}",
    );
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  Future<void> requestOtp() async {
    final email = emailController.text.trim();

    debugPrint("========== ForgetPasswordCubit.requestOtp ==========");
    debugPrint("email => $email");

    if (email.isEmpty) {
      emit(
        state.copyWith(
          requestOtpStatus: ForgotPasswordRequestOtpStatus.failure,
          errorMessage: 'يرجى إدخال البريد الإلكتروني.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        requestOtpStatus: ForgotPasswordRequestOtpStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final result = await forgotPasswordRequestOtpUseCase(email: email);

      emit(
        state.copyWith(
          requestOtpStatus: ForgotPasswordRequestOtpStatus.success,
          successMessage: result.message,
          errorMessage: null,
        ),
      );
    } catch (e, s) {
      debugPrint("FORGOT PASSWORD REQUEST OTP ERROR => $e");
      debugPrint("FORGOT PASSWORD REQUEST OTP STACK => $s");

      emit(
        state.copyWith(
          requestOtpStatus: ForgotPasswordRequestOtpStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    return super.close();
  }

  void setEmail(String value) {
    email = value;
    debugPrint("ForgetPasswordCubit.setEmail -> $email");
  }

  void otpChanged(String value) {
    emit(state.copyWith(otpCode: value, errorMessage: null));
  }

  Future<void> verifyOtp() async {
    final otpCode = state.otpCode.trim();

    debugPrint("========== ForgetPasswordCubit.verifyOtp ==========");
    debugPrint("email => $email");
    debugPrint("otpCode => $otpCode");

    if (email.isEmpty) {
      emit(
        state.copyWith(
          verifyOtpStatus: ForgotPasswordVerifyOtpStatus.failure,
          errorMessage: 'البريد الإلكتروني غير متوفر.',
        ),
      );
      return;
    }

    if (otpCode.isEmpty) {
      emit(
        state.copyWith(
          verifyOtpStatus: ForgotPasswordVerifyOtpStatus.failure,
          errorMessage: 'يرجى إدخال رمز التحقق.',
        ),
      );
      return;
    }

    if (otpCode.length != 6) {
      emit(
        state.copyWith(
          verifyOtpStatus: ForgotPasswordVerifyOtpStatus.failure,
          errorMessage: 'يجب أن يتكون رمز التحقق من 6 أرقام.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        verifyOtpStatus: ForgotPasswordVerifyOtpStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final result = await forgotPasswordVerifyOtpUseCase(
        email: email,
        otpCode: otpCode,
      );

      emit(
        state.copyWith(
          verifyOtpStatus: ForgotPasswordVerifyOtpStatus.success,
          successMessage: result.message,
          errorMessage: null,
        ),
      );
    } catch (e, s) {
      debugPrint("FORGOT PASSWORD VERIFY OTP ERROR => $e");
      debugPrint("FORGOT PASSWORD VERIFY OTP STACK => $s");

      emit(
        state.copyWith(
          verifyOtpStatus: ForgotPasswordVerifyOtpStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> resendForgotPasswordOtp() async {
    final currentEmail = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : email;

    debugPrint(
      "========== ForgetPasswordCubit.resendForgotPasswordOtp ==========",
    );
    debugPrint("email => $currentEmail");

    if (currentEmail.isEmpty) {
      emit(
        state.copyWith(
          resendOtpStatus: ForgotPasswordResendOtpStatus.failure,
          errorMessage: 'البريد الإلكتروني غير متوفر.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        resendOtpStatus: ForgotPasswordResendOtpStatus.loading,
        errorMessage: null,
        resendSuccessMessage: null,
      ),
    );

    try {
      final result = await forgotPasswordResendOtpUseCase(email: currentEmail);

      emit(
        state.copyWith(
          resendOtpStatus: ForgotPasswordResendOtpStatus.success,
          resendSuccessMessage: result.message,
          errorMessage: null,
        ),
      );

      _startTimer();
    } catch (e, s) {
      debugPrint("FORGOT PASSWORD RESEND OTP ERROR => $e");
      debugPrint("FORGOT PASSWORD RESEND OTP STACK => $s");

      emit(
        state.copyWith(
          resendOtpStatus: ForgotPasswordResendOtpStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> resetPassword() async {
    final currentEmail = emailController.text.trim().isNotEmpty
        ? emailController.text.trim()
        : email;

    final otpCode = state.otpCode.trim();
    final password = passwordController.text.trim();
    final passwordConfirmation = passwordConfirmationController.text.trim();

    debugPrint("========== ForgetPasswordCubit.resetPassword ==========");
    debugPrint("email => $currentEmail");
    debugPrint("otpCode => $otpCode");
    debugPrint("password length => ${password.length}");
    debugPrint("passwordConfirmation length => ${passwordConfirmation.length}");

    if (currentEmail.isEmpty) {
      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.failure,
          errorMessage: 'البريد الإلكتروني غير متوفر.',
        ),
      );
      return;
    }

    if (otpCode.isEmpty) {
      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.failure,
          errorMessage: 'رمز التحقق غير متوفر.',
        ),
      );
      return;
    }

    if (password.isEmpty) {
      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.failure,
          errorMessage: 'يرجى إدخال كلمة المرور الجديدة.',
        ),
      );
      return;
    }

    if (passwordConfirmation.isEmpty) {
      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.failure,
          errorMessage: 'يرجى تأكيد كلمة المرور الجديدة.',
        ),
      );
      return;
    }

    if (password != passwordConfirmation) {
      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.failure,
          errorMessage: 'كلمة المرور وتأكيدها غير متطابقين.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        resetStatus: ForgotPasswordResetStatus.loading,
        errorMessage: null,
        resetSuccessMessage: null,
      ),
    );

    try {
      final result = await forgotPasswordResetUseCase(
        email: currentEmail,
        otpCode: otpCode,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.success,
          resetSuccessMessage: result.message,
          errorMessage: null,
        ),
      );
    } catch (e, s) {
      debugPrint("FORGOT PASSWORD RESET ERROR => $e");
      debugPrint("FORGOT PASSWORD RESET STACK => $s");

      emit(
        state.copyWith(
          resetStatus: ForgotPasswordResetStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
  void setOtpCode(String value) {
  debugPrint("ForgetPasswordCubit.setOtpCode -> $value");

  emit(
    state.copyWith(
      otpCode: value,
    ),
  );
}
}
