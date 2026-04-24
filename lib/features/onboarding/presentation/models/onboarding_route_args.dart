class OnboardingRouteArgs {
  final String email;
  final int? lastCompletedStep;

  const OnboardingRouteArgs({
    required this.email,
    this.lastCompletedStep,
  });
}