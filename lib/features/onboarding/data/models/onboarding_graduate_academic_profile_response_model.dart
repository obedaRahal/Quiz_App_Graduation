import '../../domain/entities/onboarding_graduate_academic_profile_response.dart';

class OnboardingGraduateAcademicProfileResponseModel {
  final bool success;
  final String title;
  final OnboardingGraduateAcademicProfileModel onboardingProfile;

  const OnboardingGraduateAcademicProfileResponseModel({
    required this.success,
    required this.title,
    required this.onboardingProfile,
  });

  factory OnboardingGraduateAcademicProfileResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final profile = data['onboarding_profile'] as Map<String, dynamic>? ?? {};

    return OnboardingGraduateAcademicProfileResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      onboardingProfile:
          OnboardingGraduateAcademicProfileModel.fromJson(profile),
    );
  }

  OnboardingGraduateAcademicProfileResponse toEntity() {
    return OnboardingGraduateAcademicProfileResponse(
      success: success,
      title: title,
      userId: onboardingProfile.userId,
      email: onboardingProfile.email,
      universityName: onboardingProfile.universityName,
      department: onboardingProfile.department,
    );
  }
}

class OnboardingGraduateAcademicProfileModel {
  final int userId;
  final String email;
  final String universityName;
  final String department;

  const OnboardingGraduateAcademicProfileModel({
    required this.userId,
    required this.email,
    required this.universityName,
    required this.department,
  });

  factory OnboardingGraduateAcademicProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingGraduateAcademicProfileModel(
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      email: json['email']?.toString() ?? '',
      universityName: json['university_name']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
    );
  }
}