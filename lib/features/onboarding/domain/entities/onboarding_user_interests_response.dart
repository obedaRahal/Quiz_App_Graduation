class OnboardingUserInterestsResponse {
  final bool success;
  final String title;
  final int userId;
  final List<int> interestIds;
  final int interestsCount;

  const OnboardingUserInterestsResponse({
    required this.success,
    required this.title,
    required this.userId,
    required this.interestIds,
    required this.interestsCount,
  });
}