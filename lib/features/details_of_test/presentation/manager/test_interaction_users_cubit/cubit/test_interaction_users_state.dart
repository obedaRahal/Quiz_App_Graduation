import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_interaction_users_entity.dart';

enum TestInteractionUsersStatus { initial, loading, success, failure }

enum TestInteractionUsersLoadMoreStatus { initial, loading, success, failure }

enum TestInteractionUserFollowStatus { initial, loading, success, failure }

enum TestInteractionUsersType { likes, bookmarks }

class TestInteractionUsersState {
  final TestInteractionUsersStatus status;
  final TestInteractionUsersLoadMoreStatus loadMoreStatus;
  final TestInteractionUserFollowStatus followStatus;

  final List<TestInteractionUserEntity> users;
  final TestInteractionUsersMetaEntity? meta;

  final String searchQuery;
  final int? activeFollowUserId;

  final String? errorTitle;
  final String? errorMessage;

  const TestInteractionUsersState({
    this.status = TestInteractionUsersStatus.initial,
    this.loadMoreStatus = TestInteractionUsersLoadMoreStatus.initial,
    this.followStatus = TestInteractionUserFollowStatus.initial,
    this.users = const [],
    this.meta,
    this.searchQuery = '',
    this.activeFollowUserId,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isInitialLoading => status == TestInteractionUsersStatus.loading;
  bool get isSuccess => status == TestInteractionUsersStatus.success;
  bool get isFailure => status == TestInteractionUsersStatus.failure;

  bool get isLoadMoreLoading =>
      loadMoreStatus == TestInteractionUsersLoadMoreStatus.loading;
  bool get isLoadMoreFailure =>
      loadMoreStatus == TestInteractionUsersLoadMoreStatus.failure;
  bool get isFollowLoading =>
      followStatus == TestInteractionUserFollowStatus.loading;

  bool get isFollowFailure =>
      followStatus == TestInteractionUserFollowStatus.failure;

  bool get hasMorePages => meta?.hasMorePages ?? false;

  String? get nextCursor => meta?.nextCursor;

  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  TestInteractionUsersState copyWith({
    TestInteractionUsersStatus? status,
    TestInteractionUsersLoadMoreStatus? loadMoreStatus,
    TestInteractionUserFollowStatus? followStatus,
    List<TestInteractionUserEntity>? users,
    TestInteractionUsersMetaEntity? meta,
    bool clearMeta = false,
    String? searchQuery,
    int? activeFollowUserId,
    bool clearActiveFollowUserId = false,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TestInteractionUsersState(
      status: status ?? this.status,
      loadMoreStatus: loadMoreStatus ?? this.loadMoreStatus,
      followStatus: followStatus ?? this.followStatus,
      users: users ?? this.users,
      meta: clearMeta ? null : meta ?? this.meta,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFollowUserId: clearActiveFollowUserId
          ? null
          : activeFollowUserId ?? this.activeFollowUserId,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
