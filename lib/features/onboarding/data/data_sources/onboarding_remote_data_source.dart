import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_current_university_profile_response_model.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_education_level_response_model.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_graduate_academic_profile_response_model.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_interests_response_model.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_progress_preview_response_model.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_school_stage_response_model.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_user_interests_response_model.dart';

import '../../../../core/database/api/api_consumer.dart';
import '../models/onboarding_discovery_source_response_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingDiscoverySourceResponseModel> submitDiscoverySource({
    required String email,
    required String discoverySource,
  });

  Future<OnboardingEducationLevelResponseModel> submitEducationLevel({
    required String email,
    required String governorate,
    required String educationLevel,
  });

  Future<OnboardingSchoolStageResponseModel> submitSchoolStage({
    required String email,
    required String schoolStage,
  });

  Future<OnboardingCurrentUniversityProfileResponseModel>
  submitCurrentUniversityProfile({
    required String email,
    required String universityName,
    required String department,
    required int universityYear,
  });

  Future<OnboardingGraduateAcademicProfileResponseModel>
  submitGraduateAcademicProfile({
    required String email,
    required String universityName,
    required String department,
    String? certificateImagePath,
    String? identityImagePath,
  });

  Future<OnboardingInterestsResponseModel> getOnboardingInterests();

  Future<OnboardingUserInterestsResponseModel> submitUserInterests({
    required String email,
    required List<int> interestIds,
  });

  Future<OnboardingProgressPreviewResponseModel> getOnboardingProgressPreview({
    required String email,
  });
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final ApiConsumer apiConsumer;

  OnboardingRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OnboardingDiscoverySourceResponseModel> submitDiscoverySource({
    required String email,
    required String discoverySource,
  }) async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.submitDiscoverySource ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.onboardingDiscoverySource} | data: {email: $email, discovery_source: $discoverySource}",
    );

    final response = await apiConsumer.post(
      EndPoints.onboardingDiscoverySource,
      data: {'email': email, 'discovery_source': discoverySource},
    );

    debugPrint("← response (submitDiscoverySource): $response");
    debugPrint("=================================================");

    return OnboardingDiscoverySourceResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OnboardingEducationLevelResponseModel> submitEducationLevel({
    required String email,
    required String governorate,
    required String educationLevel,
  }) async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.submitEducationLevel ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.onboardingEducationLevel} | data: {email: $email, governorate: $governorate, education_level: $educationLevel}",
    );

    final response = await apiConsumer.post(
      EndPoints.onboardingEducationLevel,
      data: {
        'email': email,
        'governorate': governorate,
        'education_level': educationLevel,
      },
    );

    debugPrint("← response (submitEducationLevel): $response");
    debugPrint("=================================================");

    return OnboardingEducationLevelResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OnboardingSchoolStageResponseModel> submitSchoolStage({
    required String email,
    required String schoolStage,
  }) async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.submitSchoolStage ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.onboardingSchoolStage} | data: {email: $email, school_stage: $schoolStage}",
    );

    final response = await apiConsumer.post(
      EndPoints.onboardingSchoolStage,
      data: {'email': email, 'school_stage': schoolStage},
    );

    debugPrint("← response (submitSchoolStage): $response");
    debugPrint("=================================================");

    return OnboardingSchoolStageResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OnboardingCurrentUniversityProfileResponseModel>
  submitCurrentUniversityProfile({
    required String email,
    required String universityName,
    required String department,
    required int universityYear,
  }) async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.submitCurrentUniversityProfile ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.onboardingCurrentUniversityProfile} | data: {email: $email, university_name: $universityName, department: $department, university_year: $universityYear}",
    );

    final response = await apiConsumer.post(
      EndPoints.onboardingCurrentUniversityProfile,
      data: {
        'email': email,
        'university_name': universityName,
        'department': department,
        'university_year': universityYear,
      },
    );

    debugPrint("← response (submitCurrentUniversityProfile): $response");
    debugPrint("=================================================");

    return OnboardingCurrentUniversityProfileResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OnboardingGraduateAcademicProfileResponseModel>
  submitGraduateAcademicProfile({
    required String email,
    required String universityName,
    required String department,
    String? certificateImagePath,
    String? identityImagePath,
  }) async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.submitGraduateAcademicProfile ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.onboardingGraduateAcademicProfile} | data: {email: $email, university_name: $universityName, department: $department, certificate_image: $certificateImagePath, identity_image: $identityImagePath}",
    );

    final Map<String, dynamic> formMap = {
      'email': email,
      'university_name': universityName,
      'department': department,
    };

    if (certificateImagePath != null &&
        certificateImagePath.trim().isNotEmpty) {
      formMap['certificate_image'] = await MultipartFile.fromFile(
        certificateImagePath,
        filename: _extractFileName(certificateImagePath),
      );
    }

    if (identityImagePath != null && identityImagePath.trim().isNotEmpty) {
      formMap['identity_image'] = await MultipartFile.fromFile(
        identityImagePath,
        filename: _extractFileName(identityImagePath),
      );
    }

    final response = await apiConsumer.post(
      EndPoints.onboardingGraduateAcademicProfile,
      data: FormData.fromMap(formMap),
    );

    debugPrint("← response (submitGraduateAcademicProfile): $response");
    debugPrint("=================================================");

    return OnboardingGraduateAcademicProfileResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  String _extractFileName(String path) {
    final normalizedPath = path.replaceAll('\\', '/');
    return normalizedPath.split('/').last;
  }

  @override
  Future<OnboardingInterestsResponseModel> getOnboardingInterests() async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.getOnboardingInterests ============",
    );
    debugPrint("→ endpoint: ${EndPoints.onboardingInterests}");

    final response = await apiConsumer.get(EndPoints.onboardingInterests);

    debugPrint("← response (getOnboardingInterests): $response");
    debugPrint("=================================================");

    return OnboardingInterestsResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<OnboardingUserInterestsResponseModel> submitUserInterests({
    required String email,
    required List<int> interestIds,
  }) async {
    debugPrint(
      "============ OnboardingRemoteDataSourceImpl.submitUserInterests ============",
    );
    debugPrint(
      "→ endpoint: ${EndPoints.onboardingUserInterests} | data: {email: $email, interest_ids: $interestIds}",
    );

    final response = await apiConsumer.post(
      EndPoints.onboardingUserInterests,
      data: {'email': email, 'interest_ids': interestIds},
    );

    debugPrint("← response (submitUserInterests): $response");
    debugPrint("=================================================");

    return OnboardingUserInterestsResponseModel.fromJson(
      response as Map<String, dynamic>,
    );
  }


  @override
Future<OnboardingProgressPreviewResponseModel> getOnboardingProgressPreview({
  required String email,
}) async {
  debugPrint(
    "============ OnboardingRemoteDataSourceImpl.getOnboardingProgressPreview ============",
  );
  debugPrint(
    "→ endpoint: ${EndPoints.onboardingProgressPreview} | data: {email: $email}",
  );

  final response = await apiConsumer.post(
    EndPoints.onboardingProgressPreview,
    data: {
      'email': email,
    },
  );

  debugPrint("← response (getOnboardingProgressPreview): $response");
  debugPrint("=================================================");

  return OnboardingProgressPreviewResponseModel.fromJson(
    response as Map<String, dynamic>,
  );
}
}
