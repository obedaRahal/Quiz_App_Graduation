import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_current_university_profile_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_education_level_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_graduate_academic_profile_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_interests_response.dart';
import 'package:quiz_app_grad/features/onboarding/domain/entities/onboarding_school_stage_response.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_discovery_source_response.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OnboardingDiscoverySourceResponse>>
  submitDiscoverySource({
    required String email,
    required String discoverySource,
  }) async {
    debugPrint(
      "============ OnboardingRepositoryImpl.submitDiscoverySource ============",
    );
    debugPrint("→ params: {email: $email, discovery_source: $discoverySource}");

    try {
      debugPrint("→ calling remoteDataSource.submitDiscoverySource");

      final model = await remoteDataSource.submitDiscoverySource(
        email: email,
        discoverySource: discoverySource,
      );

      debugPrint("← remoteDataSource.submitDiscoverySource success");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitDiscoverySource ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(
          message: e.errorModel.errorMessage,
          title: e.errorModel.errorTitle,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitDiscoverySource CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitDiscoverySource Unexpected error: $e",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OnboardingEducationLevelResponse>>
  submitEducationLevel({
    required String email,
    required String governorate,
    required String educationLevel,
  }) async {
    debugPrint(
      "============ OnboardingRepositoryImpl.submitEducationLevel ============",
    );
    debugPrint(
      "→ params: {email: $email, governorate: $governorate, education_level: $educationLevel}",
    );

    try {
      debugPrint("→ calling remoteDataSource.submitEducationLevel");

      final model = await remoteDataSource.submitEducationLevel(
        email: email,
        governorate: governorate,
        educationLevel: educationLevel,
      );

      debugPrint("← remoteDataSource.submitEducationLevel success");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitEducationLevel ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitEducationLevel CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitEducationLevel Unexpected error: $e",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OnboardingSchoolStageResponse>> submitSchoolStage({
    required String email,
    required String schoolStage,
  }) async {
    debugPrint(
      "============ OnboardingRepositoryImpl.submitSchoolStage ============",
    );
    debugPrint("→ params: {email: $email, school_stage: $schoolStage}");

    try {
      debugPrint("→ calling remoteDataSource.submitSchoolStage");

      final model = await remoteDataSource.submitSchoolStage(
        email: email,
        schoolStage: schoolStage,
      );

      debugPrint("← remoteDataSource.submitSchoolStage success");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitSchoolStage ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitSchoolStage CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitSchoolStage Unexpected error: $e",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OnboardingCurrentUniversityProfileResponse>>
  submitCurrentUniversityProfile({
    required String email,
    required String universityName,
    required String department,
    required int universityYear,
  }) async {
    debugPrint(
      "============ OnboardingRepositoryImpl.submitCurrentUniversityProfile ============",
    );
    debugPrint(
      "→ params: {email: $email, university_name: $universityName, department: $department, university_year: $universityYear}",
    );

    try {
      debugPrint("→ calling remoteDataSource.submitCurrentUniversityProfile");

      final model = await remoteDataSource.submitCurrentUniversityProfile(
        email: email,
        universityName: universityName,
        department: department,
        universityYear: universityYear,
      );

      debugPrint("← remoteDataSource.submitCurrentUniversityProfile success");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitCurrentUniversityProfile ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitCurrentUniversityProfile CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitCurrentUniversityProfile Unexpected error: $e",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
  Future<Either<Failure, OnboardingGraduateAcademicProfileResponse>>
  submitGraduateAcademicProfile({
    required String email,
    required String universityName,
    required String department,
    String? certificateImagePath,
    String? identityImagePath,
  }) async {
    debugPrint(
      "============ OnboardingRepositoryImpl.submitGraduateAcademicProfile ============",
    );
    debugPrint(
      "→ params: {email: $email, university_name: $universityName, department: $department, certificate_image: $certificateImagePath, identity_image: $identityImagePath}",
    );

    try {
      debugPrint("→ calling remoteDataSource.submitGraduateAcademicProfile");

      final model = await remoteDataSource.submitGraduateAcademicProfile(
        email: email,
        universityName: universityName,
        department: department,
        certificateImagePath: certificateImagePath,
        identityImagePath: identityImagePath,
      );

      debugPrint("← remoteDataSource.submitGraduateAcademicProfile success");
      debugPrint("=================================================");

      return Right(model.toEntity());
    } on ServerException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitGraduateAcademicProfile ServerException: ${e.errorModel.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitGraduateAcademicProfile CacheException: ${e.errorMessage}",
      );
      debugPrint("=================================================");
      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e) {
      debugPrint(
        "✗ OnboardingRepositoryImpl.submitGraduateAcademicProfile Unexpected error: $e",
      );
      debugPrint("=================================================");
      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'حدث خطأ غير متوقع'),
      );
    }
  }

  @override
Future<Either<Failure, OnboardingInterestsResponse>> getOnboardingInterests() async {
  debugPrint(
    "============ OnboardingRepositoryImpl.getOnboardingInterests ============",
  );

  try {
    debugPrint("→ calling remoteDataSource.getOnboardingInterests");

    final model = await remoteDataSource.getOnboardingInterests();

    debugPrint("← remoteDataSource.getOnboardingInterests success");
    debugPrint("=================================================");

    return Right(model.toEntity());
  } on ServerException catch (e) {
    debugPrint(
      "✗ OnboardingRepositoryImpl.getOnboardingInterests ServerException: ${e.errorModel.errorMessage}",
    );
    debugPrint("=================================================");
    return Left(
      ServerFailure(
        title: e.errorModel.errorTitle,
        message: e.errorModel.errorMessage,
      ),
    );
  } on CacheException catch (e) {
    debugPrint(
      "✗ OnboardingRepositoryImpl.getOnboardingInterests CacheException: ${e.errorMessage}",
    );
    debugPrint("=================================================");
    return Left(
      CacheFailure(
        title: 'خطأ محلي',
        message: e.errorMessage,
      ),
    );
  } catch (e) {
    debugPrint(
      "✗ OnboardingRepositoryImpl.getOnboardingInterests Unexpected error: $e",
    );
    debugPrint("=================================================");
    return Left(
      ServerFailure(
        title: 'حدث خطأ',
        message: 'حدث خطأ غير متوقع',
      ),
    );
  }
}
}
