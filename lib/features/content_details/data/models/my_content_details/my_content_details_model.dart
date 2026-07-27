import 'package:quiz_app_grad/features/content_details/domain/entities/my_content_details/my_content_details_entity.dart';

class MyContentDetailsModel extends MyContentDetailsEntity {
  const MyContentDetailsModel({
    required super.basicInfo,
    required super.statusHistory,
  });

  factory MyContentDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return MyContentDetailsModel(
      basicInfo: MyContentBasicInfoModel.fromJson(
        data['basic_info'] as Map<String, dynamic>? ?? {},
      ),
      statusHistory: _asMapList(
        data['status_history'],
      ).map(MyContentStatusHistoryModel.fromJson).toList(),
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
    required super.likeCount,
    required super.bookmarksCount,
    required super.downloadCount,
    required super.reviewStatus,
  });

  factory MyContentBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return MyContentBasicInfoModel(
      id: _asInt(json['id']),
      title: _asString(json['title']),
      description: _asString(json['description']),
      interests:
          (json['interests'] as List?)?.map((e) => e.toString()).toList() ?? [],
      targetLevel: _asString(json['target_level']),
      contentKind: _asString(json['content_kind']),
      visibilityType: _asString(json['visibility_type']),
      assetCount: _asInt(json['asset_count']),
      publishedAt: _asString(json['published_at']),
      assets:
          _asMapList(json['assets']).map(MyContentAssetModel.fromJson).toList()
            ..sort(
              (first, second) => first.position.compareTo(second.position),
            ),
      likeCount: _asInt(json['like_count']),
      bookmarksCount: _asInt(json['bookmarks_count']),
      downloadCount: _asInt(json['download_count']),
      reviewStatus: _asString(json['review_status']),
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
      id: _asInt(json['id']),
      url: _asString(json['url']),
      position: _asInt(json['position']),
    );
  }
}

class MyContentStatusHistoryModel extends MyContentStatusHistoryEntity {
  const MyContentStatusHistoryModel({
    required super.id,
    super.fromStatus,
    required super.toStatus,
    required super.note,
    required super.happenedAt,
  });

  factory MyContentStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    final fromStatus = _asString(json['from_status']);

    return MyContentStatusHistoryModel(
      id: _asInt(json['id']),
      fromStatus: fromStatus.isEmpty ? null : fromStatus,
      toStatus: _asString(json['to_status']),
      note: _asString(json['note']),
      happenedAt: _asString(json['happened_at']),
    );
  }
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}

String _asString(dynamic value) => value?.toString().trim() ?? '';

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
