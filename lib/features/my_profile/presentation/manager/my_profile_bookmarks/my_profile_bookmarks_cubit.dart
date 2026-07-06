import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unbookmark_test_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_bookmarks_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_bookmarks_params.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_state.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/content_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/folder_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/remove_content_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/remove_folder_bookmark_use_case.dart';

class MyProfileBookmarksCubit extends Cubit<MyProfileBookmarksState> {
  final FetchMyProfileBookmarksUseCase fetchMyProfileBookmarksUseCase;
  final UnbookmarkTestUseCase unbookmarkTestUseCase;
  final RemoveContentBookmarkUseCase removeContentBookmarkUseCase;
  final RemoveFolderBookmarkUseCase removeFolderBookmarkUseCase;

  MyProfileBookmarksCubit({
    required this.fetchMyProfileBookmarksUseCase,
    required this.unbookmarkTestUseCase,
    required this.removeContentBookmarkUseCase,
    required this.removeFolderBookmarkUseCase,
  }) : super(const MyProfileBookmarksState()) {
    debugPrint("============ MyProfileBookmarksCubit INIT ============");
  }

  Future<void> fetchInitial() async {
    debugPrint(
      "============ MyProfileBookmarksCubit.fetchInitial ============",
    );
    debugPrint("→ tab: ${state.selectedTab.apiValue}");

    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        items: const [],
        hasMorePages: false,
        clearNextCursor: true,
        clearError: true,
      ),
    );

    final result = await fetchMyProfileBookmarksUseCase(
      FetchMyProfileBookmarksParams(tab: state.selectedTab.apiValue),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            isLoading: false,
            items: response.data.items,
            nextCursor: response.data.meta.nextCursor,
            hasMorePages: response.data.meta.hasMorePages,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> changeTab(MyProfileBookmarksTab tab) async {
    if (state.selectedTab == tab) return;

    debugPrint("============ MyProfileBookmarksCubit.changeTab ============");
    debugPrint("→ from: ${state.selectedTab.apiValue}");
    debugPrint("→ to: ${tab.apiValue}");

    emit(
      state.copyWith(
        selectedTab: tab,
        items: const [],
        isLoading: true,
        isLoadingMore: false,
        hasMorePages: false,
        clearNextCursor: true,
        clearError: true,
      ),
    );

    await fetchInitial();
  }

  Future<void> fetchMoreIfNeeded() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMorePages) return;

    final cursor = state.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) return;

    debugPrint(
      "============ MyProfileBookmarksCubit.fetchMoreIfNeeded ============",
    );
    debugPrint("→ tab: ${state.selectedTab.apiValue}");
    debugPrint("→ cursor: $cursor");

    emit(state.copyWith(isLoadingMore: true, clearError: true));

    final result = await fetchMyProfileBookmarksUseCase(
      FetchMyProfileBookmarksParams(
        tab: state.selectedTab.apiValue,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            items: [...state.items, ...response.data.items],
            nextCursor: response.data.meta.nextCursor,
            hasMorePages: response.data.meta.hasMorePages,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> refresh() async {
    await fetchInitial();
  }

  Future<void> removeTestBookmark({required int testId}) async {
    if (state.activeBookmarkItemId == testId) return;

    emit(state.copyWith(activeBookmarkItemId: testId, clearError: true));

    final result = await unbookmarkTestUseCase(
      TestBookmarkActionParams(testId: testId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveBookmarkItemId: true,
          ),
        );
      },
      (_) {
        final updatedItems = state.items
            .where(
              (item) =>
                  !(item is MyProfileBookmarkTestEntity && item.id == testId),
            )
            .toList();

        emit(
          state.copyWith(
            items: updatedItems,
            clearActiveBookmarkItemId: true,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> removeMaterialBookmark({required int contentId}) async {
    if (state.activeBookmarkItemId == contentId) return;

    emit(state.copyWith(activeBookmarkItemId: contentId, clearError: true));

    final result = await removeContentBookmarkUseCase(
      ContentBookmarkActionParams(contentId: contentId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveBookmarkItemId: true,
          ),
        );
      },
      (_) {
        final updatedItems = state.items
            .where(
              (item) =>
                  !(item is MyProfileBookmarkMaterialEntity &&
                      item.id == contentId),
            )
            .toList();

        emit(
          state.copyWith(
            items: updatedItems,
            clearActiveBookmarkItemId: true,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> removeFolderBookmark({required int folderId}) async {
    if (state.activeBookmarkItemId == folderId) return;

    emit(state.copyWith(activeBookmarkItemId: folderId, clearError: true));

    final result = await removeFolderBookmarkUseCase(
      FolderBookmarkActionParams(folderId: folderId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveBookmarkItemId: true,
          ),
        );
      },
      (_) {
        final updatedItems = state.items
            .where(
              (item) =>
                  !(item is MyProfileBookmarkFolderEntity &&
                      item.id == folderId),
            )
            .toList();

        emit(
          state.copyWith(
            items: updatedItems,
            clearActiveBookmarkItemId: true,
            clearError: true,
          ),
        );
      },
    );
  }
}
