enum TestAttemptInteractionMode { mcq, challenge, flashCard }

extension TestAttemptInteractionModeX on TestAttemptInteractionMode {
  String get apiValue {
    switch (this) {
      case TestAttemptInteractionMode.mcq:
        return 'mcq';
      case TestAttemptInteractionMode.challenge:
        return 'challenge';
      case TestAttemptInteractionMode.flashCard:
        return 'flashCard';
    }
  }
}

class RegisterTestAttemptInteractionParams {
  final int testId;
  final TestAttemptInteractionMode mode;

  const RegisterTestAttemptInteractionParams({
    required this.testId,
    required this.mode,
  });

  Map<String, dynamic> toBody() {
    return {'mode': mode.apiValue};
  }
}
