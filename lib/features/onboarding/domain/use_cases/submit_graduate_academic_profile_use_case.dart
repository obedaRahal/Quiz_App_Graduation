import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_graduate_academic_profile_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/submit_graduate_academic_profile_params.dart';

class SubmitGraduateAcademicProfileUseCase {
  final OnboardingRepository repository;

  SubmitGraduateAcademicProfileUseCase(this.repository);

  Future<Either<Failure, OnboardingGraduateAcademicProfileResponse>> call(
    SubmitGraduateAcademicProfileParams params,
  ) {
    debugPrint(
      "============ SubmitGraduateAcademicProfileUseCase.call ============",
    );

    return repository.submitGraduateAcademicProfile(
      email: params.email,
      universityName: params.universityName,
      department: params.department,
      certificateImagePath: params.certificateImagePath,
      identityImagePath: params.identityImagePath,
    );
  }
}