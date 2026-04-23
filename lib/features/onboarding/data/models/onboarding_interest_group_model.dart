import '../../domain/entities/onboarding_interest_group.dart';
import 'onboarding_interest_item_model.dart';

class OnboardingInterestGroupModel {
  final String title;
  final List<OnboardingInterestItemModel> interests;

  const OnboardingInterestGroupModel({
    required this.title,
    required this.interests,
  });

  factory OnboardingInterestGroupModel.fromJson(Map<String, dynamic> json) {
    final interestsList = json['interests'] as List<dynamic>? ?? [];

    return OnboardingInterestGroupModel(
      title: json['title']?.toString() ?? '',
      interests: interestsList
          .map(
            (item) => OnboardingInterestItemModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  OnboardingInterestGroup toEntity() {
    return OnboardingInterestGroup(
      title: title,
      interests: interests.map((item) => item.toEntity()).toList(),
    );
  }
}