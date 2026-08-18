import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/payment_attempt_status_entity.dart';
import '../repositories/details_of_test_repository.dart';

class GetPaymentAttemptStatusUseCase {
  final DetailsOfTestRepository repository;

  const GetPaymentAttemptStatusUseCase(this.repository);

  Future<Either<Failure, PaymentAttemptStatusEntity>> call(int paymentAttemptId) {
    return repository.getPaymentAttemptStatus(paymentAttemptId: paymentAttemptId);
  }
}
