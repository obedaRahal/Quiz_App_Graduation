import '../../domain/entities/recommended_interests_response_entity.dart';

class RecommendedInterestsResponseModel {
  final bool success;
  final String title;
  final List<RecommendedInterestModel> data;
  final int statusCode;

  const RecommendedInterestsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory RecommendedInterestsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RecommendedInterestsResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => RecommendedInterestModel.fromJson(item))
          .toList(),
      statusCode: json['status_code'] ?? 0,
    );
  }

  RecommendedInterestsResponseEntity toEntity() {
    return RecommendedInterestsResponseEntity(
      success: success,
      title: title,
      interests: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class RecommendedInterestModel {
  final int id;
  final String name;
  final String iconSvg;
  final int testsCount;

  const RecommendedInterestModel({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.testsCount,
  });

  factory RecommendedInterestModel.fromJson(Map<String, dynamic> json) {
    return RecommendedInterestModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      iconSvg: json['icon_svg'] ?? '',
      testsCount: json['tests_count'] ?? 0,
    );
  }

  RecommendedInterestEntity toEntity() {
    return RecommendedInterestEntity(
      id: id,
      name: name,
      iconSvg: iconSvg,
      testsCount: testsCount,
    );
  }
}