class TestLikeActionEntity {
  final bool success;
  final String title;
  final TestLikeActionDataEntity data;
  final int statusCode;

  const TestLikeActionEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class TestLikeActionDataEntity {
  final bool hasLiked;
  final bool stateChanged;

  const TestLikeActionDataEntity({
    required this.hasLiked,
    required this.stateChanged,
  });
}