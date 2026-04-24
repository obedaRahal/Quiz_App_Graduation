// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/features/auth/domain/use_cases/verify_email_use_case.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_state.dart';

// class VerifyRegisterCubit extends Cubit<VerifyRegisterState> {
//   Timer? _timer;
//   final VerifyEmailUseCase verifyEmailUseCase;

//   String email = '';

//   VerifyRegisterCubit({
//     required this.verifyEmailUseCase,
//   }) : super(const VerifyRegisterState()) {
//     debugPrint("============ VerifyRegisterCubit INIT ============");
//     debugPrint("VerifyRegisterCubit created for email: $email");
//     _startTimer();
//   }

//   void setEmail(String value) {
//     email = value;
//     debugPrint("VerifyRegisterCubit.setEmail -> $email");
//   }

//   void otpChanged(String value) {
//     debugPrint("VerifyRegisterCubit.otpChanged -> $value");

//     emit(
//       state.copyWith(
//         otpCode: value,
//         errorMessage: null,
//       ),
//     );
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
//       } else {
//         if (isClosed) return;
//         emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
//       }
//     });
//   }

//   void restartTimer() {
//     debugPrint("VerifyRegisterCubit.restartTimer()");
//     _startTimer();
//   }

//   Future<void> submitVerifyEmail() async {
//     final otpCode = state.otpCode.trim();

//     debugPrint("========== VerifyRegisterCubit.submitVerifyEmail ==========");
//     debugPrint("email => $email");
//     debugPrint("otpCode => $otpCode");

//     if (email.isEmpty) {
//       debugPrint("Verify validation failed => email is empty");
//       emit(
//         state.copyWith(
//           verifyStatus: VerifyRegisterStatus.failure,
//           errorMessage: 'البريد الإلكتروني غير متوفر.',
//         ),
//       );
//       return;
//     }

//     if (otpCode.isEmpty) {
//       debugPrint("Verify validation failed => otpCode is empty");
//       emit(
//         state.copyWith(
//           verifyStatus: VerifyRegisterStatus.failure,
//           errorMessage: 'يرجى إدخال رمز التحقق.',
//         ),
//       );
//       return;
//     }

//     if (otpCode.length != 6) {
//       debugPrint("Verify validation failed => otpCode length is not 6");
//       emit(
//         state.copyWith(
//           verifyStatus: VerifyRegisterStatus.failure,
//           errorMessage: 'يجب أن يتكون رمز التحقق من 6 أرقام.',
//         ),
//       );
//       return;
//     }

//     emit(
//       state.copyWith(
//         verifyStatus: VerifyRegisterStatus.loading,
//         errorMessage: null,
//         successMessage: null,
//       ),
//     );

//     try {
//       debugPrint("Verify email request started...");

//       final result = await verifyEmailUseCase(
//         email: email,
//         otpCode: otpCode,
//       );

//       debugPrint("Verify email request success");
//       debugPrint("message => ${result.message}");

//       emit(
//         state.copyWith(
//           verifyStatus: VerifyRegisterStatus.success,
//           successMessage: result.message,
//           errorMessage: null,
//         ),
//       );
//     }  catch (e, s) {
//       debugPrint("VERIFY EMAIL ERROR => $e");
//       debugPrint("VERIFY EMAIL STACK => $s");

//       emit(
//         state.copyWith(
//           verifyStatus: VerifyRegisterStatus.failure,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }

//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/resend_otp_use_case.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/verify_email_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_state.dart';

class VerifyRegisterCubit extends Cubit<VerifyRegisterState> {
  Timer? _timer;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  String email = '';

  VerifyRegisterCubit({
    required this.verifyEmailUseCase,
    required this.resendOtpUseCase,
  }) : super(const VerifyRegisterState()) {
    debugPrint("============ VerifyRegisterCubit INIT ============");
    debugPrint("VerifyRegisterCubit created for email: $email");
    _startTimer();
  }

  void setEmail(String value) {
    email = value;
    debugPrint("VerifyRegisterCubit.setEmail -> $email");
  }

  void otpChanged(String value) {
    debugPrint("VerifyRegisterCubit.otpChanged -> $value");
    emit(
      state.copyWith(
        otpCode: value,
        errorMessage: null,
      ),
    );
  }

  void _startTimer() {
    debugPrint("VerifyRegisterCubit._startTimer() -> reset to 300s");
    _timer?.cancel();

    if (isClosed) return;

    emit(state.copyWith(remainingSeconds: 300));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        debugPrint("VerifyRegisterCubit timer finished (0s left)");
        timer.cancel();

        if (isClosed) return;
        emit(state.copyWith(remainingSeconds: 0));
      } else {
        if (isClosed) return;
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      }
    });
  }

  void restartTimer() {
    debugPrint("VerifyRegisterCubit.restartTimer()");
    _startTimer();
  }

  Future<void> submitVerifyEmail() async {
    final otpCode = state.otpCode.trim();

    debugPrint("========== VerifyRegisterCubit.submitVerifyEmail ==========");
    debugPrint("email => $email");
    debugPrint("otpCode => $otpCode");

    if (email.isEmpty) {
      emit(
        state.copyWith(
          verifyStatus: VerifyRegisterStatus.failure,
          errorMessage: 'البريد الإلكتروني غير متوفر.',
        ),
      );
      return;
    }

    if (otpCode.isEmpty) {
      emit(
        state.copyWith(
          verifyStatus: VerifyRegisterStatus.failure,
          errorMessage: 'يرجى إدخال رمز التحقق.',
        ),
      );
      return;
    }

    if (otpCode.length != 6) {
      emit(
        state.copyWith(
          verifyStatus: VerifyRegisterStatus.failure,
          errorMessage: 'يجب أن يتكون رمز التحقق من 6 أرقام.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        verifyStatus: VerifyRegisterStatus.loading,
        errorMessage: null,
        successMessage: null,
      ),
    );

    try {
      final result = await verifyEmailUseCase(
        email: email,
        otpCode: otpCode,
      );

      emit(
        state.copyWith(
          verifyStatus: VerifyRegisterStatus.success,
          successMessage: result.message,
          errorMessage: null,
        ),
      );
    } catch (e, s) {
      debugPrint("VERIFY EMAIL ERROR => $e");
      debugPrint("VERIFY EMAIL STACK => $s");

      emit(
        state.copyWith(
          verifyStatus: VerifyRegisterStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

   Future<void> resendCode() async {
    debugPrint('================ VerifyRegisterCubit.resendCode ================');
    debugPrint('email => $email');

    if (email.isEmpty) {
      debugPrint('resend aborted => email is empty');
      emit(
        state.copyWith(
          resendStatus: VerifyResendStatus.failure,
          errorMessage: 'البريد الإلكتروني غير متوفر.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        resendStatus: VerifyResendStatus.loading,
        errorMessage: null,
        resendSuccessMessage: null,
      ),
    );

    try {
      final result = await resendOtpUseCase(email: email);

      debugPrint('resend success => ${result.message}');

      emit(
        state.copyWith(
          resendStatus: VerifyResendStatus.success,
          resendSuccessMessage: result.message,
          errorMessage: null,
        ),
      );

      restartTimer();
    } catch (e, s) {
      debugPrint('RESEND OTP ERROR => $e');
      debugPrint('RESEND OTP STACK => $s');

      emit(
        state.copyWith(
          resendStatus: VerifyResendStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}