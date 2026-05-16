import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/entities/test_interaction_users_entity.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/get_test_interaction_users_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/get_test_interaction_users_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'test_interaction_users_state.dart';

class TestInteractionUsersCubit extends Cubit<TestInteractionUsersState> {
  final GetTestInteractionUsersUseCase getTestInteractionUsersUseCase;
  final FollowCreatorUseCase followCreatorUseCase;
  final UnfollowCreatorUseCase unfollowCreatorUseCase;

  Timer? _searchDebounce;
  bool _isFetchingMore = false;

  TestInteractionUsersCubit({
    required this.getTestInteractionUsersUseCase,
    required this.followCreatorUseCase,
    required this.unfollowCreatorUseCase,
  }) : super(const TestInteractionUsersState()) {
    debugPrint("============ TestInteractionUsersCubit INIT ============");
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> getInitialUsers({
    required int testId,
    required TestInteractionUsersType type,
  }) async {
    debugPrint(
      "============ TestInteractionUsersCubit.getInitialUsers ============",
    );
    debugPrint("→ params: {testId: $testId} , type: $type} ");

    emit(
      state.copyWith(
        status: TestInteractionUsersStatus.loading,
        loadMoreStatus: TestInteractionUsersLoadMoreStatus.initial,
        followStatus: TestInteractionUserFollowStatus.initial,
        users: [],
        clearMeta: true,
        searchQuery: '',
        clearError: true,
        clearActiveFollowUserId: true,
      ),
    );

    final result = await getTestInteractionUsersUseCase(
      GetTestInteractionUsersParams(testId: testId, type: type),
    );

    result.fold(
      (failure) {
        debugPrint("✗ getInitialUsers failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            status: TestInteractionUsersStatus.failure,
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
            status: TestInteractionUsersStatus.success,
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
    required int testId,
    required String value,
    required TestInteractionUsersType type,
  }) {
    final query = value.trim();

    debugPrint(
      "============ TestInteractionUsersCubit.onSearchChanged ============",
    );
    debugPrint("→ query: $query");

    emit(state.copyWith(searchQuery: query, clearError: true));

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (query.isEmpty) {
        getInitialUsers(testId: testId, type: type);
        return;
      }

      searchUsers(testId: testId, type: type, query: query);
    });

    debugPrint("=================================================");
  }

  Future<void> searchUsers({
    required int testId,
    required TestInteractionUsersType type,
    required String query,
  }) async {
    debugPrint(
      "============ TestInteractionUsersCubit.searchUsers ============",
    );
    debugPrint("→ params: {testId: $testId ,type: $type, query: $query}");

    emit(
      state.copyWith(
        status: TestInteractionUsersStatus.loading,
        loadMoreStatus: TestInteractionUsersLoadMoreStatus.initial,
        users: [],
        clearMeta: true,
        searchQuery: query,
        clearError: true,
      ),
    );

    final result = await getTestInteractionUsersUseCase(
      GetTestInteractionUsersParams(testId: testId, type: type, search: query),
    );

    result.fold(
      (failure) {
        debugPrint("✗ searchUsers failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            status: TestInteractionUsersStatus.failure,
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
            status: TestInteractionUsersStatus.success,
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
    required int testId,
    required TestInteractionUsersType type,
  }) async {
    debugPrint(
      "============ TestInteractionUsersCubit.loadMoreUsers ============",
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

    if (cursor == null || cursor.trim().isEmpty) {
      debugPrint("✗ next cursor is empty");
      debugPrint("=================================================");
      return;
    }

    _isFetchingMore = true;

    emit(
      state.copyWith(
        loadMoreStatus: TestInteractionUsersLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    final result = await getTestInteractionUsersUseCase(
      GetTestInteractionUsersParams(
        testId: testId,
        type: type,
        search: state.searchQuery,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ loadMoreUsers failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            loadMoreStatus: TestInteractionUsersLoadMoreStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final mergedUsers = [...state.users, ...response.users];

        debugPrint("✓ loadMoreUsers success");
        debugPrint("→ old users count: ${state.users.length}");
        debugPrint("→ new users count: ${response.users.length}");
        debugPrint("→ total users count: ${mergedUsers.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            loadMoreStatus: TestInteractionUsersLoadMoreStatus.success,
            status: TestInteractionUsersStatus.success,
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
    debugPrint(
      "============ TestInteractionUsersCubit.toggleFollowUser ============",
    );
    debugPrint("→ params: {userId: $userId}");

    if (state.isFollowLoading && state.activeFollowUserId == userId) {
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
        followStatus: TestInteractionUserFollowStatus.loading,
        activeFollowUserId: userId,
        clearError: true,
      ),
    );

    final result = currentIsFollowing
        ? await unfollowCreatorUseCase(
            TestFollowActionParams(creatorId: userId),
          )
        : await followCreatorUseCase(TestFollowActionParams(creatorId: userId));

    result.fold(
      (failure) {
        debugPrint("✗ toggleFollowUser failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            followStatus: TestInteractionUserFollowStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveFollowUserId: true,
          ),
        );
      },
      (_) {
        final updatedUsers = List<TestInteractionUserEntity>.from(state.users);

        updatedUsers[index] = user.copyWith(
          viewerIsFollowing: !currentIsFollowing,
        );

        debugPrint("✓ toggleFollowUser success");
        debugPrint("→ newIsFollowing: ${!currentIsFollowing}");

        emit(
          state.copyWith(
            followStatus: TestInteractionUserFollowStatus.success,
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
    emit(
      state.copyWith(
        loadMoreStatus: TestInteractionUsersLoadMoreStatus.initial,
        clearError: true,
      ),
    );
  }

  void resetFollowState() {
    emit(
      state.copyWith(
        followStatus: TestInteractionUserFollowStatus.initial,
        clearActiveFollowUserId: true,
        clearError: true,
      ),
    );
  }
}
