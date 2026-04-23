import '../../domain/entities/onboarding_interest_item.dart';

class OnboardingInterestItemModel {
  final int id;
  final String name;

  const OnboardingInterestItemModel({
    required this.id,
    required this.name,
  });

  factory OnboardingInterestItemModel.fromJson(Map<String, dynamic> json) {
    return OnboardingInterestItemModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  OnboardingInterestItem toEntity() {
    return OnboardingInterestItem(
      id: id,
      name: name,
    );
  }
}