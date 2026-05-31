import '../../domain/entities/stripe_checkout_session_entity.dart';

class StripeCheckoutSessionModel {
  final bool success;
  final String title;
  final StripeCheckoutSessionDataModel data;
  final int statusCode;

  const StripeCheckoutSessionModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory StripeCheckoutSessionModel.fromJson(Map<String, dynamic> json) {
    return StripeCheckoutSessionModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      data: StripeCheckoutSessionDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
      statusCode: json['status_code'] as int? ?? 0,
    );
  }

  StripeCheckoutSessionEntity toEntity() {
    return StripeCheckoutSessionEntity(
      success: success,
      title: title,
      purchaseId: data.purchaseId,
      paymentAttemptId: data.paymentAttemptId,
      provider: data.provider,
      checkoutSessionId: data.checkoutSessionId,
      checkoutUrl: data.checkoutUrl,
      expiresAt: data.expiresAt,
      reusedExistingSession: data.reusedExistingSession,
      amount: data.amount.toEntity(),
      statusCode: statusCode,
    );
  }
}

class StripeCheckoutSessionDataModel {
  final int purchaseId;
  final int paymentAttemptId;
  final String provider;
  final String checkoutSessionId;
  final String checkoutUrl;
  final int? expiresAt;
  final bool reusedExistingSession;
  final StripeCheckoutAmountModel amount;

  const StripeCheckoutSessionDataModel({
    required this.purchaseId,
    required this.paymentAttemptId,
    required this.provider,
    required this.checkoutSessionId,
    required this.checkoutUrl,
    required this.expiresAt,
    required this.reusedExistingSession,
    required this.amount,
  });

  factory StripeCheckoutSessionDataModel.fromJson(Map<String, dynamic> json) {
    return StripeCheckoutSessionDataModel(
      purchaseId: json['purchase_id'] as int? ?? 0,
      paymentAttemptId: json['payment_attempt_id'] as int? ?? 0,
      provider: json['provider']?.toString() ?? '',
      checkoutSessionId: json['checkout_session_id']?.toString() ?? '',
      checkoutUrl: json['checkout_url']?.toString() ?? '',
      expiresAt: json['expires_at'] as int?,
      reusedExistingSession: json['reused_existing_session'] as bool? ?? false,
      amount: StripeCheckoutAmountModel.fromJson(
        json['amount'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class StripeCheckoutAmountModel {
  final double grossAmount;
  final double platformFeeAmount;
  final double sellerNetAmount;
  final String currency;

  const StripeCheckoutAmountModel({
    required this.grossAmount,
    required this.platformFeeAmount,
    required this.sellerNetAmount,
    required this.currency,
  });

  factory StripeCheckoutAmountModel.fromJson(Map<String, dynamic> json) {
    return StripeCheckoutAmountModel(
      grossAmount:
          double.tryParse(json['gross_amount']?.toString() ?? '0') ?? 0,
      platformFeeAmount:
          double.tryParse(json['platform_fee_amount']?.toString() ?? '0') ?? 0,
      sellerNetAmount:
          double.tryParse(json['seller_net_amount']?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? '',
    );
  }

  StripeCheckoutAmountEntity toEntity() {
    return StripeCheckoutAmountEntity(
      grossAmount: grossAmount,
      platformFeeAmount: platformFeeAmount,
      sellerNetAmount: sellerNetAmount,
      currency: currency,
    );
  }
}