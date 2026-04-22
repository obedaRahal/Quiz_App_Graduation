import '../../domain/entities/onboarding_school_stage_response.dart';

class OnboardingSchoolStageResponseModel {
  final bool success;
  final String title;
  final OnboardingSchoolStageProfileModel onboardingProfile;

  const OnboardingSchoolStageResponseModel({
    required this.success,
    required this.title,
    required this.onboardingProfile,
  });

  factory OnboardingSchoolStageResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final profile = data['onboarding_profile'] as Map<String, dynamic>? ?? {};

    return OnboardingSchoolStageResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      onboardingProfile: OnboardingSchoolStageProfileModel.fromJson(profile),
    );
  }

  OnboardingSchoolStageResponse toEntity() {
    return OnboardingSchoolStageResponse(
      success: success,
      title: title,
      userId: onboardingProfile.userId,
      email: onboardingProfile.email,
      schoolStage: onboardingProfile.schoolStage,
    );
  }
}

class OnboardingSchoolStageProfileModel {
  final int userId;
  final String email;
  final String schoolStage;

  const OnboardingSchoolStageProfileModel({
    required this.userId,
    required this.email,
    required this.schoolStage,
  });

  factory OnboardingSchoolStageProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingSchoolStageProfileModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      schoolStage: json['school_stage']?.toString() ?? '',
    );
  }
}