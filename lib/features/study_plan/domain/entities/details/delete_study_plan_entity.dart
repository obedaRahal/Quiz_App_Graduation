class DeleteStudyPlanEntity {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const DeleteStudyPlanEntity({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'DeleteStudyPlanEntity('
        'success: $success, '
        'title: $title, '
        'message: $message, '
        'statusCode: $statusCode'
        ')';
  }
}
