class ReportOtherContentParams {
  final int contentId;
  final String reason;
  final String? description;

  const ReportOtherContentParams({
    required this.contentId,
    required this.reason,
    this.description,
  });
}