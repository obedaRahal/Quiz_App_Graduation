class LibraryMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? previousCursor;
  final bool hasMorePages;

  const LibraryMetaEntity({
    required this.perPage,
    required this.nextCursor,
    required this.previousCursor,
    required this.hasMorePages,
  });
}