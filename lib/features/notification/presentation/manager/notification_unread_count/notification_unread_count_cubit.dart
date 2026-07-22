import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/notification/domain/use_cases/get_notification_unread_count_use_case.dart';
import 'package:quiz_app_grad/features/notification/presentation/manager/notification_unread_count/notification_unread_count_state.dart';

class NotificationUnreadCountCubit
    extends Cubit<NotificationUnreadCountState> {
  final GetNotificationUnreadCountUseCase
      getNotificationUnreadCountUseCase;

  NotificationUnreadCountCubit({
    required this.getNotificationUnreadCountUseCase,
  }) : super(const NotificationUnreadCountState()) {
    debugPrint(
      '============ NotificationUnreadCountCubit INIT ============',
    );
  }

  Future<void> fetchUnreadCount() async {
    debugPrint(
      '============ NotificationUnreadCountCubit.fetchUnreadCount ============',
    );

    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
      ),
    );

    final result =
        await getNotificationUnreadCountUseCase();

    result.fold(
      (failure) {
        debugPrint('✗ fetchUnreadCount failed');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint('✓ fetchUnreadCount success');
        debugPrint(
          '→ unreadCount: ${response.unreadCount}',
        );
        debugPrint(
          '→ hasUnread: ${response.hasUnread}',
        );

        emit(
          state.copyWith(
            isLoading: false,
            unreadCount: response.unreadCount,
            hasUnread: response.hasUnread,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    await fetchUnreadCount();
  }
}