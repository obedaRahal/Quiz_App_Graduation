class SimilarContentMetaEntity {
  final int perPage;
  final String? nextCursor;
  final String? previousCursor;
  final bool hasMorePages;

  const SimilarContentMetaEntity({
    required this.perPage,
    this.nextCursor,
    this.previousCursor,
    required this.hasMorePages,
  });
}