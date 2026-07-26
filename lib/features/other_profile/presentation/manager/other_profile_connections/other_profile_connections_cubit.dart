import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quiz_app_grad/core/presentation/safe_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_type.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_connections_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_connections_params.dart';
import 'other_profile_connections_state.dart';

class OtherProfileConnectionsCubit
    extends SafeCubit<OtherProfileConnectionsState> {
  final GetOtherProfileConnectionsUseCase getOtherProfileConnectionsUseCase;
  final FollowCreatorUseCase followCreatorUseCase;
  final UnfollowCreatorUseCase unfollowCreatorUseCase;

  Timer? _searchDebounce;
  bool _isFetchingMore = false;
  bool _isDisposed = false;
  int _requestGeneration = 0;

  OtherProfileConnectionsCubit({
    required this.getOtherProfileConnectionsUseCase,
    required this.followCreatorUseCase,
    required this.unfollowCreatorUseCase,
  }) : super(const OtherProfileConnectionsState()) {
    debugPrint("============ OtherProfileConnectionsCubit INIT ============");
  }

  @override
  Future<void> close() {
    _isDisposed = true;
    _searchDebounce?.cancel();
    _requestGeneration++;
    return super.close();
  }

  Future<void> getInitialUsers({
    required int userId,
    required OtherProfileConnectionsType type,
  }) async {
    if (_isDisposed || isClosed) return;

    final requestGeneration = ++_requestGeneration;
    _isFetchingMore = false;

    debugPrint(
      "============ OtherProfileConnectionsCubit.getInitialUsers ============",
    );
    debugPrint("→ params: {userId: $userId, type: $type}");

    emit(
      state.copyWith(
        status: OtherProfileConnectionsStatus.loading,
        loadMoreStatus: OtherProfileConnectionsLoadMoreStatus.initial,
        followStatus: OtherProfileConnectionFollowStatus.initial,
        users: [],
        clearMeta: true,
        searchQuery: '',
        clearError: true,
        clearActiveFollowUserId: true,
      ),
    );

    final result = await getOtherProfileConnectionsUseCase(
      GetOtherProfileConnectionsParams(userId: userId, type: type),
    );

    if (_isDisposed || isClosed || requestGeneration != _requestGeneration) {
      return;
    }

    result.fold(
      (failure) {
        debugPrint("✗ getInitialUsers failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            status: OtherProfileConnectionsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ getInitialUsers success");
        debugPrint("→ users count: ${response.users.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            status: OtherProfileConnectionsStatus.success,
            users: response.users,
            meta: response.meta,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void onSearchChanged({
    required int userId,
    required String value,
    required OtherProfileConnectionsType type,
  }) {
    if (_isDisposed || isClosed) return;

    final query = value.trim();
    _requestGeneration++;
    _isFetchingMore = false;

    debugPrint(
      "============ OtherProfileConnectionsCubit.onSearchChanged ============",
    );
    debugPrint("→ query: $query");

    emit(state.copyWith(searchQuery: query, clearError: true));

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (_isDisposed || isClosed) return;

      if (query.isEmpty) {
        getInitialUsers(userId: userId, type: type);
        return;
      }

      searchUsers(userId: userId, type: type, query: query);
    });

    debugPrint("=================================================");
  }

  Future<void> searchUsers({
    required int userId,
    required OtherProfileConnectionsType type,
    required String query,
  }) async {
    if (_isDisposed || isClosed) return;

    final cleanQuery = query.trim();
    final requestGeneration = ++_requestGeneration;
    _isFetchingMore = false;

    debugPrint(
      "============ OtherProfileConnectionsCubit.searchUsers ============",
    );
    debugPrint("→ params: {userId: $userId, type: $type, query: $query}");

    emit(
      state.copyWith(
        status: OtherProfileConnectionsStatus.loading,
        loadMoreStatus: OtherProfileConnectionsLoadMoreStatus.initial,
        users: [],
        clearMeta: true,
        searchQuery: cleanQuery,
        clearError: true,
      ),
    );

    final result = await getOtherProfileConnectionsUseCase(
      GetOtherProfileConnectionsParams(
        userId: userId,
        type: type,
        search: cleanQuery,
      ),
    );

    if (_isDisposed ||
        isClosed ||
        requestGeneration != _requestGeneration ||
        state.searchQuery != cleanQuery) {
      return;
    }

    result.fold(
      (failure) {
        debugPrint("✗ searchUsers failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            status: OtherProfileConnectionsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ searchUsers success");
        debugPrint("→ users count: ${response.users.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            status: OtherProfileConnectionsStatus.success,
            users: response.users,
            meta: response.meta,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> loadMoreUsers({
    required int userId,
    required OtherProfileConnectionsType type,
  }) async {
    if (_isDisposed || isClosed) return;

    debugPrint(
      "============ OtherProfileConnectionsCubit.loadMoreUsers ============",
    );

    if (_isFetchingMore) {
      debugPrint("✗ already fetching more");
      debugPrint("=================================================");
      return;
    }

    if (state.isInitialLoading || state.isLoadMoreLoading) {
      debugPrint("✗ loading already active");
      debugPrint("=================================================");
      return;
    }

    if (!state.hasMorePages) {
      debugPrint("✗ no more pages");
      debugPrint("=================================================");
      return;
    }

    final cursor = state.nextCursor;
    final requestedQuery = state.searchQuery;
    final requestGeneration = _requestGeneration;

    if (cursor == null || cursor.trim().isEmpty) {
      debugPrint("✗ next cursor is empty");
      debugPrint("=================================================");
      return;
    }

    _isFetchingMore = true;

    emit(
      state.copyWith(
        loadMoreStatus: OtherProfileConnectionsLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    final result = await getOtherProfileConnectionsUseCase(
      GetOtherProfileConnectionsParams(
        userId: userId,
        type: type,
        search: requestedQuery,
        cursor: cursor,
      ),
    );

    if (_isDisposed ||
        isClosed ||
        requestGeneration != _requestGeneration ||
        state.searchQuery != requestedQuery) {
      if (requestGeneration == _requestGeneration) {
        _isFetchingMore = false;
      }
      return;
    }

    result.fold(
      (failure) {
        debugPrint("✗ loadMoreUsers failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            loadMoreStatus: OtherProfileConnectionsLoadMoreStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final mergedUsers = <int, OtherProfileConnectionUserEntity>{
          for (final user in state.users) user.userId: user,
          for (final user in response.users) user.userId: user,
        }.values.toList();

        debugPrint("✓ loadMoreUsers success");
        debugPrint("→ old users count: ${state.users.length}");
        debugPrint("→ new users count: ${response.users.length}");
        debugPrint("→ total users count: ${mergedUsers.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            loadMoreStatus: OtherProfileConnectionsLoadMoreStatus.success,
            status: OtherProfileConnectionsStatus.success,
            users: mergedUsers,
            meta: response.meta,
            clearError: true,
          ),
        );
      },
    );

    _isFetchingMore = false;

    debugPrint("=================================================");
  }

  Future<void> toggleFollowUser({required int userId}) async {
    if (_isDisposed || isClosed) return;

    debugPrint(
      "============ OtherProfileConnectionsCubit.toggleFollowUser ============",
    );
    debugPrint("→ params: {userId: $userId}");

    if (state.isFollowLoading) {
      debugPrint("✗ follow action already loading for this user");
      debugPrint("=================================================");
      return;
    }

    final index = state.users.indexWhere((user) => user.userId == userId);

    if (index == -1) {
      debugPrint("✗ user not found");
      debugPrint("=================================================");
      return;
    }

    final user = state.users[index];
    final currentIsFollowing = user.viewerIsFollowing;

    emit(
      state.copyWith(
        followStatus: OtherProfileConnectionFollowStatus.loading,
        activeFollowUserId: userId,
        clearError: true,
      ),
    );

    final result = currentIsFollowing
        ? await unfollowCreatorUseCase(
            TestFollowActionParams(creatorId: userId),
          )
        : await followCreatorUseCase(TestFollowActionParams(creatorId: userId));

    if (_isDisposed || isClosed) return;

    result.fold(
      (failure) {
        debugPrint("✗ toggleFollowUser failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            followStatus: OtherProfileConnectionFollowStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveFollowUserId: true,
          ),
        );
      },
      (_) {
        final currentIndex = state.users.indexWhere(
          (item) => item.userId == userId,
        );

        if (currentIndex == -1) {
          emit(
            state.copyWith(
              followStatus: OtherProfileConnectionFollowStatus.success,
              clearError: true,
              clearActiveFollowUserId: true,
            ),
          );
          return;
        }

        final updatedUsers = List<OtherProfileConnectionUserEntity>.from(
          state.users,
        );

        updatedUsers[currentIndex] = updatedUsers[currentIndex].copyWith(
          viewerIsFollowing: !currentIsFollowing,
        );

        debugPrint("✓ toggleFollowUser success");
        debugPrint("→ newIsFollowing: ${!currentIsFollowing}");

        emit(
          state.copyWith(
            followStatus: OtherProfileConnectionFollowStatus.success,
            users: updatedUsers,
            clearError: true,
            clearActiveFollowUserId: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetLoadMoreState() {
    if (_isDisposed || isClosed) return;

    emit(
      state.copyWith(
        loadMoreStatus: OtherProfileConnectionsLoadMoreStatus.initial,
        clearError: true,
      ),
    );
  }

  void resetFollowState() {
    if (_isDisposed || isClosed) return;

    emit(
      state.copyWith(
        followStatus: OtherProfileConnectionFollowStatus.initial,
        clearActiveFollowUserId: true,
        clearError: true,
      ),
    );
  }
}
