class VerifyRegisterState {
  final int remainingSeconds;
  final String otpCode;
  final VerifyRegisterStatus verifyStatus;
  final VerifyResendStatus resendStatus;
  final String? errorMessage;
  final String? successMessage;
  final String? resendSuccessMessage;
  final String? snackBarTitle;

final bool showOtpError;

  const VerifyRegisterState({
    this.remainingSeconds = 300,
    this.otpCode = '',
    this.verifyStatus = VerifyRegisterStatus.initial,
    this.resendStatus = VerifyResendStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.resendSuccessMessage,
    this.snackBarTitle,
    this.showOtpError = false,
  });

  bool get isTimerFinished => remainingSeconds <= 0;

  VerifyRegisterState copyWith({
    int? remainingSeconds,
    String? otpCode,
    VerifyRegisterStatus? verifyStatus,
    VerifyResendStatus? resendStatus,
    String? errorMessage,
    String? successMessage,
    String? resendSuccessMessage,
    String? snackBarTitle,
    bool? showOtpError,
  }) {
    return VerifyRegisterState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      otpCode: otpCode ?? this.otpCode,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      resendStatus: resendStatus ?? this.resendStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
      resendSuccessMessage: resendSuccessMessage,
      snackBarTitle: snackBarTitle,
      showOtpError: showOtpError ?? this.showOtpError,
    );
  }
}

enum VerifyRegisterStatus { initial, loading, success, failure }

enum VerifyResendStatus { initial, loading, success, failure }
