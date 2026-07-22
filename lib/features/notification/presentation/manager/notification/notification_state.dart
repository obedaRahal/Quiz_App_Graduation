import 'package:quiz_app_grad/features/notification/domain/entities/notification_entity.dart';

class NotificationState {
  final bool isLoading;
  final bool isLoadingMore;

  final List<NotificationEntity> notifications;

  final String? nextCursor;
  final bool hasMorePages;

  final String? errorTitle;
  final String? errorMessage;

  const NotificationState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.notifications = const [],
    this.nextCursor,
    this.hasMorePages = false,
    this.errorTitle,
    this.errorMessage,
  });

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  NotificationState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<NotificationEntity>? notifications,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMorePages,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      notifications: notifications ?? this.notifications,
      nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
