import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_user_interests_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/submit_user_interests_params.dart';

class SubmitUserInterestsUseCase {
  final OnboardingRepository repository;

  SubmitUserInterestsUseCase(this.repository);

  Future<Either<Failure, OnboardingUserInterestsResponse>> call(
    SubmitUserInterestsParams params,
  ) {
    debugPrint("============ SubmitUserInterestsUseCase.call ============");
    return repository.submitUserInterests(
      email: params.email,
      interestIds: params.interestIds,
    );
  }
}