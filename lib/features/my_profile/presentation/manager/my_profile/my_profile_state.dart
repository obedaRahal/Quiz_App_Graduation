import 'package:quiz_app_grad/features/get_all_interests/domain/entities/all_interests_response_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folder_content_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/filter_my_profile_tests_params.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';

enum MyProfileTab { personalInfo, tests, content, folders }

enum FetchMyProfileStatus { initial, loading, success, failure }

enum UpdateMyProfileStatus { initial, loading, success, failure }

enum MyProfileLibraryTab { latest, public, private }

extension MyProfileLibraryTabX on MyProfileLibraryTab {
  String get apiValue {
    switch (this) {
      case MyProfileLibraryTab.latest:
        return 'latest';
      case MyProfileLibraryTab.public:
        return 'public';
      case MyProfileLibraryTab.private:
        return 'private';
    }
  }

  String get title {
    switch (this) {
      case MyProfileLibraryTab.latest:
        return 'الأحدث';
      case MyProfileLibraryTab.public:
        return 'عامة';
      case MyProfileLibraryTab.private:
        return 'خاصة';
    }
  }
}

enum MyProfileFoldersTabEnum { latest, public, private }

extension MyProfileFoldersTabX on MyProfileFoldersTabEnum {
  String get apiValue {
    switch (this) {
      case MyProfileFoldersTabEnum.latest:
        return 'latest';
      case MyProfileFoldersTabEnum.public:
        return 'public';
      case MyProfileFoldersTabEnum.private:
        return 'private';
    }
  }

  String get title {
    switch (this) {
      case MyProfileFoldersTabEnum.latest:
        return 'الأحدث';
      case MyProfileFoldersTabEnum.public:
        return 'عامة';
      case MyProfileFoldersTabEnum.private:
        return 'خاصة';
    }
  }
}

enum FetchMyProfileFolderContentStatus { initial, loading, success, failure }

enum DeleteMyProfileFolderStatus { initial, loading, success, failure }

enum MyProfileTestsStatus { initial, loading, success, failure }

enum MyProfileTestsLoadMoreStatus { initial, loading, success, failure }

enum MyProfileTestsSearchStatus { initial, loading, success, failure }

enum MyProfileTestsSearchLoadMoreStatus { initial, loading, success, failure }

enum MyProfileTestsFilterStatus { initial, loading, success, failure }

enum MyProfileTestsFilterLoadMoreStatus { initial, loading, success, failure }

enum MyProfileShareLinkStatus { initial, loading, success, failure }

class MyProfileState {
  final MyProfileTab selectedTab;

  final MyProfileEntity? profile;
  final MyProfileEntity? editableProfile;

  final FetchMyProfileStatus fetchStatus;
  final UpdateMyProfileStatus updateStatus;

  final String? errorTitle;
  final String? errorMessage;

  final MyProfileLibraryTab selectedLibraryTab;
  final FetchMyProfileStatus libraryStatus;
  final MyProfileLibraryEntity? libraryResponse;
  final String librarySearchText;
  final bool isLibraryLoadingMore;

  final MyProfileFoldersTabEnum selectedFoldersTab;
  final FetchMyProfileStatus foldersStatus;
  final MyProfileFoldersEntity? foldersResponse;
  final bool isFoldersLoadingMore;

  final FetchMyProfileFolderContentStatus folderContentStatus;
  final MyProfileFolderContentEntity? folderContentResponse;
  final int? activeFolderContentId;

  final DeleteMyProfileFolderStatus deleteFolderStatus;
  final int? activeDeletingFolderId;
  final String? folderActionMessage;

  final MyProfilePickerTestsTab selectedTestsTab;

  final MyProfileTestsStatus testsStatus;
  final MyProfileTestsLoadMoreStatus testsLoadMoreStatus;
  final MyProfilePickerTestsEntity? testsResponse;

  final String testsSearchQuery;
  final MyProfileTestsSearchStatus testsSearchStatus;
  final MyProfileTestsSearchLoadMoreStatus testsSearchLoadMoreStatus;
  final MyProfilePickerSearchTestsEntity? testsSearchResponse;
  final int testsSearchPage;
  final bool testsSearchHasMorePages;

  final bool isTestsFilterMode;
  final MyProfileTestsFilterStatus testsFilterStatus;
  final MyProfileTestsFilterLoadMoreStatus testsFilterLoadMoreStatus;
  final MyProfileFilteredTestsEntity? filteredTestsResponse;
  final FilterMyProfileTestsParams? activeTestsFilterParams;
  final List<InterestCategoryEntity> testsFilterInterestCategories;
  final bool isTestsFilterInterestsLoading;
  final String? testsFilterInterestsError;

  final MyProfileShareLinkStatus shareLinkStatus;
  final String? shareUrl;

