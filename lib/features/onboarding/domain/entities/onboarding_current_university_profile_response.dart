class OnboardingCurrentUniversityProfileResponse {
  final bool success;
  final String title;
  final int userId;
  final String email;
  final String universityName;
  final String department;
  final int universityYear;

  const OnboardingCurrentUniversityProfileResponse({
    required this.success,
    required this.title,
    required this.userId,
    required this.email,
    required this.universityName,
    required this.department,
    required this.universityYear,
  });
}