class SubmitReportEntity {
  final bool success;
  final String title;
  final String message;
  final int statusCode;
  final bool isStatusChanged;

  const SubmitReportEntity({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
    required this.isStatusChanged,
  });
}
