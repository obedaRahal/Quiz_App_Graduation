import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/reposirories/notification_repository.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/params/get_notifications_params.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  const GetNotificationsUseCase(this.repository);

  Future<Either<Failure, NotificationsResponseEntity>> call(
    GetNotificationsParams params,
  ) {
    debugPrint('============ GetNotificationsUseCase.call ============');
    debugPrint('→ cursor: ${params.cursor}');
    debugPrint('======================================================');

    return repository.getNotifications(cursor: params.cursor);
  }
}
