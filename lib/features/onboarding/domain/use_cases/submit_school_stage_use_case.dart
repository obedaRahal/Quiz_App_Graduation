import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_school_stage_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/submit_school_stage_params.dart';

class SubmitSchoolStageUseCase {
  final OnboardingRepository repository;

  SubmitSchoolStageUseCase(this.repository);

  Future<Either<Failure, OnboardingSchoolStageResponse>> call(
    SubmitSchoolStageParams params,
  ) {
    debugPrint("============ SubmitSchoolStageUseCase.call ============");
    return repository.submitSchoolStage(
      email: params.email,
      schoolStage: params.schoolStage,
    );
  }
}