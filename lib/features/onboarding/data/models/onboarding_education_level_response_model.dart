import '../../domain/entities/onboarding_education_level_response.dart';

class OnboardingEducationLevelResponseModel {
  final bool success;
  final String title;
  final OnboardingEducationLevelProfileModel onboardingProfile;

  const OnboardingEducationLevelResponseModel({
    required this.success,
    required this.title,
    required this.onboardingProfile,
  });

  factory OnboardingEducationLevelResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final profile = data['onboarding_profile'] as Map<String, dynamic>? ?? {};

    return OnboardingEducationLevelResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      onboardingProfile: OnboardingEducationLevelProfileModel.fromJson(profile),
    );
  }

  OnboardingEducationLevelResponse toEntity() {
    return OnboardingEducationLevelResponse(
      success: success,
      title: title,
      userId: onboardingProfile.userId,
      email: onboardingProfile.email,
      governorate: onboardingProfile.governorate,
      educationLevel: onboardingProfile.educationLevel,
    );
  }
}

class OnboardingEducationLevelProfileModel {
  final int userId;
  final String email;
  final String governorate;
  final String educationLevel;

  const OnboardingEducationLevelProfileModel({
    required this.userId,
    required this.email,
    required this.governorate,
    required this.educationLevel,
  });

  factory OnboardingEducationLevelProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingEducationLevelProfileModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      educationLevel: json['education_level']?.toString() ?? '',
    );
  }
}