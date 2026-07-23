import 'package:quiz_app_grad/features/search/domain/entities/search_history_entity.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';

class SearchState {
  final bool isLoading;
  final bool isLoadingMore;

  final String query;

  final List<SearchUserEntity> users;

  final String? nextCursor;
  final bool hasMorePages;

  final String? errorTitle;
  final String? errorMessage;

  final String? loadMoreErrorTitle;
  final String? loadMoreErrorMessage;

  final bool isFollowLoading;
  final int? activeFollowUserId;
  final String? followErrorTitle;
  final String? followErrorMessage;

  final bool isHistoryLoading;
  final List<SearchHistoryEntity> histories;

  final int? deletingHistoryId;
  final bool isClearingHistory;

  final String? historyErrorTitle;
  final String? historyErrorMessage;

  final String? historyActionErrorTitle;
  final String? historyActionErrorMessage;

  const SearchState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.query = '',
    this.users = const [],
    this.nextCursor,
    this.hasMorePages = false,
    this.errorTitle,
    this.errorMessage,
    this.loadMoreErrorTitle,
    this.loadMoreErrorMessage,
    this.isFollowLoading = false,
    this.activeFollowUserId,
    this.followErrorTitle,
    this.followErrorMessage,

    this.isHistoryLoading = false,
    this.histories = const [],
    this.deletingHistoryId,
    this.isClearingHistory = false,
    this.historyErrorTitle,
    this.historyErrorMessage,
    this.historyActionErrorTitle,
    this.historyActionErrorMessage,
  });

  bool get isSearching {
    return query.trim().isNotEmpty;
  }

  bool get hasResults {
    return users.isNotEmpty;
  }

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  bool get hasLoadMoreError {
    return loadMoreErrorMessage != null &&
        loadMoreErrorMessage!.trim().isNotEmpty;
  }

  bool get hasFollowError {
    return followErrorMessage != null && followErrorMessage!.trim().isNotEmpty;
  }

  bool get isInitialState {
    return query.trim().isEmpty && users.isEmpty && !isLoading && !hasError;
  }

  bool get hasHistoryError {
    return historyErrorMessage != null &&
        historyErrorMessage!.trim().isNotEmpty;
  }

  bool get hasHistoryActionError {
    return historyActionErrorMessage != null &&
        historyActionErrorMessage!.trim().isNotEmpty;
  }

  bool get hasHistories {
    return histories.isNotEmpty;
  }

  SearchState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? query,
    List<SearchUserEntity>? users,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMorePages,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
    String? loadMoreErrorTitle,
    String? loadMoreErrorMessage,
    bool clearLoadMoreError = false,
    bool? isFollowLoading,
    int? activeFollowUserId,
    bool clearActiveFollowUserId = false,
    String? followErrorTitle,
    String? followErrorMessage,
    bool clearFollowError = false,

    bool? isHistoryLoading,
    List<SearchHistoryEntity>? histories,

    int? deletingHistoryId,
    bool clearDeletingHistoryId = false,

    bool? isClearingHistory,

    String? historyErrorTitle,
    String? historyErrorMessage,
    bool clearHistoryError = false,

    String? historyActionErrorTitle,
    String? historyActionErrorMessage,
    bool clearHistoryActionError = false,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      query: query ?? this.query,
      users: users ?? this.users,
      nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      loadMoreErrorTitle: clearLoadMoreError
          ? null
          : loadMoreErrorTitle ?? this.loadMoreErrorTitle,
      loadMoreErrorMessage: clearLoadMoreError
          ? null
          : loadMoreErrorMessage ?? this.loadMoreErrorMessage,
      isFollowLoading: isFollowLoading ?? this.isFollowLoading,
      activeFollowUserId: clearActiveFollowUserId
          ? null
          : activeFollowUserId ?? this.activeFollowUserId,
      followErrorTitle: clearFollowError
          ? null
          : followErrorTitle ?? this.followErrorTitle,
      followErrorMessage: clearFollowError
          ? null
          : followErrorMessage ?? this.followErrorMessage,

      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      histories: histories ?? this.histories,
      deletingHistoryId: clearDeletingHistoryId
          ? null
          : deletingHistoryId ?? this.deletingHistoryId,
      isClearingHistory: isClearingHistory ?? this.isClearingHistory,
      historyErrorTitle: clearHistoryError
          ? null
          : historyErrorTitle ?? this.historyErrorTitle,
      historyErrorMessage: clearHistoryError
          ? null
          : historyErrorMessage ?? this.historyErrorMessage,
      historyActionErrorTitle: clearHistoryActionError
          ? null
          : historyActionErrorTitle ?? this.historyActionErrorTitle,
      historyActionErrorMessage: clearHistoryActionError
          ? null
          : historyActionErrorMessage ?? this.historyActionErrorMessage,
    );
  }
}
