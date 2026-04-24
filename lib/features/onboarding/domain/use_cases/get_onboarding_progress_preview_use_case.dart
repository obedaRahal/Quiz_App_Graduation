import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_progress_preview_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/get_onboarding_progress_preview_params.dart';

class GetOnboardingProgressPreviewUseCase {
  final OnboardingRepository repository;

  GetOnboardingProgressPreviewUseCase(this.repository);

  Future<Either<Failure, OnboardingProgressPreviewResponse>> call(
    GetOnboardingProgressPreviewParams params,
  ) {
    debugPrint(
      "============ GetOnboardingProgressPreviewUseCase.call ============",
    );

    return repository.getOnboardingProgressPreview(
      email: params.email,
    );
  }
}