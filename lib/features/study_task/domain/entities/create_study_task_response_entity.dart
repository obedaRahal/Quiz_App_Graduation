class CreateStudyTaskResponseEntity {
  final bool success;
  final String title;
  final String message;
  final int statusCode;

  const CreateStudyTaskResponseEntity({
    required this.success,
    required this.title,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'CreateStudyTaskResponseEntity('
        'success: $success, '
        'title: $title, '
        'message: $message, '
        'statusCode: $statusCode'
        ')';
  }
}