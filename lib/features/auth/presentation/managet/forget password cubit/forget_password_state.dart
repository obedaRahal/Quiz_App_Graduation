// class ForgetPasswordState {
//   final int remainingSeconds;
//    final bool isPasswordObscure;
//   const ForgetPasswordState({
//     this.remainingSeconds = 300,
//     this.isPasswordObscure = true,
//     });
//     bool get isTimerFinished => remainingSeconds <= 0;

//   ForgetPasswordState copyWith({int? remainingSeconds,bool? isPasswordObscure}) {
//     return ForgetPasswordState(
//       remainingSeconds: remainingSeconds ?? this.remainingSeconds,
//       isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
//     );
//   }
// }
enum ForgotPasswordRequestOtpStatus { initial, loading, success, failure }

enum ForgotPasswordVerifyOtpStatus { initial, loading, success, failure }

enum ForgotPasswordResendOtpStatus { initial, loading, success, failure }

enum ForgotPasswordResetStatus { initial, loading, success, failure }

class ForgetPasswordState {
  final int remainingSeconds;
  final bool isPasswordObscure;

  final ForgotPasswordRequestOtpStatus requestOtpStatus;
  final String? errorMessage;
  final String? successMessage;

  final String otpCode;
  final ForgotPasswordVerifyOtpStatus verifyOtpStatus;

  final ForgotPasswordResendOtpStatus resendOtpStatus;
  final String? resendSuccessMessage;

  final ForgotPasswordResetStatus resetStatus;
  final String? resetSuccessMessage;

  const ForgetPasswordState({
    this.remainingSeconds = 300,
    this.isPasswordObscure = true,
    this.requestOtpStatus = ForgotPasswordRequestOtpStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.otpCode = '',
    this.verifyOtpStatus = ForgotPasswordVerifyOtpStatus.initial,
    this.resendOtpStatus = ForgotPasswordResendOtpStatus.initial,
    this.resendSuccessMessage,
    this.resetStatus = ForgotPasswordResetStatus.initial,
    this.resetSuccessMessage,
  });

  bool get isTimerFinished => remainingSeconds <= 0;

  ForgetPasswordState copyWith({
    int? remainingSeconds,
    bool? isPasswordObscure,
    ForgotPasswordRequestOtpStatus? requestOtpStatus,
    String? errorMessage,
    String? successMessage,
    String? otpCode,
    ForgotPasswordVerifyOtpStatus? verifyOtpStatus,
    ForgotPasswordResendOtpStatus? resendOtpStatus,
    String? resendSuccessMessage,
    ForgotPasswordResetStatus? resetStatus,
    String? resetSuccessMessage,
  }) {
    return ForgetPasswordState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      requestOtpStatus: requestOtpStatus ?? this.requestOtpStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
      otpCode: otpCode ?? this.otpCode,
      verifyOtpStatus: verifyOtpStatus ?? this.verifyOtpStatus,
      resendOtpStatus: resendOtpStatus ?? this.resendOtpStatus,
      resendSuccessMessage: resendSuccessMessage,
      resetStatus: resetStatus ?? this.resetStatus,
      resetSuccessMessage: resetSuccessMessage,
    );
  }
}
