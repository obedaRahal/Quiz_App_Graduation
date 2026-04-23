import '../../domain/entities/onboarding_user_interests_response.dart';

class OnboardingUserInterestsResponseModel {
  final bool success;
  final String title;
  final OnboardingUserInterestsProfileModel onboardingProfile;

  const OnboardingUserInterestsResponseModel({
    required this.success,
    required this.title,
    required this.onboardingProfile,
  });

  factory OnboardingUserInterestsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final profile = data['onboarding_profile'] as Map<String, dynamic>? ?? {};

    return OnboardingUserInterestsResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      onboardingProfile: OnboardingUserInterestsProfileModel.fromJson(profile),
    );
  }

  OnboardingUserInterestsResponse toEntity() {
    return OnboardingUserInterestsResponse(
      success: success,
      title: title,
      userId: onboardingProfile.userId,
      interestIds: onboardingProfile.interestIds,
      interestsCount: onboardingProfile.interestsCount,
    );
  }
}

class OnboardingUserInterestsProfileModel {
  final int userId;
  final List<int> interestIds;
  final int interestsCount;

  const OnboardingUserInterestsProfileModel({
    required this.userId,
    required this.interestIds,
    required this.interestsCount,
  });

  factory OnboardingUserInterestsProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final idsList = json['interest_ids'] as List<dynamic>? ?? [];

    return OnboardingUserInterestsProfileModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      interestIds: idsList
          .map((item) => item is int ? item : int.tryParse(item.toString()) ?? 0)
          .toList(),
      interestsCount: json['interests_count'] is int
          ? json['interests_count'] as int
          : int.tryParse(json['interests_count']?.toString() ?? '0') ?? 0,
    );
  }
}