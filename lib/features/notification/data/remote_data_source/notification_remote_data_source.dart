import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/database/api/api_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/features/notification/data/models/mark_notifications_as_read_response_model.dart';
import 'package:quiz_app_grad/features/notification/data/models/notification_model.dart';
import 'package:quiz_app_grad/features/notification/data/models/notification_unread_count_model.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({String? cursor});

  Future<MarkNotificationsAsReadResponseModel> markNotificationsAsRead({
    required List<String> notificationIds,
  });

  Future<NotificationUnreadCountModel> getUnreadNotificationsCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiConsumer apiConsumer;

  const NotificationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<NotificationsResponseModel> getNotifications({String? cursor}) async {
    debugPrint(
      '============ NotificationRemoteDataSourceImpl.getNotifications ============',
    );

    final endpoint = EndPoints.notifications(cursor: cursor);

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: GET');
    debugPrint('→ cursor: $cursor');

    final response = await apiConsumer.get(endpoint);

    debugPrint('← response: $response');
    debugPrint(
      '============================================================================',
    );

    return NotificationsResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<MarkNotificationsAsReadResponseModel> markNotificationsAsRead({
    required List<String> notificationIds,
  }) async {
    debugPrint(
      '============ NotificationRemoteDataSourceImpl.markNotificationsAsRead ============',
    );

    final endpoint = EndPoints.markNotificationsAsRead();

    final body = <String, dynamic>{'notification_ids': notificationIds};

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: POST');
    debugPrint('→ body: $body');

    final response = await apiConsumer.post(endpoint, data: body);

    debugPrint('← response: $response');
    debugPrint(
      '==================================================================================',
    );

    return MarkNotificationsAsReadResponseModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }

  @override
  Future<NotificationUnreadCountModel> getUnreadNotificationsCount() async {
    debugPrint(
      '============ NotificationRemoteDataSourceImpl.getUnreadNotificationsCount ============',
    );

    final endpoint = EndPoints.notificationUnreadCount();

    debugPrint('→ endpoint: $endpoint');
    debugPrint('→ method: GET');

    final response = await apiConsumer.get(endpoint);

    debugPrint('← response: $response');
    debugPrint(
      '======================================================================================',
    );

    return NotificationUnreadCountModel.fromJson(
      (response as Map).cast<String, dynamic>(),
    );
  }
}
