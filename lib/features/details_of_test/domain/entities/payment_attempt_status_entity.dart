class PaymentAttemptStatusEntity {
  final int paymentAttemptId;
  final int testId;
  final String status;
  final bool isFinal;
  final bool testAccessGranted;

  const PaymentAttemptStatusEntity({
    required this.paymentAttemptId,
    required this.testId,
    required this.status,
    required this.isFinal,
    required this.testAccessGranted,
  });
}
