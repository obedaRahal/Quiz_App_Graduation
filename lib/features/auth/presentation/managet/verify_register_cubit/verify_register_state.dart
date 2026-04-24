// class VerifyRegisterState {
//   final int remainingSeconds;
//   final String otpCode;
//   final VerifyRegisterStatus verifyStatus;
//   final String? errorMessage;
//   final String? successMessage;

//   const VerifyRegisterState({
//     this.remainingSeconds = 300,
//     this.otpCode = '',
//     this.verifyStatus = VerifyRegisterStatus.initial,
//     this.errorMessage,
//     this.successMessage,
//   });

//   bool get isTimerFinished => remainingSeconds <= 0;

//   VerifyRegisterState copyWith({
//     int? remainingSeconds,
//     String? otpCode,
//     VerifyRegisterStatus? verifyStatus,
//     String? errorMessage,
//     String? successMessage,
//   }) {
//     return VerifyRegisterState(
//       remainingSeconds: remainingSeconds ?? this.remainingSeconds,
//       otpCode: otpCode ?? this.otpCode,
//       verifyStatus: verifyStatus ?? this.verifyStatus,
//       errorMessage: errorMessage,
//       successMessage: successMessage,
//     );
//   }
// }

// enum VerifyRegisterStatus {
//   initial,
//   loading,
//   success,
//   failure,
// }
class VerifyRegisterState {
  final int remainingSeconds;
  final String otpCode;
  final VerifyRegisterStatus verifyStatus;
  final VerifyResendStatus resendStatus;
  final String? errorMessage;
  final String? successMessage;
  final String? resendSuccessMessage;

  const VerifyRegisterState({
    this.remainingSeconds = 300,
    this.otpCode = '',
    this.verifyStatus = VerifyRegisterStatus.initial,
    this.resendStatus = VerifyResendStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.resendSuccessMessage,
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
  }) {
    return VerifyRegisterState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      otpCode: otpCode ?? this.otpCode,
      verifyStatus: verifyStatus ?? this.verifyStatus,
      resendStatus: resendStatus ?? this.resendStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
      resendSuccessMessage: resendSuccessMessage,
    );
  }
}

enum VerifyRegisterStatus {
  initial,
  loading,
  success,
  failure,
}

enum VerifyResendStatus {
  initial,
  loading,
  success,
  failure,
}