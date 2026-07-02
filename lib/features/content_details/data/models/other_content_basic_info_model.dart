import '../../domain/entities/other_content_basic_info_entity.dart';
import 'other_content_asset_model.dart';
import 'other_content_interest_model.dart';

class OtherContentBasicInfoModel extends OtherContentBasicInfoEntity {
  const OtherContentBasicInfoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.interests,
    required super.targetLevel,
    required super.contentKind,
    required super.assetCount,
    required super.likeCount,
    required super.bookmarksCount,
    required super.downloadCount,
    required super.publishedAt,
    required super.assets,
  });

  factory OtherContentBasicInfoModel.fromJson(Map<String, dynamic> json) {
    return OtherContentBasicInfoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      interests: (json['interests'] as List? ?? [])
          .map((e) {
            if (e is Map<String, dynamic>) {
              return OtherContentInterestModel.fromJson(e);
            }

            return const OtherContentInterestModel(
              id: 0,
              name: '',
            );
          })
          .where((e) => e.name.trim().isNotEmpty)
          .toList(),
      targetLevel: json['target_level'] ?? '',
      contentKind: json['content_kind'] ?? '',
      assetCount: json['asset_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      bookmarksCount: json['bookmarks_count'] ?? 0,
      downloadCount: json['download_count'] ?? 0,
      publishedAt: json['published_at'],
      assets: (json['assets'] as List? ?? [])
          .map((e) => OtherContentAssetModel.fromJson(e))
          .toList(),
    );
  }
}