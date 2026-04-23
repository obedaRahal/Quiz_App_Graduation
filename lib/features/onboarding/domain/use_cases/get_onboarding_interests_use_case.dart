import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_interests_response.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingInterestsUseCase {
  final OnboardingRepository repository;

  GetOnboardingInterestsUseCase(this.repository);

  Future<Either<Failure, OnboardingInterestsResponse>> call() {
    debugPrint("============ GetOnboardingInterestsUseCase.call ============");
    return repository.getOnboardingInterests();
  }
}