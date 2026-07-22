class NotificationsResponseEntity {
  final bool success;

  final String title;

  final List<NotificationEntity> notifications;

  final NotificationPaginationEntity pagination;

  final int statusCode;

  const NotificationsResponseEntity({
    required this.success,

    required this.title,

    required this.notifications,

    required this.pagination,

    required this.statusCode,
  });

  @override
  String toString() {
    return 'NotificationsResponseEntity('
        'success: $success, '
        'title: $title, '
        'notificationsCount: ${notifications.length}, '
        'statusCode: $statusCode'
        ')';
  }
}

class NotificationEntity {
  final String id;

  final String mode;

  final String? image;

  final String? floorColor;

  final String? icon;

  final String title;

  final String body;

  final String sentAt;

  final bool isRead;

  final NotificationMetadataEntity metadata;

  const NotificationEntity({
    required this.id,
    required this.mode,
    required this.image,
    required this.floorColor,
    required this.icon,
    required this.title,
    required this.body,
    required this.sentAt,
    required this.isRead,
    required this.metadata,
  });

  @override
  String toString() {
    return 'NotificationEntity('
        'id: $id, '
        'mode: $mode, '
        'title: $title, '
        'isRead: $isRead'
        ')';
  }
}

class NotificationMetadataEntity {
  final String? type;

  final String? category;

  final String? screen;

  final String? action;

  final Map<String, dynamic> params;

  const NotificationMetadataEntity({
    required this.type,

    required this.category,

    required this.screen,

    required this.action,

    required this.params,
  });

  @override
  String toString() {
    return 'NotificationMetadataEntity('
        'type: $type, '
        'category: $category, '
        'screen: $screen, '
        'params: $params'
        ')';
  }
}

class NotificationPaginationEntity {
  final int perPage;
  final String? nextCursor;
  final String? prevCursor;
  final bool hasMorePages;

  const NotificationPaginationEntity({
    required this.perPage,
    this.nextCursor,
    this.prevCursor,
    required this.hasMorePages,
  });

  @override
  String toString() {
    return 'NotificationPaginationEntity('
        'perPage: $perPage, '
        'nextCursor: $nextCursor, '
        'prevCursor: $prevCursor, '
        'hasMorePages: $hasMorePages'
        ')';
  }
}
