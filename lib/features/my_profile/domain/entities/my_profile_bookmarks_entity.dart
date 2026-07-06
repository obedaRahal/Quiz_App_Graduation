abstract class MyProfileBookmarkItemEntity {
  final int id;

  const MyProfileBookmarkItemEntity({
    required this.id,
  });
}

class MyProfileBookmarksEntity {
  final bool success;
  final String title;
  final MyProfileBookmarksDataEntity data;
  final int statusCode;

  const MyProfileBookmarksEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class MyProfileBookmarksDataEntity {
  final String tab;
  final List<MyProfileBookmarkItemEntity> items;
  final MyProfileBookmarksMetaEntity meta;

  const MyProfileBookmarksDataEntity({
    required this.tab,
    required this.items,
    required this.meta,
  });
}

class MyProfileBookmarksMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? previousCursor;
  final bool hasMorePages;

  const MyProfileBookmarksMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.previousCursor,
    required this.hasMorePages,
  });
}

class MyProfileBookmarkTestEntity extends MyProfileBookmarkItemEntity {
  final String title;
  final String description;
  final List<String> interests;
  final String difficultyLevel;
  final double averageRating;
  final String price;
  final String publishedAt;
  final int questionCount;

  const MyProfileBookmarkTestEntity({
    required super.id,
    required this.title,
    required this.description,
    required this.interests,
    required this.difficultyLevel,
    required this.averageRating,
    required this.price,
    required this.publishedAt,
    required this.questionCount,
  });
}

class MyProfileBookmarkMaterialEntity extends MyProfileBookmarkItemEntity {
  final String urlContent;
  final String title;
  final String description;
  final String type;
  final List<String> interests;
  final int likeCount;
  final String publishedAt;
  final bool viewerHasBookmarked;

  const MyProfileBookmarkMaterialEntity({
    required super.id,
    required this.urlContent,
    required this.title,
    required this.description,
    required this.type,
    required this.interests,
    required this.likeCount,
    required this.publishedAt,
    required this.viewerHasBookmarked,
  });
}

class MyProfileBookmarkFolderEntity extends MyProfileBookmarkItemEntity {
  final String name;
  final int testsCount;
  final String publishedAt;
  final List<String> scientificInterests;
  final String colorCode;
  final bool viewerHasBookmarked;

  const MyProfileBookmarkFolderEntity({
    required super.id,
    required this.name,
    required this.testsCount,
    required this.publishedAt,
    required this.scientificInterests,
    required this.colorCode,
    required this.viewerHasBookmarked,
  });
}