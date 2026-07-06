class FetchMyProfileBookmarksParams {
  final String tab;
  final String? cursor;

  const FetchMyProfileBookmarksParams({
    required this.tab,
    this.cursor,
  });
}