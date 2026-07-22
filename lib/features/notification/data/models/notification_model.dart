import 'package:flutter/foundation.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationsResponseModel extends NotificationsResponseEntity {
  const NotificationsResponseModel({
    required super.success,

    required super.title,

    required super.notifications,

    required super.pagination,

    required super.statusCode,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    debugPrint('============ NotificationsResponseModel.fromJson ============');

    final data = json['data'];

    final notificationsJson = data is Map && data['notifications'] is List
        ? data['notifications']
        : [];

    final model = NotificationsResponseModel(
      success: json['success'] == true,

      title: json['title']?.toString() ?? '',

      notifications: List<NotificationModel>.from(
        notificationsJson.map((item) {
          return NotificationModel.fromJson(Map<String, dynamic>.from(item));
        }),
      ),

      pagination: NotificationPaginationModel.fromJson(
        data is Map && data['meta'] is Map
            ? Map<String, dynamic>.from(data['meta'])
            : {},
      ),

      statusCode: int.tryParse(json['status_code']?.toString() ?? '') ?? 0,
    );

    debugPrint('✓ notifications response parsed');

    debugPrint('→ count: ${model.notifications.length}');

    debugPrint('→ statusCode: ${model.statusCode}');

    debugPrint('============================================================');

    return model;
  }
}

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.mode,
    required super.image,
    required super.floorColor,
    required super.icon,
    required super.title,
    required super.body,
    required super.sentAt,
    required super.isRead,
    required super.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    debugPrint('============ NotificationModel.fromJson ============');

    debugPrint('→ raw json: $json');

    final model = NotificationModel(
      id: json['id']?.toString() ?? '',

      mode: json['mode']?.toString() ?? '',

      image: json['image']?.toString(),

      floorColor: json['floor_color']?.toString(),

      icon: json['icon']?.toString(),

      title: json['title']?.toString() ?? '',

      body: json['body']?.toString() ?? '',

      sentAt: json['sent_at']?.toString() ?? '',

      isRead: json['is_read'] == true,

      metadata: NotificationMetadataModel.fromJson(json['metadata']),
    );

    debugPrint('✓ notification parsed');

    debugPrint('→ id: ${model.id}');
    debugPrint('→ title: ${model.title}');
    debugPrint('→ mode: ${model.mode}');
    debugPrint('→ isRead: ${model.isRead}');

    debugPrint('====================================================');

    return model;
  }
}

class NotificationMetadataModel extends NotificationMetadataEntity {
  const NotificationMetadataModel({
    required super.type,

    required super.category,

    required super.screen,

    required super.action,

    required super.params,
  });

  factory NotificationMetadataModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      debugPrint('⚠ metadata is not valid map');

      return const NotificationMetadataModel(
        type: null,

        category: null,

        screen: null,

        action: null,

        params: {},
      );
    }

    final navigation = json['navigation'];

    final model = NotificationMetadataModel(
      type: json['type']?.toString(),

      category: json['category']?.toString(),

      screen: navigation is Map ? navigation['screen']?.toString() : null,

      action: navigation is Map ? navigation['action']?.toString() : null,

      params: json['params'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['params'])
          : {},
    );

    debugPrint('============ NotificationMetadataModel.fromJson ============');

    debugPrint('→ type: ${model.type}');
    debugPrint('→ category: ${model.category}');
    debugPrint('→ screen: ${model.screen}');
    debugPrint('→ action: ${model.action}');
    debugPrint('→ params: ${model.params}');

    debugPrint('============================================================');

    return model;
  }
}

class NotificationPaginationModel extends NotificationPaginationEntity {
  const NotificationPaginationModel({
    required super.perPage,
    super.nextCursor,
    super.prevCursor,
    required super.hasMorePages,
  });

  factory NotificationPaginationModel.fromJson(Map<String, dynamic> json) {
    return NotificationPaginationModel(
      perPage: _asInt(json['per_page']),
      nextCursor: _asNullableString(json['next_cursor']),
      prevCursor: _asNullableString(
        json['prev_cursor'] ?? json['previous_cursor'],
      ),
      hasMorePages: json['has_more_pages'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;

  if (value is double) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim()) ?? fallback;
  }

  return fallback;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text.toLowerCase() == 'null') {
    return null;
  }

  return text;
}
