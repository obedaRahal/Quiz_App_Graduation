class OnboardingDiscoverySourceResponse {
  final bool success;
  final String title;
  final int userId;
  final String email;
  final String discoverySource;

  const OnboardingDiscoverySourceResponse({
    required this.success,
    required this.title,
    required this.userId,
    required this.email,
    required this.discoverySource,
  });
}
