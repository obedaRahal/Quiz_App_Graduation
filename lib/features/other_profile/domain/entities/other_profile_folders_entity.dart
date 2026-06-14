class OtherProfileFoldersResponseEntity {
  final bool success;
  final String message;
  final List<OtherProfileFolderItemEntity> data;
  final OtherProfileFoldersMetaEntity meta;
  final int statusCode;

  const OtherProfileFoldersResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class OtherProfileFolderItemEntity {
  final int id;
  final String name;
  final int testsCount;
  final String publishedAt;
  final List<String> scientificInterests;
  final String colorCode;
  final bool viewerHasBookmarked;

  const OtherProfileFolderItemEntity({
    required this.id,
    required this.name,
    required this.testsCount,
    required this.publishedAt,
    required this.scientificInterests,
    required this.colorCode,
    required this.viewerHasBookmarked,
  });
}

class OtherProfileFoldersMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const OtherProfileFoldersMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMorePages,
  });
}