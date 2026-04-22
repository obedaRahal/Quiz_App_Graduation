import '../../domain/entities/onboarding_current_university_profile_response.dart';

class OnboardingCurrentUniversityProfileResponseModel {
  final bool success;
  final String title;
  final OnboardingCurrentUniversityProfileModel onboardingProfile;

  const OnboardingCurrentUniversityProfileResponseModel({
    required this.success,
    required this.title,
    required this.onboardingProfile,
  });

  factory OnboardingCurrentUniversityProfileResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final profile = data['onboarding_profile'] as Map<String, dynamic>? ?? {};

    return OnboardingCurrentUniversityProfileResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      onboardingProfile:
          OnboardingCurrentUniversityProfileModel.fromJson(profile),
    );
  }

  OnboardingCurrentUniversityProfileResponse toEntity() {
    return OnboardingCurrentUniversityProfileResponse(
      success: success,
      title: title,
      userId: onboardingProfile.userId,
      email: onboardingProfile.email,
      universityName: onboardingProfile.universityName,
      department: onboardingProfile.department,
      universityYear: onboardingProfile.universityYear,
    );
  }
}

class OnboardingCurrentUniversityProfileModel {
  final int userId;
  final String email;
  final String universityName;
  final String department;
  final int universityYear;

  const OnboardingCurrentUniversityProfileModel({
    required this.userId,
    required this.email,
    required this.universityName,
    required this.department,
    required this.universityYear,
  });

  factory OnboardingCurrentUniversityProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingCurrentUniversityProfileModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      universityName: json['university_name']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      universityYear: json['university_year'] is int
          ? json['university_year'] as int
          : int.tryParse(json['university_year']?.toString() ?? '0') ?? 0,
    );
  }
}