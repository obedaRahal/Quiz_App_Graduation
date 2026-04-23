import 'onboarding_interest_group.dart';

class OnboardingInterestsResponse {
  final bool success;
  final String title;
  final List<OnboardingInterestGroup> groups;

  const OnboardingInterestsResponse({
    required this.success,
    required this.title,
    required this.groups,
  });
}