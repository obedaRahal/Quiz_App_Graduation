import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/stripe_checkout_session_entity.dart';
import '../repositories/details_of_test_repository.dart';
import 'params/create_stripe_checkout_session_params.dart';

class CreateStripeCheckoutSessionUseCase {
  final DetailsOfTestRepository repository;

  const CreateStripeCheckoutSessionUseCase(this.repository);

  Future<Either<Failure, StripeCheckoutSessionEntity>> call(
    CreateStripeCheckoutSessionParams params,
  ) {
    debugPrint("============ CreateStripeCheckoutSessionUseCase.call ============");
    debugPrint("→ params: {testId: ${params.testId}}");

    return repository.createStripeCheckoutSession(
      testId: params.testId,
    );
  }
}