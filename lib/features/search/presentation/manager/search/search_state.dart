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
    );
  }
}
