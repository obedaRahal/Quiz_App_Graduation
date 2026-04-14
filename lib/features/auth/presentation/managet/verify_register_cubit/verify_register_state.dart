class VerifyRegisterState {
  
  final int remainingSeconds;

  const VerifyRegisterState({
    this.remainingSeconds = 300,
    });

  bool get isTimerFinished => remainingSeconds <= 0;

  VerifyRegisterState copyWith({int? remainingSeconds}) {
    return VerifyRegisterState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}
