class MarkNotificationsAsReadResponseEntity {
  final bool success;
  final String title;
  final int updatedCount;
  final int statusCode;

  const MarkNotificationsAsReadResponseEntity({
    required this.success,
    required this.title,
    required this.updatedCount,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'MarkNotificationsAsReadResponseEntity('
        'success: $success, '
        'title: $title, '
        'updatedCount: $updatedCount, '
        'statusCode: $statusCode'
        ')';
  }
}
