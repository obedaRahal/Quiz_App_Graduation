import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/get_notifications_use_case.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/mark_notifications_as_read_use_case.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/params/get_notifications_params.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/params/mark_notifications_as_read_params.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationsAsReadUseCase markNotificationsAsReadUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationsAsReadUseCase,
  }) : super(const NotificationState()) {
    debugPrint('============ NotificationCubit INIT ============');
  }

  Future<void> fetchInitial() async {
    if (state.isLoading) return;

    debugPrint('============ NotificationCubit.fetchInitial ============');

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        notifications: const [],
        hasMorePages: false,
        clearNextCursor: true,
        clearError: true,
      ),
    );

    final result = await getNotificationsUseCase(
      const GetNotificationsParams(),
    );

    await result.fold<Future<void>>(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) async {
        emit(
          state.copyWith(
            isLoading: false,
            notifications: response.notifications,
            nextCursor: response.pagination.nextCursor,
            hasMorePages: response.pagination.hasMorePages,
            clearError: true,
          ),
        );

        await _markUnreadNotificationsAsRead(response.notifications);
      },
    );

    debugPrint('=========================================================');
  }

  Future<void> fetchMoreIfNeeded() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMorePages) {
      return;
    }

    final cursor = state.nextCursor;

    if (cursor == null || cursor.trim().isEmpty) {
      return;
    }

    debugPrint('============ NotificationCubit.fetchMoreIfNeeded ============');
    debugPrint('→ cursor: $cursor');

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final result = await getNotificationsUseCase(
      GetNotificationsParams(cursor: cursor),
    );

    await result.fold<Future<void>>(
      (failure) async {
        emit(
          state.copyWith(
            isLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) async {
        final mergedNotifications = _mergeNotifications(
          current: state.notifications,
          incoming: response.notifications,
        );

        emit(
          state.copyWith(
            isLoadingMore: false,
            notifications: mergedNotifications,
            nextCursor: response.pagination.nextCursor,
            hasMorePages: response.pagination.hasMorePages,
            clearError: true,
          ),
        );

        await _markUnreadNotificationsAsRead(response.notifications);
      },
    );

    debugPrint(
      '==============================================================',
    );
  }

  Future<void> refresh() async {
    await fetchInitial();
  }

  // List<dynamic> _unused() => const [];

  List<NotificationEntity> _mergeNotifications({
    required List<NotificationEntity> current,
    required List<NotificationEntity> incoming,
  }) {
    final notificationsById = <String, NotificationEntity>{
      for (final notification in current) notification.id: notification,
    };

    for (final notification in incoming) {
      notificationsById[notification.id] = notification;
    }

    return notificationsById.values.toList();
  }

  Future<void> _markUnreadNotificationsAsRead(
    List<NotificationEntity> notifications,
  ) async {
    final unreadIds = notifications
        .where((notification) => !notification.isRead)
        .map((notification) => notification.id)
        .toList();

    if (unreadIds.isEmpty) {
      debugPrint(
        '============ NotificationCubit._markUnreadNotificationsAsRead ============',
      );
      debugPrint('→ no unread notifications');
      debugPrint(
        '===========================================================================',
      );

      return;
    }

    debugPrint(
      '============ NotificationCubit._markUnreadNotificationsAsRead ============',
    );
    debugPrint('→ unreadIds count: ${unreadIds.length}');
    debugPrint('→ unreadIds: $unreadIds');

    final result = await markNotificationsAsReadUseCase(
      MarkNotificationsAsReadParams(notificationIds: unreadIds),
    );

    result.fold(
      (failure) {
        debugPrint('✗ failed to mark notifications as read');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');
      },
      (response) {
        debugPrint('✓ notifications marked as read');
        debugPrint('→ updatedCount: ${response.updatedCount}');
      },
    );

    debugPrint(
      '===========================================================================',
    );
  }
}
