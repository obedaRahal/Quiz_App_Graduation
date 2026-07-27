class MyContentDetailsEntity {
  final MyContentBasicInfoEntity basicInfo;
  final List<MyContentStatusHistoryEntity> statusHistory;

  const MyContentDetailsEntity({
    required this.basicInfo,
    this.statusHistory = const [],
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
  final int likeCount;
  final int bookmarksCount;
  final int downloadCount;
  final String reviewStatus;

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
    this.likeCount = 0,
    this.bookmarksCount = 0,
    this.downloadCount = 0,
    this.reviewStatus = '',
  });

  bool get isPublic {
    final normalized = visibilityType.trim().toLowerCase();
    return normalized == 'عام' ||
        normalized == 'محتوى عام' ||
        normalized == 'public';
  }
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

class MyContentStatusHistoryEntity {
  final int id;
  final String? fromStatus;
  final String toStatus;
  final String note;
  final String happenedAt;

  const MyContentStatusHistoryEntity({
    required this.id,
    this.fromStatus,
    required this.toStatus,
    required this.note,
    required this.happenedAt,
  });
}
