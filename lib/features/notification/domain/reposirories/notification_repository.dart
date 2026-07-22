import 'package:dartz/dartz.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/mark_notifications_as_read_response_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_unread_count_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({
    String? cursor,
  });

  Future<Either<Failure, MarkNotificationsAsReadResponseEntity>>
  markNotificationsAsRead({required List<String> notificationIds});

  Future<Either<Failure, NotificationUnreadCountEntity>>
  getUnreadNotificationsCount();
}
