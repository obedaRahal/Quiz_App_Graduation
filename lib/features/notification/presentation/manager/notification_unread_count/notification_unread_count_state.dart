class NotificationUnreadCountState {
  final bool isLoading;
  final int unreadCount;
  final bool hasUnread;
  final String? errorTitle;
  final String? errorMessage;

  const NotificationUnreadCountState({
    this.isLoading = false,
    this.unreadCount = 0,
    this.hasUnread = false,
    this.errorTitle,
    this.errorMessage,
  });

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  NotificationUnreadCountState copyWith({
    bool? isLoading,
    int? unreadCount,
    bool? hasUnread,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationUnreadCountState(
      isLoading: isLoading ?? this.isLoading,
      unreadCount: unreadCount ?? this.unreadCount,
      hasUnread: hasUnread ?? this.hasUnread,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
