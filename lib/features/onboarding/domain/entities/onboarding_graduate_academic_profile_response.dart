class OnboardingGraduateAcademicProfileResponse {
  final bool success;
  final String title;
  final int userId;
  final String email;
  final String universityName;
  final String department;

  const OnboardingGraduateAcademicProfileResponse({
    required this.success,
    required this.title,
    required this.userId,
    required this.email,
    required this.universityName,
    required this.department,
  });
}