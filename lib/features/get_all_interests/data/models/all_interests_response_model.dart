import '../../domain/entities/all_interests_response_entity.dart';

class AllInterestsResponseModel {
  final bool success;
  final String title;
  final List<InterestCategoryModel> data;
  final int statusCode;

  const AllInterestsResponseModel({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  factory AllInterestsResponseModel.fromJson(Map<String, dynamic> json) {
    return AllInterestsResponseModel(
      success: json['success'] ?? false,
      title: json['title'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => InterestCategoryModel.fromJson(item))
          .toList(),
      statusCode: json['status_code'] ?? 0,
    );
  }

  AllInterestsResponseEntity toEntity() {
    return AllInterestsResponseEntity(
      success: success,
      title: title,
      categories: data.map((item) => item.toEntity()).toList(),
      statusCode: statusCode,
    );
  }
}

class InterestCategoryModel {
  final int id;
  final String title;
  final List<InterestItemModel> interests;

  const InterestCategoryModel({
    required this.id,
    required this.title,
    required this.interests,
  });

  factory InterestCategoryModel.fromJson(Map<String, dynamic> json) {
    return InterestCategoryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      interests: (json['interests'] as List? ?? [])
          .map((item) => InterestItemModel.fromJson(item))
          .toList(),
    );
  }

  InterestCategoryEntity toEntity() {
    return InterestCategoryEntity(
      id: id,
      title: title,
      interests: interests.map((item) => item.toEntity()).toList(),
    );
  }
}

class InterestItemModel {
  final int id;
  final String name;
  final String iconSvg;
  final String iconColor;

  const InterestItemModel({
    required this.id,
    required this.name,
    required this.iconSvg,
    required this.iconColor,
  });

  factory InterestItemModel.fromJson(Map<String, dynamic> json) {
    return InterestItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      iconSvg: json['icon_svg'] ?? '',
      iconColor: json['icon_color'] ?? '',
    );
  }

  InterestItemEntity toEntity() {
    return InterestItemEntity(
      id: id,
      name: name,
      iconSvg: iconSvg,
      iconColor: iconColor,
    );
  }
}