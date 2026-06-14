class FetchOtherProfileTestsParams {
  final int userId;
  final String tab;
  final String? cursor;

  const FetchOtherProfileTestsParams({
    required this.userId,
    required this.tab,
    this.cursor,
  });
}
