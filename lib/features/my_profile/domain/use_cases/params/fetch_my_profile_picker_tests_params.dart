class FetchMyProfilePickerTestsParams {
  final int userId;
  final String tab;
  final String? cursor;

  const FetchMyProfilePickerTestsParams({
    required this.userId,
    required this.tab,
    this.cursor,
  });
}