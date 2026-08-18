class DetailsOfTestRouteArgs {
  final int testId;
  final int? paymentAttemptId;
  final bool paymentWasCancelled;

  const DetailsOfTestRouteArgs({
    required this.testId,
    this.paymentAttemptId,
    this.paymentWasCancelled = false,
  });
}
