import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/onboarding/data/models/onboarding_education_level_response_model.dart';

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
}
