class FetchMyProfileLibraryParams {
  final int userId;
  final String tab;
  final String? cursor;

  const FetchMyProfileLibraryParams({
    required this.userId,
    required this.tab,
    this.cursor,
  });
}