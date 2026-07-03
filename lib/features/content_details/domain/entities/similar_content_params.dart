class SimilarContentParams {
  final int contentId;
  final List<int> interestIds;
  final int perPage;
  final String? cursor;

  const SimilarContentParams({
    required this.contentId,
    required this.interestIds,
    this.perPage = 20,
    this.cursor,
  });
}