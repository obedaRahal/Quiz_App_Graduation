class MyProfileLibraryEntity {
  final bool success;
  final String message;
  final List<MyProfileLibraryItemEntity> data;
  final MyProfileLibraryMetaEntity meta;
  final int statusCode;

  const MyProfileLibraryEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class MyProfileLibraryItemEntity {
  final int id;
  final String urlContent;
  final String title;
  final String description;
  final String type;
  final String libraryMaterialKind;
  final List<String> interests;
  final int likeCount;
  final String publishedAt;
  final bool viewerHasBookmarked;

  const MyProfileLibraryItemEntity({
    required this.id,
    required this.urlContent,
    required this.title,
    required this.description,
    required this.type,
    required this.libraryMaterialKind,
    required this.interests,
    required this.likeCount,
    required this.publishedAt,
    required this.viewerHasBookmarked,
  });
}

class MyProfileLibraryMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const MyProfileLibraryMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMorePages,
  });
}