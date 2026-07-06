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

class MyProfileBookmarksState {
  final MyProfileBookmarksTab selectedTab;

  final bool isLoading;
  final bool isLoadingMore;

  final List<MyProfileBookmarkItemEntity> items;

  final String? nextCursor;
  final bool hasMorePages;

  final String? errorTitle;
  final String? errorMessage;

  final int? activeBookmarkItemId;

  const MyProfileBookmarksState({
    this.selectedTab = MyProfileBookmarksTab.tests,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.items = const [],
    this.nextCursor,
    this.hasMorePages = false,
    this.errorTitle,
    this.errorMessage,
    this.activeBookmarkItemId,
  });

  bool get hasError => errorMessage != null && errorMessage!.trim().isNotEmpty;

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
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
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
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      activeBookmarkItemId: clearActiveBookmarkItemId
          ? null
          : activeBookmarkItemId ?? this.activeBookmarkItemId,
    );
  }
}
