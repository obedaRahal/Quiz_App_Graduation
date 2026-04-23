import '../../domain/entities/onboarding_interests_response.dart';
import 'onboarding_interest_group_model.dart';

class OnboardingInterestsResponseModel {
  final bool success;
  final String title;
  final List<OnboardingInterestGroupModel> groups;

  const OnboardingInterestsResponseModel({
    required this.success,
    required this.title,
    required this.groups,
  });

  factory OnboardingInterestsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return OnboardingInterestsResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      groups: dataList
          .map(
            (item) => OnboardingInterestGroupModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  OnboardingInterestsResponse toEntity() {
    return OnboardingInterestsResponse(
      success: success,
      title: title,
      groups: groups.map((group) => group.toEntity()).toList(),
    );
  }
}