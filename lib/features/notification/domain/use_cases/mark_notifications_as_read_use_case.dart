import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/mark_notifications_as_read_response_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/reposirories/notification_repository.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/params/mark_notifications_as_read_params.dart';

class MarkNotificationsAsReadUseCase {
  final NotificationRepository repository;

  const MarkNotificationsAsReadUseCase(this.repository);

  Future<Either<Failure, MarkNotificationsAsReadResponseEntity>> call(
    MarkNotificationsAsReadParams params,
  ) {
    debugPrint('============ MarkNotificationsAsReadUseCase.call ============');
    debugPrint('→ notificationIds count: ${params.notificationIds.length}');
    debugPrint('→ notificationIds: ${params.notificationIds}');
    debugPrint('=============================================================');

    return repository.markNotificationsAsRead(
      notificationIds: params.notificationIds,
    );
  }
}
