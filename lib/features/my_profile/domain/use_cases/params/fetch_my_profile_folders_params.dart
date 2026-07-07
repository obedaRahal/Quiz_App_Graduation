class FetchMyProfileFoldersParams {
  final int userId;
  final String tab;
  final String? cursor;

  const FetchMyProfileFoldersParams({
    required this.userId,
    required this.tab,
    this.cursor,
  });
}