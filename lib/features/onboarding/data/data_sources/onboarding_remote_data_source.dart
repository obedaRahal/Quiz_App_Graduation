import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';

import '../../../../core/database/api/api_consumer.dart';
import '../models/onboarding_discovery_source_response_model.dart';

abstract class OnboardingRemoteDataSource {
  Future<OnboardingDiscoverySourceResponseModel> submitDiscoverySource({
    required String email,
    required String discoverySource,
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
}
