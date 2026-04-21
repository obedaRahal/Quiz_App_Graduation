import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../entities/onboarding_discovery_source_response.dart';
import '../repositories/onboarding_repository.dart';
import 'params/submit_discovery_source_params.dart';

class SubmitDiscoverySourceUseCase {
  final OnboardingRepository repository;

  SubmitDiscoverySourceUseCase(this.repository);

  Future<Either<Failure, OnboardingDiscoverySourceResponse>> call(
    SubmitDiscoverySourceParams params,
  ) {
    debugPrint("============ SubmitDiscoverySourceUseCase.call ============");
    return repository.submitDiscoverySource(
      email: params.email,
      discoverySource: params.discoverySource,
    );
  }
}