  const MyProfileState({
    this.selectedTab = MyProfileTab.personalInfo,
    this.profile,
    this.editableProfile,
    this.fetchStatus = FetchMyProfileStatus.initial,
    this.updateStatus = UpdateMyProfileStatus.initial,
    this.errorTitle,
    this.errorMessage,

    this.selectedLibraryTab = MyProfileLibraryTab.latest,
    this.libraryStatus = FetchMyProfileStatus.initial,
    this.libraryResponse,
    this.librarySearchText = '',
    this.isLibraryLoadingMore = false,

    this.selectedFoldersTab = MyProfileFoldersTabEnum.latest,
    this.foldersStatus = FetchMyProfileStatus.initial,
    this.foldersResponse,
    this.isFoldersLoadingMore = false,

    this.folderContentStatus = FetchMyProfileFolderContentStatus.initial,
    this.folderContentResponse,
    this.activeFolderContentId,

    this.deleteFolderStatus = DeleteMyProfileFolderStatus.initial,
    this.activeDeletingFolderId,
    this.folderActionMessage,

    this.selectedTestsTab = MyProfilePickerTestsTab.public,

    this.testsStatus = MyProfileTestsStatus.initial,
    this.testsLoadMoreStatus = MyProfileTestsLoadMoreStatus.initial,
    this.testsResponse,

    this.testsSearchQuery = '',
    this.testsSearchStatus = MyProfileTestsSearchStatus.initial,
    this.testsSearchLoadMoreStatus = MyProfileTestsSearchLoadMoreStatus.initial,
    this.testsSearchResponse,
    this.testsSearchPage = 1,
    this.testsSearchHasMorePages = true,

    this.isTestsFilterMode = false,
    this.testsFilterStatus = MyProfileTestsFilterStatus.initial,
    this.testsFilterLoadMoreStatus = MyProfileTestsFilterLoadMoreStatus.initial,
    this.filteredTestsResponse,
    this.activeTestsFilterParams,
    this.testsFilterInterestCategories = const [],
    this.isTestsFilterInterestsLoading = false,
    this.testsFilterInterestsError,

    this.shareLinkStatus = MyProfileShareLinkStatus.initial,
    this.shareUrl,
  });

  bool get isFetchInitial => fetchStatus == FetchMyProfileStatus.initial;
  bool get isFetchLoading => fetchStatus == FetchMyProfileStatus.loading;
  bool get isFetchSuccess => fetchStatus == FetchMyProfileStatus.success;
  bool get isFetchFailure => fetchStatus == FetchMyProfileStatus.failure;

  bool get isUpdateLoading => updateStatus == UpdateMyProfileStatus.loading;
  bool get isUpdateSuccess => updateStatus == UpdateMyProfileStatus.success;
  bool get isUpdateFailure => updateStatus == UpdateMyProfileStatus.failure;

  bool get isLibraryLoading => libraryStatus == FetchMyProfileStatus.loading;
  bool get isLibraryFailure => libraryStatus == FetchMyProfileStatus.failure;

  bool get isFoldersLoading => foldersStatus == FetchMyProfileStatus.loading;
  bool get isFoldersFailure => foldersStatus == FetchMyProfileStatus.failure;
  bool get hasMoreFoldersPages => foldersResponse?.meta.hasMorePages ?? false;
  String? get nextFoldersCursor => foldersResponse?.meta.nextCursor;

  bool get isFolderContentLoading =>
      folderContentStatus == FetchMyProfileFolderContentStatus.loading;
  bool get isFolderContentSuccess =>
      folderContentStatus == FetchMyProfileFolderContentStatus.success;
  bool get isFolderContentFailure =>
      folderContentStatus == FetchMyProfileFolderContentStatus.failure;

