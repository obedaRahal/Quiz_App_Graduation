import '../../domain/entities/onboarding_discovery_source_response.dart';

class OnboardingDiscoverySourceResponseModel {
  final bool success;
  final String title;
  final OnboardingDiscoverySourceProfileModel onboardingProfile;

  const OnboardingDiscoverySourceResponseModel({
    required this.success,
    required this.title,
    required this.onboardingProfile,
  });

  factory OnboardingDiscoverySourceResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final profile = data['onboarding_profile'] as Map<String, dynamic>? ?? {};

    return OnboardingDiscoverySourceResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      onboardingProfile: OnboardingDiscoverySourceProfileModel.fromJson(
        profile,
      ),
    );
  }

  OnboardingDiscoverySourceResponse toEntity() {
    return OnboardingDiscoverySourceResponse(
      success: success,
      title: title,
      userId: onboardingProfile.userId,
      email: onboardingProfile.email,
      discoverySource: onboardingProfile.discoverySource,
    );
  }
}

class OnboardingDiscoverySourceProfileModel {
  final int userId;
  final String email;
  final String discoverySource;

  const OnboardingDiscoverySourceProfileModel({
    required this.userId,
    required this.email,
    required this.discoverySource,
  });

  factory OnboardingDiscoverySourceProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingDiscoverySourceProfileModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      discoverySource: json['discovery_source']?.toString() ?? '',
    );
  }
}
