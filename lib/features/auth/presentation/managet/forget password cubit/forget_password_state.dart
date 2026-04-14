class ForgetPasswordState {
  final int remainingSeconds;
   final bool isPasswordObscure;
  const ForgetPasswordState({
    this.remainingSeconds = 300,
    this.isPasswordObscure = true,
    });
    bool get isTimerFinished => remainingSeconds <= 0;

  ForgetPasswordState copyWith({int? remainingSeconds,bool? isPasswordObscure}) {
    return ForgetPasswordState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
    );
  }
}