import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/mark_notifications_as_read_response_entity.dart';

class MarkNotificationsAsReadResponseModel
    extends MarkNotificationsAsReadResponseEntity {
  const MarkNotificationsAsReadResponseModel({
    required super.success,
    required super.title,
    required super.updatedCount,
    required super.statusCode,
  });

  factory MarkNotificationsAsReadResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    debugPrint(
      '============ MarkNotificationsAsReadResponseModel.fromJson ============',
    );

    final data =
        (json['data'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};

    final model = MarkNotificationsAsReadResponseModel(
      success: json['success'] == true,
      title: json['title']?.toString() ?? '',
      updatedCount: _asInt(data['updated_count']),
      statusCode: _asInt(json['status_code']),
    );

    debugPrint('√ mark notifications response parsed');
    debugPrint('→ updatedCount: ${model.updatedCount}');
    debugPrint('→ statusCode: ${model.statusCode}');
    debugPrint(
      '=======================================================================',
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
