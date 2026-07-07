class MyProfileFoldersEntity {
  final bool success;
  final String message;
  final List<MyProfileFolderItemEntity> data;
  final MyProfileFoldersMetaEntity meta;
  final int statusCode;

  const MyProfileFoldersEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
    required this.statusCode,
  });
}

class MyProfileFolderItemEntity {
  final int id;
  final String name;
  final int testsCount;
  final String publishedAt;
  final List<String> scientificInterests;
  final String colorCode;
  final String folderKind;

  const MyProfileFolderItemEntity({
    required this.id,
    required this.name,
    required this.testsCount,
    required this.publishedAt,
    required this.scientificInterests,
    required this.colorCode,
    required this.folderKind,
  });
}

class MyProfileFoldersMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const MyProfileFoldersMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.prevCursor,
    required this.hasMorePages,
  });
}