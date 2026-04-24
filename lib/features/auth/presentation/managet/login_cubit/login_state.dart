// class LoginState { 

//   final bool isPasswordObscure;
  
//   const LoginState({this.isPasswordObscure = true});

//   LoginState copyWith({bool? isPasswordObscure}) {
//     return LoginState(
//       isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
//     );
//   }
  
// }
// enum LoginStatus {
//   initial,
//   loading,
//   success,
//   failure,
// }

// class LoginState {
//   final bool isPasswordObscure;
//   final LoginStatus loginStatus;
//   final String? errorMessage;
//   final String? successMessage;

//   const LoginState({
//     this.isPasswordObscure = true,
//     this.loginStatus = LoginStatus.initial,
//     this.errorMessage,
//     this.successMessage,
//   });

//   LoginState copyWith({
//     bool? isPasswordObscure,
//     LoginStatus? loginStatus,
//     String? errorMessage,
//     String? successMessage,
//   }) {
//     return LoginState(
//       isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
//       loginStatus: loginStatus ?? this.loginStatus,
//       errorMessage: errorMessage,
//       successMessage: successMessage,
//     );
//   }
// }
enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

enum LoginFailureType {
  none,
  permanentBan,
  temporaryBan,
  emailNotVerified,
  onboardingNotCompleted,
  general,
}

class LoginState {
  final bool isPasswordObscure;
  final LoginStatus loginStatus;
  final String? errorMessage;
  final String? successMessage;

  final LoginFailureType failureType;
  final String? reason;
  final String? startsAt;
  final String? endsAt;
  final int? lastCompletedStep;
final String? errorTitle;

  const LoginState({
    this.isPasswordObscure = true,
    this.loginStatus = LoginStatus.initial,
    this.errorMessage,
    this.errorTitle,
    this.successMessage,
    this.failureType = LoginFailureType.none,
    this.reason,
    this.startsAt,
    this.endsAt,
    this.lastCompletedStep,
  });

  LoginState copyWith({
    bool? isPasswordObscure,
    LoginStatus? loginStatus,
    String? errorMessage,
    String? successMessage,
    LoginFailureType? failureType,
    String? reason,
    String? startsAt,
    String? endsAt,
    int? lastCompletedStep,
    String? errorTitle,
  }) {
    return LoginState(
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      loginStatus: loginStatus ?? this.loginStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
      failureType: failureType ?? this.failureType,
      reason: reason,
      startsAt: startsAt,
      endsAt: endsAt,
      lastCompletedStep: lastCompletedStep,
      errorTitle: errorTitle,
    );
  }
}