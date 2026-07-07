class SearchMyProfileLibraryParams {
  final String query;
  final String mode;
  final String? cursor;

  const SearchMyProfileLibraryParams({
    required this.query,
    this.mode = 'user_owned',
    this.cursor,
  });
}