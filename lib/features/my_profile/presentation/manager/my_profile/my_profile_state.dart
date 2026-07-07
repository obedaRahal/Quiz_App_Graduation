import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_library_entity.dart';

enum MyProfileTab { personalInfo, tests,  content, folders}

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
    );
  }
}
