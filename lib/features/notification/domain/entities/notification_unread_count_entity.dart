class NotificationUnreadCountEntity {
  final bool success;
  final String title;
  final int unreadCount;
  final bool hasUnread;
  final int statusCode;

  const NotificationUnreadCountEntity({
    required this.success,
    required this.title,
    required this.unreadCount,
    required this.hasUnread,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'NotificationUnreadCountEntity('
        'success: $success, '
        'title: $title, '
        'unreadCount: $unreadCount, '
        'hasUnread: $hasUnread, '
        'statusCode: $statusCode'
        ')';
  }
}
