class OnboardingProgressPreviewResponse {
  final bool success;
  final String title;
  final String? discoverySource;
  final String? educationLevel;

  const OnboardingProgressPreviewResponse({
    required this.success,
    required this.title,
    required this.discoverySource,
    required this.educationLevel,
  });
}