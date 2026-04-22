import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_current_university_profile_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/submit_current_university_profile_params.dart';

class SubmitCurrentUniversityProfileUseCase {
  final OnboardingRepository repository;

  SubmitCurrentUniversityProfileUseCase(this.repository);

  Future<Either<Failure, OnboardingCurrentUniversityProfileResponse>> call(
    SubmitCurrentUniversityProfileParams params,
  ) {
    debugPrint(
      "============ SubmitCurrentUniversityProfileUseCase.call ============",
    );

    return repository.submitCurrentUniversityProfile(
      email: params.email,
      universityName: params.universityName,
      department: params.department,
      universityYear: params.universityYear,
    );
  }
}