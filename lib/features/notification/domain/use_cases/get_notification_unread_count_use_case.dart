import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_unread_count_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/reposirories/notification_repository.dart';

class GetNotificationUnreadCountUseCase {
  final NotificationRepository repository;

  const GetNotificationUnreadCountUseCase(this.repository);

  Future<Either<Failure, NotificationUnreadCountEntity>> call() {
    debugPrint(
      '============ GetNotificationUnreadCountUseCase.call ============',
    );

    return repository.getUnreadNotificationsCount();
  }
}
