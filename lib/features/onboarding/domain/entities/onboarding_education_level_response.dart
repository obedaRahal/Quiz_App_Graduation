class OnboardingEducationLevelResponse {
  final bool success;
  final String title;
  final int userId;
  final String email;
  final String governorate;
  final String educationLevel;

  const OnboardingEducationLevelResponse({
    required this.success,
    required this.title,
    required this.userId,
    required this.email,
    required this.governorate,
    required this.educationLevel,
  });
}