class UpdateTestResponseEntity {
  final bool success;
  final String title;
  final UpdateTestDataEntity data;
  final int statusCode;

  const UpdateTestResponseEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });
}

class UpdateTestDataEntity {
  final int testId;
  final String reviewStatus;
  final bool requiresReview;
  final bool statusChanged;
  final String message;

  const UpdateTestDataEntity({
    required this.testId,
    required this.reviewStatus,
    required this.requiresReview,
    required this.statusChanged,
    required this.message,
  });
}