import 'other_content_asset_entity.dart';
import 'other_content_interest_entity.dart';

class OtherContentBasicInfoEntity {
  final int id;
  final String title;
  final String description;
  final List<OtherContentInterestEntity> interests;
  final String targetLevel;
  final String contentKind;
  final int assetCount;
  final int likeCount;
  final int bookmarksCount;
  final int downloadCount;
  final String? publishedAt;
  final List<OtherContentAssetEntity> assets;

  const OtherContentBasicInfoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.targetLevel,
    required this.contentKind,
    required this.assetCount,
    required this.likeCount,
    required this.bookmarksCount,
    required this.downloadCount,
    required this.publishedAt,
    required this.assets,
  });

  bool get isFile => contentKind.trim() == 'ملف';
}