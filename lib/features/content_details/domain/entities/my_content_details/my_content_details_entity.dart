class MyContentDetailsEntity {
  final MyContentBasicInfoEntity basicInfo;

  const MyContentDetailsEntity({
    required this.basicInfo,
  });
}

class MyContentBasicInfoEntity {
  final int id;
  final String title;
  final String description;
  final List<String> interests;
  final String targetLevel;
  final String contentKind;
  final String visibilityType;
  final int assetCount;
  final String publishedAt;
  final List<MyContentAssetEntity> assets;

  const MyContentBasicInfoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.targetLevel,
    required this.contentKind,
    required this.visibilityType,
    required this.assetCount,
    required this.publishedAt,
    required this.assets,
  });

  bool get isPublic => visibilityType.trim() == 'محتوى عام';
}

class MyContentAssetEntity {
  final int id;
  final String url;
  final int position;

  const MyContentAssetEntity({
    required this.id,
    required this.url,
    required this.position,
  });
}