class TestBookmarkActionEntity {
  final bool success;
  final String title;
  final TestBookmarkActionDataEntity data;
  final int statusCode;

  const TestBookmarkActionEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class TestBookmarkActionDataEntity {
  final bool hasBookmarked;
  final bool stateChanged;

  const TestBookmarkActionDataEntity({
    required this.hasBookmarked,
    required this.stateChanged,
  });
}