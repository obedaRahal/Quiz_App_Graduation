import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_unread_count_entity.dart';

class NotificationUnreadCountModel extends NotificationUnreadCountEntity {
  const NotificationUnreadCountModel({
    required super.success,
    required super.title,
    required super.unreadCount,
    required super.hasUnread,
    required super.statusCode,
  });

  factory NotificationUnreadCountModel.fromJson(Map<String, dynamic> json) {
    debugPrint(
      '============ NotificationUnreadCountModel.fromJson ============',
    );

    final data =
        (json['data'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    final model = NotificationUnreadCountModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      unreadCount: _asInt(data['unread_count']),
      hasUnread: data['has_unread'] == true,
      statusCode: _asInt(json['status_code']),
    );

    debugPrint('√ unread count response parsed');
    debugPrint('→ unreadCount: ${model.unreadCount}');
    debugPrint('→ hasUnread: ${model.hasUnread}');
    debugPrint('→ statusCode: ${model.statusCode}');
    debugPrint(
      '================================================================',
    );

    return model;
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim()) ?? fallback;
  }

  return fallback;
}
