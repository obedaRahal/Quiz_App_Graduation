class OnboardingSchoolStageResponse {
  final bool success;
  final String title;
  final int userId;
  final String email;
  final String schoolStage;

  const OnboardingSchoolStageResponse({
    required this.success,
    required this.title,
    required this.userId,
    required this.email,
    required this.schoolStage,
  });
}