import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_discovery_source_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_education_level_response.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, OnboardingDiscoverySourceResponse>>
  submitDiscoverySource({
    required String email,
    required String discoverySource,
  });

  Future<Either<Failure, OnboardingEducationLevelResponse>>
  submitEducationLevel({
    required String email,
    required String governorate,
    required String educationLevel,
  });
}
