import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_entity.dart';

enum OtherProfileConnectionsStatus { initial, loading, success, failure }

enum OtherProfileConnectionsLoadMoreStatus { initial, loading, success, failure }

enum OtherProfileConnectionFollowStatus { initial, loading, success, failure }

class OtherProfileConnectionsState {
  final OtherProfileConnectionsStatus status;
  final OtherProfileConnectionsLoadMoreStatus loadMoreStatus;
  final OtherProfileConnectionFollowStatus followStatus;

  final List<OtherProfileConnectionUserEntity> users;
  final OtherProfileConnectionsMetaEntity? meta;

  final String searchQuery;
  final int? activeFollowUserId;

  final String? errorTitle;
  final String? errorMessage;

  const OtherProfileConnectionsState({
    this.status = OtherProfileConnectionsStatus.initial,
    this.loadMoreStatus = OtherProfileConnectionsLoadMoreStatus.initial,
    this.followStatus = OtherProfileConnectionFollowStatus.initial,
    this.users = const [],
    this.meta,
    this.searchQuery = '',
    this.activeFollowUserId,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isInitialLoading => status == OtherProfileConnectionsStatus.loading;
  bool get isSuccess => status == OtherProfileConnectionsStatus.success;
  bool get isFailure => status == OtherProfileConnectionsStatus.failure;

  bool get isLoadMoreLoading =>
      loadMoreStatus == OtherProfileConnectionsLoadMoreStatus.loading;

  bool get isLoadMoreFailure =>
      loadMoreStatus == OtherProfileConnectionsLoadMoreStatus.failure;

  bool get isFollowLoading =>
      followStatus == OtherProfileConnectionFollowStatus.loading;

  bool get isFollowFailure =>
      followStatus == OtherProfileConnectionFollowStatus.failure;

  bool get hasMorePages => meta?.hasMorePages ?? false;

  String? get nextCursor => meta?.nextCursor;

  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  OtherProfileConnectionsState copyWith({
    OtherProfileConnectionsStatus? status,
    OtherProfileConnectionsLoadMoreStatus? loadMoreStatus,
    OtherProfileConnectionFollowStatus? followStatus,
    List<OtherProfileConnectionUserEntity>? users,
    OtherProfileConnectionsMetaEntity? meta,
    bool clearMeta = false,
    String? searchQuery,
    int? activeFollowUserId,
    bool clearActiveFollowUserId = false,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OtherProfileConnectionsState(
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