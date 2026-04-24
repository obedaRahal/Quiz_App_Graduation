// class LoginState { 

//   final bool isPasswordObscure;
  
//   const LoginState({this.isPasswordObscure = true});

//   LoginState copyWith({bool? isPasswordObscure}) {
//     return LoginState(
//       isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
//     );
//   }
  
// }
enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

class LoginState {
  final bool isPasswordObscure;
  final LoginStatus loginStatus;
  final String? errorMessage;
  final String? successMessage;

  const LoginState({
    this.isPasswordObscure = true,
    this.loginStatus = LoginStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  LoginState copyWith({
    bool? isPasswordObscure,
    LoginStatus? loginStatus,
    String? errorMessage,
    String? successMessage,
  }) {
    return LoginState(
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      loginStatus: loginStatus ?? this.loginStatus,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
