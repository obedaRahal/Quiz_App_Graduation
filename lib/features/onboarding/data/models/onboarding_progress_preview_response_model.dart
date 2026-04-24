import '../../domain/entities/onboarding_progress_preview_response.dart';

class OnboardingProgressPreviewResponseModel {
  final bool success;
  final String title;
  final String? discoverySource;
  final String? educationLevel;

  const OnboardingProgressPreviewResponseModel({
    required this.success,
    required this.title,
    required this.discoverySource,
    required this.educationLevel,
  });

  factory OnboardingProgressPreviewResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return OnboardingProgressPreviewResponseModel(
      success: json['success'] as bool? ?? false,
      title: json['title']?.toString() ?? '',
      discoverySource: data['discovery_source']?.toString(),
      educationLevel: data['education_level']?.toString(),
    );
  }

  OnboardingProgressPreviewResponse toEntity() {
    return OnboardingProgressPreviewResponse(
      success: success,
      title: title,
      discoverySource: discoverySource,
      educationLevel: educationLevel,
    );
  }
}