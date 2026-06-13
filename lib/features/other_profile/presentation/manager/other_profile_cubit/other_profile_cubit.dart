import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_overview_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_overview_params.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileCubit extends Cubit<OtherProfileState> {
  final FetchOtherProfileOverviewUseCase fetchOtherProfileOverviewUseCase;

  OtherProfileCubit({required this.fetchOtherProfileOverviewUseCase})
    : super(const OtherProfileState()) {
    debugPrint("============ OtherProfileCubit INIT ============");
  }

  void loadMockOtherProfile({required int userId}) {
    debugPrint(
      "============ OtherProfileCubit.loadMockOtherProfile ============",
    );
    debugPrint("→ params: {userId: $userId}");

    emit(
      state.copyWith(
        profile: OtherProfileMockData.profile.copyWith(userId: userId),
        folders: OtherProfileMockData.folders,
        contents: OtherProfileMockData.contents,
      ),
    );

    debugPrint("✓ mock other profile loaded");
    debugPrint("→ userId: $userId");
    debugPrint("=================================================");
  }

  void changeSelectedTab(OtherProfileTab tab) {
    debugPrint("============ OtherProfileCubit.changeSelectedTab ============");
    debugPrint("→ selected tab: $tab");

    if (state.selectedTab == tab) {
      debugPrint("✗ tab already selected");
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(selectedTab: tab));

    debugPrint("✓ selected tab changed");
    debugPrint("=================================================");
  }

  void toggleFollowLocally() {
    debugPrint(
      "============ OtherProfileCubit.toggleFollowLocally ============",
    );

    final profile = state.profile;

    if (profile == null) {
      debugPrint("✗ profile is null");
      debugPrint("=================================================");
      return;
    }

    final nextIsFollowing = !profile.isFollowing;

    final nextFollowersCount = nextIsFollowing
        ? profile.followersCount + 1
        : (profile.followersCount - 1).clamp(0, 999999999);

    emit(
      state.copyWith(
        profile: profile.copyWith(
          isFollowing: nextIsFollowing,
          followersCount: nextFollowersCount,
        ),
      ),
    );

    debugPrint("✓ follow state changed locally");
    debugPrint("→ isFollowing: $nextIsFollowing");
    debugPrint("→ followersCount: $nextFollowersCount");
    debugPrint("=================================================");
  }

  void changeSelectedTestsFilter(OtherProfileTestsFilter filter) {
    debugPrint(
      "============ OtherProfileCubit.changeSelectedTestsFilter ============",
    );
    debugPrint("→ selected filter: $filter");

    if (state.selectedTestsFilter == filter) {
      debugPrint("✗ filter already selected");
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(selectedTestsFilter: filter));

    debugPrint("✓ selected tests filter changed");
    debugPrint("=================================================");
  }

  void toggleFolderSaveLocally({required int folderId}) {
    debugPrint(
      "============ OtherProfileCubit.toggleFolderSaveLocally ============",
    );
    debugPrint("→ folderId: $folderId");

    final folders = state.folders;
    final folderIndex = folders.indexWhere((folder) => folder.id == folderId);

    if (folderIndex == -1) {
      debugPrint("✗ folder not found");
      debugPrint("=================================================");
      return;
    }

    final folder = folders[folderIndex];
    final updatedFolder = folder.copyWith(isSaved: !folder.isSaved);

    final updatedFolders = List<OtherProfileFolderUiModel>.from(folders);
    updatedFolders[folderIndex] = updatedFolder;

    emit(state.copyWith(folders: updatedFolders));

    debugPrint("✓ folder save state changed locally");
    debugPrint("→ isSaved: ${updatedFolder.isSaved}");
    debugPrint("=================================================");
  }

  void changeSelectedContentFilter(OtherProfileContentFilter filter) {
    debugPrint(
      "============ OtherProfileCubit.changeSelectedContentFilter ============",
    );
    debugPrint("→ selected filter: $filter");

    if (state.selectedContentFilter == filter) {
      debugPrint("✗ content filter already selected");
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(selectedContentFilter: filter));

    debugPrint("✓ selected content filter changed");
    debugPrint("=================================================");
  }

  void toggleContentSaveLocally({required int contentId}) {
    debugPrint(
      "============ OtherProfileCubit.toggleContentSaveLocally ============",
    );
    debugPrint("→ contentId: $contentId");

    final contents = state.contents;
    final contentIndex = contents.indexWhere((item) => item.id == contentId);

    if (contentIndex == -1) {
      debugPrint("✗ content not found");
      debugPrint("=================================================");
      return;
    }

    final content = contents[contentIndex];

    final updatedContent = content.copyWith(isSaved: !content.isSaved);

    final updatedContents = List<OtherProfileContentUiModel>.from(contents);
    updatedContents[contentIndex] = updatedContent;

    emit(state.copyWith(contents: updatedContents));

    debugPrint("✓ content save state changed locally");
    debugPrint("→ isSaved: ${updatedContent.isSaved}");
    debugPrint("=================================================");
  }

  void toggleContentLikeLocally({required int contentId}) {
    debugPrint(
      "============ OtherProfileCubit.toggleContentLikeLocally ============",
    );
    debugPrint("→ contentId: $contentId");

    final contents = state.contents;
    final contentIndex = contents.indexWhere((item) => item.id == contentId);

    if (contentIndex == -1) {
      debugPrint("✗ content not found");
      debugPrint("=================================================");
      return;
    }

    final content = contents[contentIndex];

    final nextIsLiked = !content.isLiked;

    final nextLikesCount = nextIsLiked
        ? content.likesCount + 1
        : (content.likesCount - 1).clamp(0, 999999999);

    final updatedContent = content.copyWith(
      isLiked: nextIsLiked,
      likesCount: nextLikesCount,
    );

    final updatedContents = List<OtherProfileContentUiModel>.from(contents);
    updatedContents[contentIndex] = updatedContent;

    emit(state.copyWith(contents: updatedContents));

    debugPrint("✓ content like state changed locally");
    debugPrint("→ isLiked: $nextIsLiked");
    debugPrint("→ likesCount: $nextLikesCount");
    debugPrint("=================================================");
  }

  //////////////////////////////// APIs ////////////////////////

  Future<void> getOtherProfileOverview({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileOverview ============",
    );
    debugPrint("→ params: {userId: $userId}");

    emit(
      state.copyWith(
        fetchOverviewStatus: FetchOtherProfileOverviewStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileOverviewUseCase(
      FetchOtherProfileOverviewParams(userId: userId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ OtherProfileCubit.getOtherProfileOverview Failure");
        debugPrint("→ Title: ${failure.title}, Message: ${failure.message}");
        debugPrint("=================================================");
        emit(
          state.copyWith(
            fetchOverviewStatus: FetchOtherProfileOverviewStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ OtherProfileCubit.getOtherProfileOverview Success");
        debugPrint("=================================================");
        emit(
          state.copyWith(
            fetchOverviewStatus: FetchOtherProfileOverviewStatus.success,
            overview: response,
            clearError: true,
          ),
        );
      },
    );
  }

  void resetFetchOverviewState() {
    emit(
      state.copyWith(
        fetchOverviewStatus: FetchOtherProfileOverviewStatus.initial,
      ),
    );
  }
}
