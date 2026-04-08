class IntroState {
  final int currentPage;
  final bool isSaving;
  final bool isFinished;
  final String? errorMessage;

  const IntroState({
    this.currentPage = 0,
    this.isSaving = false,
    this.isFinished = false,
    this.errorMessage,
  });

  IntroState copyWith({
    int? currentPage,
    bool? isSaving,
    bool? isFinished,
    String? errorMessage,
  }) {
    return IntroState(
      currentPage: currentPage ?? this.currentPage,
      isSaving: isSaving ?? this.isSaving,
      isFinished: isFinished ?? this.isFinished,
      errorMessage: errorMessage,
    );
  }
}