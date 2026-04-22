import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_education_level_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/submit_education_level_params.dart';

class SubmitEducationLevelUseCase {
  final OnboardingRepository repository;

  SubmitEducationLevelUseCase(this.repository);

  Future<Either<Failure, OnboardingEducationLevelResponse>> call(
    SubmitEducationLevelParams params,
  ) {
    debugPrint(
      "============ SubmitEducationLevelUseCase.call ============",
    );

    return repository.submitEducationLevel(
      email: params.email,
      governorate: params.governorate,
      educationLevel: params.educationLevel,
    );
  }
}