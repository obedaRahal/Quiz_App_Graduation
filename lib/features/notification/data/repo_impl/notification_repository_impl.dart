import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/errors/exceptions.dart';
import 'package:quiz_app_grad/core/errors/failure.dart';
import 'package:quiz_app_grad/features/notification/data/remote_data_source/notification_remote_data_source.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/mark_notifications_as_read_response_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_unread_count_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/reposirories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  const NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NotificationsResponseEntity>> getNotifications({
    String? cursor,
  }) async {
    debugPrint(
      '============ NotificationRepositoryImpl.getNotifications ============',
    );
    debugPrint('→ cursor: $cursor');

    try {
      final response = await remoteDataSource.getNotifications(cursor: cursor);

      debugPrint('✓ getNotifications success');
      debugPrint('→ count: ${response.notifications.length}');
      debugPrint('→ nextCursor: ${response.pagination.nextCursor}');
      debugPrint('→ hasMorePages: ${response.pagination.hasMorePages}');
      debugPrint(
        '=====================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('✗ getNotifications ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '=====================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ getNotifications CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '=====================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ getNotifications Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '=====================================================================',
      );

      return Left(
        ServerFailure(title: 'حدث خطأ', message: 'تعذر جلب الإشعارات'),
      );
    }
  }

  @override
  Future<Either<Failure, MarkNotificationsAsReadResponseEntity>>
  markNotificationsAsRead({required List<String> notificationIds}) async {
    debugPrint(
      '============ NotificationRepositoryImpl.markNotificationsAsRead ============',
    );
    debugPrint('→ notificationIds count: ${notificationIds.length}');
    debugPrint('→ notificationIds: $notificationIds');

    try {
      final response = await remoteDataSource.markNotificationsAsRead(
        notificationIds: notificationIds,
      );

      debugPrint('✓ markNotificationsAsRead success');
      debugPrint('→ updatedCount: ${response.updatedCount}');
      debugPrint(
        '============================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('✗ markNotificationsAsRead ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');
      debugPrint(
        '============================================================================',
      );

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ markNotificationsAsRead CacheException');
      debugPrint('→ message: ${e.errorMessage}');
      debugPrint(
        '============================================================================',
      );

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ markNotificationsAsRead Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');
      debugPrint(
        '============================================================================',
      );

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر تعليم الإشعارات كمقروءة',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, NotificationUnreadCountEntity>>
  getUnreadNotificationsCount() async {
    debugPrint(
      '============ NotificationRepositoryImpl.getUnreadNotificationsCount ============',
    );

    try {
      final response = await remoteDataSource.getUnreadNotificationsCount();

      debugPrint('✓ getUnreadNotificationsCount success');
      debugPrint('→ unreadCount: ${response.unreadCount}');
      debugPrint('→ hasUnread: ${response.hasUnread}');
      debugPrint(
        '===============================================================================',
      );

      return Right(response);
    } on ServerException catch (e) {
      debugPrint('✗ getUnreadNotificationsCount ServerException');
      debugPrint('→ title: ${e.errorModel.errorTitle}');
      debugPrint('→ message: ${e.errorModel.errorMessage}');

      return Left(
        ServerFailure(
          title: e.errorModel.errorTitle,
          message: e.errorModel.errorMessage,
        ),
      );
    } on CacheException catch (e) {
      debugPrint('✗ getUnreadNotificationsCount CacheException');
      debugPrint('→ message: ${e.errorMessage}');

      return Left(CacheFailure(title: 'خطأ محلي', message: e.errorMessage));
    } catch (e, stackTrace) {
      debugPrint('✗ getUnreadNotificationsCount Unexpected error: $e');
      debugPrint('→ stackTrace: $stackTrace');

      return Left(
        ServerFailure(
          title: 'حدث خطأ',
          message: 'تعذر جلب عدد الإشعارات غير المقروءة',
        ),
      );
    }
  }
}
