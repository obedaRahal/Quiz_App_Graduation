import '../../domain/entities/payment_attempt_status_entity.dart';

class PaymentAttemptStatusModel {
  final bool success;
  final PaymentAttemptStatusDataModel data;

  const PaymentAttemptStatusModel({required this.success, required this.data});

  factory PaymentAttemptStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentAttemptStatusModel(
      success: json['success'] == true,
      data: PaymentAttemptStatusDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  PaymentAttemptStatusEntity toEntity() => data.toEntity();
}

class PaymentAttemptStatusDataModel {
  final int paymentAttemptId;
  final int testId;
  final String status;
  final bool isFinal;
  final bool testAccessGranted;

  const PaymentAttemptStatusDataModel({
    required this.paymentAttemptId,
    required this.testId,
    required this.status,
    required this.isFinal,
    required this.testAccessGranted,
  });

  factory PaymentAttemptStatusDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentAttemptStatusDataModel(
      paymentAttemptId: int.tryParse(json['payment_attempt_id'].toString()) ?? 0,
      testId: int.tryParse(json['test_id'].toString()) ?? 0,
      status: json['status']?.toString().trim().toLowerCase() ?? '',
      isFinal: json['is_final'] == true,
      testAccessGranted: json['test_access_granted'] == true,
    );
  }

  PaymentAttemptStatusEntity toEntity() {
    return PaymentAttemptStatusEntity(
      paymentAttemptId: paymentAttemptId,
      testId: testId,
      status: status,
      isFinal: isFinal,
      testAccessGranted: testAccessGranted,
    );
  }
}
