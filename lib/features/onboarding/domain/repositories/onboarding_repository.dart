import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_current_university_profile_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_discovery_source_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_education_level_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_graduate_academic_profile_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_school_stage_response.dart';

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

  Future<Either<Failure, OnboardingSchoolStageResponse>> submitSchoolStage({
    required String email,
    required String schoolStage,
  });

  Future<Either<Failure, OnboardingCurrentUniversityProfileResponse>>
  submitCurrentUniversityProfile({
    required String email,
    required String universityName,
    required String department,
    required int universityYear,
  });

  Future<Either<Failure, OnboardingGraduateAcademicProfileResponse>>
  submitGraduateAcademicProfile({
    required String email,
    required String universityName,
    required String department,
    String? certificateImagePath,
    String? identityImagePath,
  });
}
