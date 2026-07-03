import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_entity.dart';

enum MyProfileTab {
  personalInfo,
  tests,
  folders,
  content,
  achievements,
}

enum FetchMyProfileStatus {
  initial,
  loading,
  success,
  failure,
}

enum UpdateMyProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class MyProfileState {
  final MyProfileTab selectedTab;

  final MyProfileEntity? profile;
  final MyProfileEntity? editableProfile;

  final FetchMyProfileStatus fetchStatus;
  final UpdateMyProfileStatus updateStatus;

  final String? errorTitle;
  final String? errorMessage;

  const MyProfileState({
    this.selectedTab = MyProfileTab.personalInfo,
    this.profile,
    this.editableProfile,
    this.fetchStatus = FetchMyProfileStatus.initial,
    this.updateStatus = UpdateMyProfileStatus.initial,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isFetchInitial => fetchStatus == FetchMyProfileStatus.initial;
  bool get isFetchLoading => fetchStatus == FetchMyProfileStatus.loading;
  bool get isFetchSuccess => fetchStatus == FetchMyProfileStatus.success;
  bool get isFetchFailure => fetchStatus == FetchMyProfileStatus.failure;

  bool get isUpdateLoading => updateStatus == UpdateMyProfileStatus.loading;
  bool get isUpdateSuccess => updateStatus == UpdateMyProfileStatus.success;
  bool get isUpdateFailure => updateStatus == UpdateMyProfileStatus.failure;

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
  }) {
    return MyProfileState(
      selectedTab: selectedTab ?? this.selectedTab,
      profile: profile ?? this.profile,
      editableProfile: editableProfile ?? this.editableProfile,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      updateStatus: updateStatus ?? this.updateStatus,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}