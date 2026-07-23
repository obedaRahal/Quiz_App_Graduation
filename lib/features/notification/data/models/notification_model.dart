import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';

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

      image: _resolveMediaUrl(json['image']),

      floorColor: json['floor_color']?.toString(),

      icon: _resolveMediaUrl(json['icon']),

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

    super.presentation,

    super.actor,

    required super.screen,

    required super.action,

    required super.params,

    super.notificationKey,
  });

  factory NotificationMetadataModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      debugPrint('⚠ metadata is not valid map');

      return const NotificationMetadataModel(
        type: null,

        category: null,

        presentation: null,

        actor: null,

        screen: null,

        action: null,

        params: {},

        notificationKey: null,
      );
    }

    final navigation = json['navigation'];
    final presentation = json['presentation'];
    final actor = json['actor'];

    final model = NotificationMetadataModel(
      type: json['type']?.toString(),

      category: json['category']?.toString(),

      presentation: presentation is Map
          ? NotificationPresentationModel.fromJson(
              Map<String, dynamic>.from(presentation),
            )
          : null,

      actor: actor is Map
          ? NotificationActorModel.fromJson(Map<String, dynamic>.from(actor))
          : null,

      screen: navigation is Map ? navigation['screen']?.toString() : null,

      action: navigation is Map ? navigation['action']?.toString() : null,

      params: json['params'] is Map
          ? Map<String, dynamic>.from(json['params'] as Map)
          : {},

      notificationKey: _asNullableString(json['notification_key']),
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

class NotificationPresentationModel extends NotificationPresentationEntity {
  const NotificationPresentationModel({
    super.mode,
    super.floorColor,
    super.icon,
  });

  factory NotificationPresentationModel.fromJson(Map<String, dynamic> json) {
    return NotificationPresentationModel(
      mode: _asNullableString(json['mode']),
      floorColor: _asNullableString(json['floor_color']),
      icon: _resolveMediaUrl(json['icon']),
    );
  }
}

class NotificationActorModel extends NotificationActorEntity {
  const NotificationActorModel({super.id, super.name, super.avatarUrl});

  factory NotificationActorModel.fromJson(Map<String, dynamic> json) {
    return NotificationActorModel(
      id: _asNullablePositiveInt(json['id']),
      name: _asNullableString(json['name']),
      avatarUrl: _resolveMediaUrl(json['avatar_url']),
    );
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

int? _asNullablePositiveInt(dynamic value) {
  final parsed = _asInt(value);
  return parsed > 0 ? parsed : null;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty || text.toLowerCase() == 'null') {
    return null;
  }

  return text;
}

String? _resolveMediaUrl(dynamic value) {
  final mediaUrl = _asNullableString(value);

  if (mediaUrl == null) {
    return null;
  }

  final uri = Uri.tryParse(mediaUrl);

  if (uri == null ||
      (uri.host.toLowerCase() != 'localhost' && uri.host != '127.0.0.1')) {
    return mediaUrl;
  }

  final apiUri = Uri.tryParse(EndPoints.baseUrl);

  if (apiUri == null || apiUri.host.isEmpty) {
    return mediaUrl;
  }

  return uri
      .replace(
        scheme: apiUri.scheme,
        host: apiUri.host,
        port: apiUri.hasPort ? apiUri.port : null,
      )
      .toString();
}
