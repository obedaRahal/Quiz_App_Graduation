import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';

enum MyProfileBookmarksTab { tests, materials, folders }

extension MyProfileBookmarksTabX on MyProfileBookmarksTab {
  String get apiValue {
    switch (this) {
      case MyProfileBookmarksTab.tests:
        return 'tests';
      case MyProfileBookmarksTab.materials:
        return 'materials';
      case MyProfileBookmarksTab.folders:
        return 'folders';
    }
  }

  String get title {
    switch (this) {
      case MyProfileBookmarksTab.tests:
        return 'اختبارات';
      case MyProfileBookmarksTab.materials:
        return 'محتوى';
      case MyProfileBookmarksTab.folders:
        return 'قوائم';
    }
  }
}

class MyProfileBookmarksError {
  final String title;
  final String message;

  const MyProfileBookmarksError({required this.title, required this.message});
}

class MyProfileBookmarksState {
  final MyProfileBookmarksTab selectedTab;

  final bool isLoading;
  final bool isLoadingMore;

  final List<MyProfileBookmarkItemEntity> items;

  final String? nextCursor;
  final bool hasMorePages;

  final MyProfileBookmarksError? fetchError;
  final MyProfileBookmarksError? loadMoreError;
  final MyProfileBookmarksError? actionError;

  final int? activeBookmarkItemId;

  const MyProfileBookmarksState({
    this.selectedTab = MyProfileBookmarksTab.tests,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.nextCursor,
    this.hasMorePages = false,
    this.fetchError,
    this.loadMoreError,
    this.actionError,
    this.activeBookmarkItemId,
  });

  bool get hasFetchError => fetchError != null;

  bool isBookmarkItemLoading(int id) {
    return isLoadingMore == false && activeBookmarkItemId == id;
  }

  MyProfileBookmarksState copyWith({
    MyProfileBookmarksTab? selectedTab,
    bool? isLoading,
    bool? isLoadingMore,
    List<MyProfileBookmarkItemEntity>? items,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMorePages,
    MyProfileBookmarksError? fetchError,
    bool clearFetchError = false,
    MyProfileBookmarksError? loadMoreError,
    bool clearLoadMoreError = false,
    MyProfileBookmarksError? actionError,
    bool clearActionError = false,
    int? activeBookmarkItemId,
    bool clearActiveBookmarkItemId = false,
  }) {
    return MyProfileBookmarksState(
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      items: items ?? this.items,
      nextCursor: clearNextCursor ? null : nextCursor ?? this.nextCursor,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      fetchError: clearFetchError ? null : fetchError ?? this.fetchError,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
      actionError: clearActionError ? null : actionError ?? this.actionError,
      activeBookmarkItemId: clearActiveBookmarkItemId
          ? null
          : activeBookmarkItemId ?? this.activeBookmarkItemId,
    );
  }
}
