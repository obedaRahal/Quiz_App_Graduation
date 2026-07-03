

import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_entity.dart';

class MyContentDetailsModel extends MyContentDetailsEntity {
  const MyContentDetailsModel({
    required super.basicInfo,
  });

  factory MyContentDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return MyContentDetailsModel(
      basicInfo: MyContentBasicInfoModel.fromJson(
        data['basic_info'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class MyContentBasicInfoModel extends MyContentBasicInfoEntity {
  const MyContentBasicInfoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.interests,
    required super.targetLevel,
    required super.contentKind,
    required super.visibilityType,
    required super.assetCount,
    required super.publishedAt,
    required super.assets,
  });

  factory MyContentBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return MyContentBasicInfoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      interests: (json['interests'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      targetLevel: json['target_level'] ?? '',
      contentKind: json['content_kind'] ?? '',
      visibilityType: json['visibility_type'] ?? '',
      assetCount: json['asset_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      assets: (json['assets'] as List?)
              ?.map(
                (e) => MyContentAssetModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class MyContentAssetModel extends MyContentAssetEntity {
  const MyContentAssetModel({
    required super.id,
    required super.url,
    required super.position,
  });

  factory MyContentAssetModel.fromJson(Map<String, dynamic> json) {
    return MyContentAssetModel(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      position: json['position'] ?? 0,
    );
  }
}