  List<MyProfileLibraryItemEntity> get filteredLibraryItems {
    final items = libraryResponse?.data ?? [];
    final query = librarySearchText.trim().toLowerCase();

    if (query.isEmpty) return items;

    return items.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.interests.any((e) => e.toLowerCase().contains(query));
    }).toList();
  }

  bool get hasChanges {
    final original = profile;
    final edited = editableProfile;

    if (original == null || edited == null) return false;

    return original.name != edited.name ||
        original.phone != edited.phone ||
        original.governorate != edited.governorate ||
        original.gender != edited.gender ||
        original.birthDate != edited.birthDate ||
        original.avatarUrl != edited.avatarUrl ||
        original.coverUrl != edited.coverUrl;
  }

  bool get isDeleteFolderLoading =>
      deleteFolderStatus == DeleteMyProfileFolderStatus.loading;
  bool get isDeleteFolderSuccess =>
      deleteFolderStatus == DeleteMyProfileFolderStatus.success;
  bool get isDeleteFolderFailure =>
      deleteFolderStatus == DeleteMyProfileFolderStatus.failure;
  bool isDeletingFolder(int folderId) {
    return isDeleteFolderLoading && activeDeletingFolderId == folderId;
  }

  bool get isTestsLoading => testsStatus == MyProfileTestsStatus.loading;
  bool get isTestsFailure => testsStatus == MyProfileTestsStatus.failure;
  bool get isTestsSuccess => testsStatus == MyProfileTestsStatus.success;

  bool get isTestsLoadingMore =>
      testsLoadMoreStatus == MyProfileTestsLoadMoreStatus.loading;
  bool get isTestsLoadMoreFailure =>
      testsLoadMoreStatus == MyProfileTestsLoadMoreStatus.failure;
  bool get hasMoreTestsPages => testsResponse?.meta.hasMorePages ?? false;

  String? get nextTestsCursor => testsResponse?.meta.nextCursor;
  bool get hasTestsSearchQuery => testsSearchQuery.trim().isNotEmpty;

  bool get isTestsSearchLoading =>
      testsSearchStatus == MyProfileTestsSearchStatus.loading;
  bool get isTestsSearchFailure =>
      testsSearchStatus == MyProfileTestsSearchStatus.failure;
  bool get isTestsSearchLoadingMore =>
      testsSearchLoadMoreStatus == MyProfileTestsSearchLoadMoreStatus.loading;
  List<MyProfilePickerTestItemEntity> get visibleTests {
    if (hasTestsSearchQuery) {
      return testsSearchResponse?.data ?? [];
    }
    return testsResponse?.data ?? [];
  }

  bool get isVisibleTestsLoading {
    if (hasTestsSearchQuery) {
      return isTestsSearchLoading;
    }
    return isTestsLoading;
  }

  bool get isVisibleTestsLoadingMore {
    if (hasTestsSearchQuery) {
      return isTestsSearchLoadingMore;
    }
    return isTestsLoadingMore;
  }

  bool get isVisibleTestsFailure {
    if (hasTestsSearchQuery) {
      return isTestsSearchFailure;
    }
    return isTestsFailure;
  }

  bool get isTestsFilterLoading =>
      testsFilterStatus == MyProfileTestsFilterStatus.loading;
  bool get isTestsFilterSuccess =>
      testsFilterStatus == MyProfileTestsFilterStatus.success;
  bool get isTestsFilterFailure =>
      testsFilterStatus == MyProfileTestsFilterStatus.failure;
  bool get isTestsFilterLoadingMore =>
      testsFilterLoadMoreStatus == MyProfileTestsFilterLoadMoreStatus.loading;
  bool get hasMoreFilteredTestsPages =>
      filteredTestsResponse?.meta.hasMorePages ?? false;
  String? get nextFilteredTestsCursor => filteredTestsResponse?.meta.nextCursor;
  bool get hasActiveTestsFilter =>
      isTestsFilterMode && activeTestsFilterParams != null;

  bool get isShareLinkLoading =>
      shareLinkStatus == MyProfileShareLinkStatus.loading;
  bool get isShareLinkSuccess =>
      shareLinkStatus == MyProfileShareLinkStatus.success;
  bool get isShareLinkFailure =>
      shareLinkStatus == MyProfileShareLinkStatus.failure;

  MyProfileState copyWith({
    MyProfileTab? selectedTab,
    MyProfileEntity? profile,
    MyProfileEntity? editableProfile,
    FetchMyProfileStatus? fetchStatus,
    UpdateMyProfileStatus? updateStatus,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    MyProfileLibraryTab? selectedLibraryTab,
    FetchMyProfileStatus? libraryStatus,
    MyProfileLibraryEntity? libraryResponse,
    String? librarySearchText,
    bool? isLibraryLoadingMore,

    MyProfileFoldersTabEnum? selectedFoldersTab,
    FetchMyProfileStatus? foldersStatus,
    MyProfileFoldersEntity? foldersResponse,
    bool? isFoldersLoadingMore,
    bool clearFoldersResponse = false,

    FetchMyProfileFolderContentStatus? folderContentStatus,
    MyProfileFolderContentEntity? folderContentResponse,
    int? activeFolderContentId,
    bool clearFolderContentResponse = false,
    bool clearActiveFolderContentId = false,

    DeleteMyProfileFolderStatus? deleteFolderStatus,
    int? activeDeletingFolderId,
    bool clearActiveDeletingFolderId = false,
    String? folderActionMessage,
    bool clearFolderActionMessage = false,

    MyProfilePickerTestsTab? selectedTestsTab,

    MyProfileTestsStatus? testsStatus,
    MyProfileTestsLoadMoreStatus? testsLoadMoreStatus,
    MyProfilePickerTestsEntity? testsResponse,
    bool clearTestsResponse = false,

    String? testsSearchQuery,
    MyProfileTestsSearchStatus? testsSearchStatus,
    MyProfileTestsSearchLoadMoreStatus? testsSearchLoadMoreStatus,
    MyProfilePickerSearchTestsEntity? testsSearchResponse,
    bool clearTestsSearchResponse = false,
    int? testsSearchPage,
    bool? testsSearchHasMorePages,

    bool? isTestsFilterMode,
    MyProfileTestsFilterStatus? testsFilterStatus,
    MyProfileTestsFilterLoadMoreStatus? testsFilterLoadMoreStatus,
    MyProfileFilteredTestsEntity? filteredTestsResponse,
    bool clearFilteredTestsResponse = false,
    FilterMyProfileTestsParams? activeTestsFilterParams,
    bool clearActiveTestsFilterParams = false,
    List<InterestCategoryEntity>? testsFilterInterestCategories,
    bool? isTestsFilterInterestsLoading,
    String? testsFilterInterestsError,
    bool clearTestsFilterInterestsError = false,

    MyProfileShareLinkStatus? shareLinkStatus,
    String? shareUrl,
    bool clearShareUrl = false,
  }) {
    return MyProfileState(
      selectedTab: selectedTab ?? this.selectedTab,
      profile: profile ?? this.profile,
      editableProfile: editableProfile ?? this.editableProfile,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      selectedLibraryTab: selectedLibraryTab ?? this.selectedLibraryTab,
      libraryStatus: libraryStatus ?? this.libraryStatus,
      libraryResponse: libraryResponse ?? this.libraryResponse,
      librarySearchText: librarySearchText ?? this.librarySearchText,
      isLibraryLoadingMore: isLibraryLoadingMore ?? this.isLibraryLoadingMore,

      selectedFoldersTab: selectedFoldersTab ?? this.selectedFoldersTab,
      foldersStatus: foldersStatus ?? this.foldersStatus,
      foldersResponse: clearFoldersResponse
          ? null
          : foldersResponse ?? this.foldersResponse,
      isFoldersLoadingMore: isFoldersLoadingMore ?? this.isFoldersLoadingMore,

      folderContentStatus: folderContentStatus ?? this.folderContentStatus,
      folderContentResponse: clearFolderContentResponse
          ? null
          : folderContentResponse ?? this.folderContentResponse,
      activeFolderContentId: clearActiveFolderContentId
          ? null
          : activeFolderContentId ?? this.activeFolderContentId,

      deleteFolderStatus: deleteFolderStatus ?? this.deleteFolderStatus,
      activeDeletingFolderId: clearActiveDeletingFolderId
          ? null
          : activeDeletingFolderId ?? this.activeDeletingFolderId,
      folderActionMessage: clearFolderActionMessage
          ? null
          : folderActionMessage ?? this.folderActionMessage,
      selectedTestsTab: selectedTestsTab ?? this.selectedTestsTab,
      testsStatus: testsStatus ?? this.testsStatus,
      testsLoadMoreStatus: testsLoadMoreStatus ?? this.testsLoadMoreStatus,
      testsResponse: clearTestsResponse
          ? null
          : testsResponse ?? this.testsResponse,
      testsSearchQuery: testsSearchQuery ?? this.testsSearchQuery,
      testsSearchStatus: testsSearchStatus ?? this.testsSearchStatus,
      testsSearchLoadMoreStatus:
          testsSearchLoadMoreStatus ?? this.testsSearchLoadMoreStatus,
      testsSearchResponse: clearTestsSearchResponse
          ? null
          : testsSearchResponse ?? this.testsSearchResponse,
      testsSearchPage: testsSearchPage ?? this.testsSearchPage,
      testsSearchHasMorePages:
          testsSearchHasMorePages ?? this.testsSearchHasMorePages,

      isTestsFilterMode: isTestsFilterMode ?? this.isTestsFilterMode,
      testsFilterStatus: testsFilterStatus ?? this.testsFilterStatus,
      testsFilterLoadMoreStatus:
          testsFilterLoadMoreStatus ?? this.testsFilterLoadMoreStatus,
      filteredTestsResponse: clearFilteredTestsResponse
          ? null
          : filteredTestsResponse ?? this.filteredTestsResponse,
      activeTestsFilterParams: clearActiveTestsFilterParams
          ? null
          : activeTestsFilterParams ?? this.activeTestsFilterParams,
      testsFilterInterestCategories:
          testsFilterInterestCategories ?? this.testsFilterInterestCategories,
      isTestsFilterInterestsLoading:
          isTestsFilterInterestsLoading ?? this.isTestsFilterInterestsLoading,
      testsFilterInterestsError: clearTestsFilterInterestsError
          ? null
          : testsFilterInterestsError ?? this.testsFilterInterestsError,

      shareLinkStatus: shareLinkStatus ?? this.shareLinkStatus,
      shareUrl: clearShareUrl ? null : shareUrl ?? this.shareUrl,
    );
  }
}
