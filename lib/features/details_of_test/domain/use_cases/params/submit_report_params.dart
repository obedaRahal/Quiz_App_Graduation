enum ReportTargetType {
  review,
  test,
}

class SubmitReportParams {
  final ReportTargetType targetType;
  final int targetId;
  final String reason;
  final String description;

  const SubmitReportParams({
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.description,
  });
}