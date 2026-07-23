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

  final NotificationPresentationEntity? presentation;

  final NotificationActorEntity? actor;

  final String? screen;

  final String? action;

  final Map<String, dynamic> params;

  final String? notificationKey;

  const NotificationMetadataEntity({
    required this.type,

    required this.category,

    this.presentation,

    this.actor,

    required this.screen,

    required this.action,

    required this.params,

    this.notificationKey,
  });

  int? get testId => _notificationPositiveInt(params['test_id']);

  int? get buyerUserId => _notificationPositiveInt(params['buyer_user_id']);

  int? get actorUserId => _notificationPositiveInt(params['actor_user_id']);

  int? get materialId => _notificationPositiveInt(params['material_id']);

  int? get creatorUserId =>
      _notificationPositiveInt(params['creator_user_id']);

  int? get userId => _notificationPositiveInt(params['user_id']);

  int? get banId => _notificationPositiveInt(params['ban_id']);

  String? get deletionType => _notificationNullableString(
    params['deletion_type'],
  );

  String? get banType => _notificationNullableString(params['ban_type']);

  bool? get isPermanent => _notificationNullableBool(params['is_permanent']);

  @override
  String toString() {
    return 'NotificationMetadataEntity('
        'type: $type, '
        'category: $category, '
        'screen: $screen, '
        'params: $params, '
        'notificationKey: $notificationKey'
        ')';
  }
}

class NotificationPresentationEntity {
  final String? mode;
  final String? floorColor;
  final String? icon;

  const NotificationPresentationEntity({
    this.mode,
    this.floorColor,
    this.icon,
  });
}

class NotificationActorEntity {
  final int? id;
  final String? name;
  final String? avatarUrl;

  const NotificationActorEntity({this.id, this.name, this.avatarUrl});
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

int? _notificationPositiveInt(dynamic value) {
  final parsed = value is int
      ? value
      : int.tryParse(value?.toString().trim() ?? '');

  return parsed != null && parsed > 0 ? parsed : null;
}

String? _notificationNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  return text.isEmpty || text.toLowerCase() == 'null' ? null : text;
}

bool? _notificationNullableBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;

  switch (value?.toString().trim().toLowerCase()) {
    case 'true':
    case '1':
      return true;
    case 'false':
    case '0':
      return false;
    default:
      return null;
  }
}
