import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/search/domain/entities/search_user_entity.dart';
import 'package:quiz_app_grad/features/search/domain/use_cases/params/search_users_params.dart';
import 'package:quiz_app_grad/features/search/domain/use_cases/search_users_use_case.dart';
import 'package:quiz_app_grad/features/search/presentation/manager/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUsersUseCase searchUsersUseCase;
  final FollowCreatorUseCase followCreatorUseCase;
  final UnfollowCreatorUseCase unfollowCreatorUseCase;
  final TextEditingController searchController = TextEditingController();

  Timer? _debounce;
  int _searchRequestId = 0;
  int _followRequestId = 0;

  SearchCubit({
    required this.searchUsersUseCase,
    required this.followCreatorUseCase,
    required this.unfollowCreatorUseCase,
  }) : super(const SearchState()) {
    debugPrint('============ SearchCubit INIT ============');
  }

  Future<void> search({required String query}) async {
    final normalizedQuery = query.trim();
    final requestId = ++_searchRequestId;
    _followRequestId++;

    if (normalizedQuery.isEmpty) {
      clearSearch(invalidatePendingRequest: false);
      return;
    }

    debugPrint('============ SearchCubit.search ============');
    debugPrint('→ query: $normalizedQuery');

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        query: normalizedQuery,
        users: const [],
        hasMorePages: false,
        clearNextCursor: true,
        clearError: true,
        clearLoadMoreError: true,
        isFollowLoading: false,
        clearActiveFollowUserId: true,
        clearFollowError: true,
      ),
    );

    final result = await searchUsersUseCase(
      SearchUsersParams(query: normalizedQuery),
    );

    if (isClosed || requestId != _searchRequestId) {
      return;
    }

    result.fold(
      (failure) {
        debugPrint('✗ search failed');
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
        debugPrint('✓ search success');
        debugPrint('→ users count: ${response.users.length}');
        debugPrint('→ nextCursor: ${response.meta.nextCursor}');
        debugPrint('→ hasMorePages: ${response.meta.hasMorePages}');

        emit(
          state.copyWith(
            isLoading: false,
            users: response.users,
            nextCursor: response.meta.nextCursor,
            hasMorePages: response.meta.hasMorePages,
            clearError: true,
          ),
        );
      },
    );

    debugPrint('=============================================');
  }

  Future<void> fetchMoreIfNeeded() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMorePages) {
      return;
    }

    final query = state.query.trim();
    final cursor = state.nextCursor;
    final requestId = _searchRequestId;

    if (query.isEmpty) {
      return;
    }

    if (cursor == null || cursor.trim().isEmpty) {
      return;
    }

    debugPrint('============ SearchCubit.fetchMoreIfNeeded ============');
    debugPrint('→ query: $query');
    debugPrint('→ cursor: $cursor');

    emit(state.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final result = await searchUsersUseCase(
      SearchUsersParams(query: query, cursor: cursor),
    );

    if (isClosed || requestId != _searchRequestId) {
      return;
    }

    result.fold(
      (failure) {
        debugPrint('✗ fetch more failed');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');

        emit(
          state.copyWith(
            isLoadingMore: false,
            loadMoreErrorTitle: failure.title,
            loadMoreErrorMessage: failure.message,
          ),
        );
      },
      (response) {
        final mergedUsers = _mergeUsers(
          current: state.users,
          incoming: response.users,
        );

        debugPrint('✓ fetch more success');
        debugPrint('→ incoming count: ${response.users.length}');
        debugPrint('→ total count: ${mergedUsers.length}');
        debugPrint('→ nextCursor: ${response.meta.nextCursor}');
        debugPrint('→ hasMorePages: ${response.meta.hasMorePages}');

        emit(
          state.copyWith(
            isLoadingMore: false,
            users: mergedUsers,
            nextCursor: response.meta.nextCursor,
            hasMorePages: response.meta.hasMorePages,
            clearLoadMoreError: true,
          ),
        );
      },
    );

    debugPrint('========================================================');
  }

  Future<void> refresh() async {
    final query = state.query.trim();

    if (query.isEmpty) {
      return;
    }

    await search(query: query);
  }

  void updateQuery(String query) {
    final normalizedQuery = query.trim();
    _searchRequestId++;
    _followRequestId++;

    debugPrint('============ SearchCubit.updateQuery ============');
    debugPrint('→ query: $normalizedQuery');
    debugPrint('=================================================');

    if (normalizedQuery.isEmpty) {
      clearSearch(invalidatePendingRequest: false);
      return;
    }

    emit(
      state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        query: normalizedQuery,
        users: const [],
        hasMorePages: false,
        clearNextCursor: true,
        clearError: true,
        clearLoadMoreError: true,
        isFollowLoading: false,
        clearActiveFollowUserId: true,
        clearFollowError: true,
      ),
    );
  }

  void clearSearch({bool invalidatePendingRequest = true}) {
    debugPrint('============ SearchCubit.clearSearch ============');

    if (invalidatePendingRequest) {
      _searchRequestId++;
      _followRequestId++;
    }

    emit(const SearchState());

    debugPrint('=================================================');
  }

  List<SearchUserEntity> _mergeUsers({
    required List<SearchUserEntity> current,
    required List<SearchUserEntity> incoming,
  }) {
    final usersById = <int, SearchUserEntity>{
      for (final user in current) user.id: user,
    };

    for (final user in incoming) {
      usersById[user.id] = user;
    }

    return usersById.values.toList();
  }

  void onQueryChanged(String value) {
    _debounce?.cancel();

    updateQuery(value);

    if (value.trim().isEmpty) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(query: value);
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    searchController.dispose();

    return super.close();
  }

  Future<void> selectHistoryQuery(String query) async {
    _debounce?.cancel();
    searchController.text = query;

    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );

    await search(query: query);
  }

  Future<void> toggleFollowUser({required int userId}) async {
    if (state.isFollowLoading) {
      return;
    }

    final index = state.users.indexWhere((user) => user.id == userId);

    if (index == -1) {
      return;
    }

    final user = state.users[index];
    final currentIsFollowing = user.viewerIsFollowing;
    final requestId = ++_followRequestId;

    emit(
      state.copyWith(
        isFollowLoading: true,
        activeFollowUserId: userId,
        clearFollowError: true,
      ),
    );

    final result = currentIsFollowing
        ? await unfollowCreatorUseCase(
            TestFollowActionParams(creatorId: userId),
          )
        : await followCreatorUseCase(TestFollowActionParams(creatorId: userId));

    if (isClosed || requestId != _followRequestId) {
      return;
    }

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isFollowLoading: false,
            clearActiveFollowUserId: true,
            followErrorTitle: failure.title,
            followErrorMessage: failure.message,
          ),
        );
      },
      (_) {
        final currentIndex = state.users.indexWhere(
          (currentUser) => currentUser.id == userId,
        );

        if (currentIndex == -1) {
          emit(
            state.copyWith(
              isFollowLoading: false,
              clearActiveFollowUserId: true,
              clearFollowError: true,
            ),
          );
          return;
        }

        final updatedUsers = List<SearchUserEntity>.from(state.users);
        updatedUsers[currentIndex] = updatedUsers[currentIndex].copyWith(
          viewerIsFollowing: !currentIsFollowing,
        );

        emit(
          state.copyWith(
            users: updatedUsers,
            isFollowLoading: false,
            clearActiveFollowUserId: true,
            clearFollowError: true,
          ),
        );
      },
    );
  }

  void clearFollowError() {
    if (!state.hasFollowError) {
      return;
    }

    emit(state.copyWith(clearFollowError: true));
  }
}
