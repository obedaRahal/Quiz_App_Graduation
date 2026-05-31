class StripeCheckoutSessionEntity {
  final bool success;
  final String title;
  final int purchaseId;
  final int paymentAttemptId;
  final String provider;
  final String checkoutSessionId;
  final String checkoutUrl;
  final int? expiresAt;
  final bool reusedExistingSession;
  final StripeCheckoutAmountEntity amount;
  final int statusCode;

  const StripeCheckoutSessionEntity({
    required this.success,
    required this.title,
    required this.purchaseId,
    required this.paymentAttemptId,
    required this.provider,
    required this.checkoutSessionId,
    required this.checkoutUrl,
    required this.expiresAt,
    required this.reusedExistingSession,
    required this.amount,
    required this.statusCode,
  });
}

class StripeCheckoutAmountEntity {
  final double grossAmount;
  final double platformFeeAmount;
  final double sellerNetAmount;
  final String currency;

  const StripeCheckoutAmountEntity({
    required this.grossAmount,
    required this.platformFeeAmount,
    required this.sellerNetAmount,
    required this.currency,
  });
}