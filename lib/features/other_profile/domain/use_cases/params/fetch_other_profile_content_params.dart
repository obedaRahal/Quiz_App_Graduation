class FetchOtherProfileContentParams {
  final int userId;
  final String tab;
  final String? cursor;

  const FetchOtherProfileContentParams({
    required this.userId,
    required this.tab,
    this.cursor,
  });
}
