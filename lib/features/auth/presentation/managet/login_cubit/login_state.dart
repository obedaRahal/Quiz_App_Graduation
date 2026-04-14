class LoginState { 

  final bool isPasswordObscure;
  
  const LoginState({this.isPasswordObscure = true});

  LoginState copyWith({bool? isPasswordObscure}) {
    return LoginState(
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }
  
}
