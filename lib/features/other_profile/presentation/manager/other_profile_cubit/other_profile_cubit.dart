import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/compact_count_formatter.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/follow_creator_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/test_follow_action_params.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/unfollow_creator_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folder_details_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_content_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_folder_details_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_folders_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_overview_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_tests_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_receive_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/get_other_profile_share_link_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/content_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_content_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_folder_details_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_folders_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_overview_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_tests_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/folder_bookmark_action_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_receive_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/get_other_profile_share_link_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/remove_content_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/remove_folder_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/save_content_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/save_folder_bookmark_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileCubit extends Cubit<OtherProfileState> {
  final FetchOtherProfileOverviewUseCase fetchOtherProfileOverviewUseCase;
  final FetchOtherProfileTestsUseCase fetchOtherProfileTestsUseCase;
  bool _isFetchingMoreTests = false;

  final FetchOtherProfileFoldersUseCase fetchOtherProfileFoldersUseCase;
  bool _isFetchingMoreFolders = false;

  final FetchOtherProfileContentUseCase fetchOtherProfileContentUseCase;
  bool _isFetchingMoreContent = false;

  final FollowCreatorUseCase followCreatorUseCase;
  final UnfollowCreatorUseCase unfollowCreatorUseCase;

  final SaveFolderBookmarkUseCase saveFolderBookmarkUseCase;
  final RemoveFolderBookmarkUseCase removeFolderBookmarkUseCase;

  final SaveContentBookmarkUseCase saveContentBookmarkUseCase;
  final RemoveContentBookmarkUseCase removeContentBookmarkUseCase;

  final GetOtherProfileShareLinkUseCase getOtherProfileShareLinkUseCase;
  final GetOtherProfileReceiveUseCase getOtherProfileReceiveUseCase;

  final FetchOtherProfileFolderDetailsUseCase
  fetchOtherProfileFolderDetailsUseCase;
  OtherProfileCubit({
    required this.fetchOtherProfileOverviewUseCase,
    required this.fetchOtherProfileTestsUseCase,
    required this.fetchOtherProfileFoldersUseCase,
    required this.fetchOtherProfileContentUseCase,
    required this.followCreatorUseCase,
    required this.unfollowCreatorUseCase,
    required this.saveFolderBookmarkUseCase,
    required this.removeFolderBookmarkUseCase,

    required this.saveContentBookmarkUseCase,
    required this.removeContentBookmarkUseCase,
    required this.fetchOtherProfileFolderDetailsUseCase,

    required this.getOtherProfileShareLinkUseCase,
    required this.getOtherProfileReceiveUseCase,
  }) : super(const OtherProfileState()) {
    debugPrint("============ OtherProfileCubit INIT ============");
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

  ////
  // void changeSelectedTestsFilter(OtherProfileTestsFilter filter) {
  //   debugPrint(
  //     "============ OtherProfileCubit.changeSelectedTestsFilter ============",
  //   );
  //   debugPrint("→ selected filter: $filter");

  //   if (state.selectedTestsFilter == filter) {
  //     debugPrint("✗ filter already selected");
  //     debugPrint("=================================================");
  //     return;
  //   }

  //   emit(state.copyWith(selectedTestsFilter: filter));

  //   debugPrint("✓ selected tests filter changed");
  //   debugPrint("=================================================");
  // }

  void changeSelectedTestsFilter(
    OtherProfileTestsFilter filter, {
    required int userId,
  }) {
    debugPrint(
      "============ OtherProfileCubit.changeSelectedTestsFilter ============",
    );
    debugPrint("→ selected filter: $filter, userId: $userId");

    if (state.selectedTestsFilter == filter &&
        state.getTestsStatus == GetOtherProfileTestsStatus.success) {
      debugPrint("✗ filter already selected and data exists");
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(selectedTestsFilter: filter));

    debugPrint("✓ selected tests filter changed -> fetching data");
    debugPrint("=================================================");

    getOtherProfileTests(userId: userId);
  }

  Future<void> getOtherProfileTests({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileTests ============",
    );
    debugPrint(
      "→ params: {userId: $userId, tab/filter: ${state.selectedTestsFilter.name}}",
    );

    emit(
      state.copyWith(
        getTestsStatus: GetOtherProfileTestsStatus.loading,
        getMoreTestsStatus: GetMoreOtherProfileTestsStatus.initial,
        tests: [],
        clearTestsMeta: true,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileTestsUseCase(
      FetchOtherProfileTestsParams(
        userId: userId,
        tab: state.selectedTestsFilter.name,
        cursor: null,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ OtherProfileCubit.getOtherProfileTests Failure");
        debugPrint("→ Title: ${failure.title}, Message: ${failure.message}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getTestsStatus: GetOtherProfileTestsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ OtherProfileCubit.getOtherProfileTests Success");
        debugPrint("→ items count: ${response.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getTestsStatus: GetOtherProfileTestsStatus.success,
            tests: response.data,
            testsMeta: response.meta,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> loadMoreOtherProfileTests({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.loadMoreOtherProfileTests ============",
    );

    if (_isFetchingMoreTests) {
      debugPrint("✗ already fetching more tests");
      debugPrint("=================================================");
      return;
    }

    if (state.isGetTestsLoading || state.isGetMoreTestsLoading) {
      debugPrint("✗ tests loading already active");
      debugPrint("=================================================");
      return;
    }

    if (!state.hasMoreTestsPages) {
      debugPrint("✗ no more test pages");
      debugPrint("=================================================");
      return;
    }

    final cursor = state.nextTestsCursor;

    if (cursor == null || cursor.trim().isEmpty) {
      debugPrint("✗ next tests cursor is empty");
      debugPrint("=================================================");
      return;
    }

    _isFetchingMoreTests = true;

    emit(
      state.copyWith(
        getMoreTestsStatus: GetMoreOtherProfileTestsStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileTestsUseCase(
      FetchOtherProfileTestsParams(
        userId: userId,
        tab: state.selectedTestsFilter.name,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ loadMoreOtherProfileTests failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            getMoreTestsStatus: GetMoreOtherProfileTestsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final mergedTests = [...state.tests, ...response.data];

        debugPrint("✓ loadMoreOtherProfileTests success");
        debugPrint("→ old tests count: ${state.tests.length}");
        debugPrint("→ new tests count: ${response.data.length}");
        debugPrint("→ total tests count: ${mergedTests.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            getMoreTestsStatus: GetMoreOtherProfileTestsStatus.success,
            getTestsStatus: GetOtherProfileTestsStatus.success,
            tests: mergedTests,
            testsMeta: response.meta,
            clearError: true,
          ),
        );
      },
    );

    _isFetchingMoreTests = false;

    debugPrint("=================================================");
  }

  void resetGetTestsState() {
    emit(state.copyWith(getTestsStatus: GetOtherProfileTestsStatus.initial));
  }

  void resetGetMoreTestsState() {
    emit(
      state.copyWith(
        getMoreTestsStatus: GetMoreOtherProfileTestsStatus.initial,
        clearError: true,
      ),
    );
  }

  ///////////////////////////// folders /////////////////////
  Future<void> getOtherProfileFolders({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileFolders ============",
    );
    debugPrint("→ params: {userId: $userId}");

    emit(
      state.copyWith(
        getFoldersStatus: GetOtherProfileFoldersStatus.loading,
        getMoreFoldersStatus: GetMoreOtherProfileFoldersStatus.initial,
        clearFoldersResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileFoldersUseCase(
      FetchOtherProfileFoldersParams(userId: userId, cursor: null),
    );

    result.fold(
      (failure) {
        debugPrint("✗ OtherProfileCubit.getOtherProfileFolders Failure");
        debugPrint("→ Title: ${failure.title}, Message: ${failure.message}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getFoldersStatus: GetOtherProfileFoldersStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ OtherProfileCubit.getOtherProfileFolders Success");
        debugPrint("→ items count: ${response.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getFoldersStatus: GetOtherProfileFoldersStatus.success,
            foldersResponse: response,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> loadMoreOtherProfileFolders({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.loadMoreOtherProfileFolders ============",
    );

    if (_isFetchingMoreFolders) {
      debugPrint("✗ already fetching more folders");
      debugPrint("=================================================");
      return;
    }

    if (state.isGetFoldersLoading || state.isGetMoreFoldersLoading) {
      debugPrint("✗ folders loading already active");
      debugPrint("=================================================");
      return;
    }

    if (!state.hasMoreFoldersPages) {
      debugPrint("✗ no more folder pages");
      debugPrint("=================================================");
      return;
    }

    final cursor = state.nextFoldersCursor;

    if (cursor == null || cursor.trim().isEmpty) {
      debugPrint("✗ next folders cursor is empty");
      debugPrint("=================================================");
      return;
    }

    _isFetchingMoreFolders = true;

    emit(
      state.copyWith(
        getMoreFoldersStatus: GetMoreOtherProfileFoldersStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileFoldersUseCase(
      FetchOtherProfileFoldersParams(userId: userId, cursor: cursor),
    );

    result.fold(
      (failure) {
        debugPrint("✗ loadMoreOtherProfileFolders failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            getMoreFoldersStatus: GetMoreOtherProfileFoldersStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final oldFolders = state.foldersResponse?.data ?? [];

        final mergedResponse = OtherProfileFoldersResponseEntity(
          success: response.success,
          message: response.message,
          data: [...oldFolders, ...response.data],
          meta: response.meta,
          statusCode: response.statusCode,
        );

        debugPrint("✓ loadMoreOtherProfileFolders success");
        debugPrint("→ old folders count: ${oldFolders.length}");
        debugPrint("→ new folders count: ${response.data.length}");
        debugPrint("→ total folders count: ${mergedResponse.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            getMoreFoldersStatus: GetMoreOtherProfileFoldersStatus.success,
            getFoldersStatus: GetOtherProfileFoldersStatus.success,
            foldersResponse: mergedResponse,
            clearError: true,
          ),
        );
      },
    );

    _isFetchingMoreFolders = false;

    debugPrint("=================================================");
  }
  //////////////////////////////////////////

  void changeSelectedContentFilter(
    OtherProfileContentFilter filter, {
    required int userId,
  }) {
    debugPrint(
      "============ OtherProfileCubit.changeSelectedContentFilter ============",
    );
    debugPrint("→ selected filter: $filter, userId: $userId");

    if (state.selectedContentFilter == filter &&
        state.getContentStatus == GetOtherProfileContentStatus.success) {
      debugPrint("✗ content filter already selected and data exists");
      debugPrint("=================================================");
      return;
    }

    emit(state.copyWith(selectedContentFilter: filter));

    debugPrint("✓ selected content filter changed -> fetching data");
    debugPrint("=================================================");

    getOtherProfileContent(userId: userId);
  }

  Future<void> getOtherProfileContent({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileContent ============",
    );
    debugPrint(
      "→ params: {userId: $userId, tab/filter: ${state.selectedContentFilter.name}}",
    );

    emit(
      state.copyWith(
        getContentStatus: GetOtherProfileContentStatus.loading,
        getMoreContentStatus: GetMoreOtherProfileContentStatus.initial,
        clearContentResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileContentUseCase(
      FetchOtherProfileContentParams(
        userId: userId,
        tab: state.selectedContentFilter.name,
        cursor: null,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ OtherProfileCubit.getOtherProfileContent Failure");
        debugPrint("→ Title: ${failure.title}, Message: ${failure.message}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getContentStatus: GetOtherProfileContentStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ OtherProfileCubit.getOtherProfileContent Success");
        debugPrint("→ items count: ${response.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getContentStatus: GetOtherProfileContentStatus.success,
            contentResponse: response,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> loadMoreOtherProfileContent({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.loadMoreOtherProfileContent ============",
    );

    if (_isFetchingMoreContent) {
      debugPrint("✗ already fetching more content");
      debugPrint("=================================================");
      return;
    }

    if (state.isGetContentLoading || state.isGetMoreContentLoading) {
      debugPrint("✗ content loading already active");
      debugPrint("=================================================");
      return;
    }

    if (!state.hasMoreContentPages) {
      debugPrint("✗ no more content pages");
      debugPrint("=================================================");
      return;
    }

    final cursor = state.nextContentCursor;

    if (cursor == null || cursor.trim().isEmpty) {
      debugPrint("✗ next content cursor is empty");
      debugPrint("=================================================");
      return;
    }

    _isFetchingMoreContent = true;

    emit(
      state.copyWith(
        getMoreContentStatus: GetMoreOtherProfileContentStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileContentUseCase(
      FetchOtherProfileContentParams(
        userId: userId,
        tab: state.selectedContentFilter.name,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ loadMoreOtherProfileContent failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            getMoreContentStatus: GetMoreOtherProfileContentStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final oldContent = state.contentResponse?.data ?? [];

        final mergedResponse = OtherProfileContentResponseEntity(
          success: response.success,
          message: response.message,
          data: [...oldContent, ...response.data],
          meta: response.meta,
          statusCode: response.statusCode,
        );

        debugPrint("✓ loadMoreOtherProfileContent success");
        debugPrint("→ old content count: ${oldContent.length}");
        debugPrint("→ new content count: ${response.data.length}");
        debugPrint("→ total content count: ${mergedResponse.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            getMoreContentStatus: GetMoreOtherProfileContentStatus.success,
            getContentStatus: GetOtherProfileContentStatus.success,
            contentResponse: mergedResponse,
            clearError: true,
          ),
        );
      },
    );

    _isFetchingMoreContent = false;

    debugPrint("=================================================");
  }

  /////////////////// follow and unfollow //////////////////
  Future<void> toggleOtherProfileFollow() async {
    debugPrint(
      "============ OtherProfileCubit.toggleOtherProfileFollow ============",
    );

    final overview = state.overview;

    if (overview == null) {
      debugPrint("✗ overview is null, cannot toggle follow");
      debugPrint("=================================================");
      return;
    }

    if (state.isFollowActionLoading) {
      debugPrint("✗ follow action already loading");
      debugPrint("=================================================");
      return;
    }

    final header = overview.data.header;

    final userId = header.userId;
    final currentIsFollowing = header.viewerIsFollowing;
    final currentFollowersCount = parseCompactCount(header.followersCount);

    debugPrint("→ userId: $userId");
    debugPrint("→ currentIsFollowing: $currentIsFollowing");
    debugPrint("→ currentFollowersCount: $currentFollowersCount");

    emit(
      state.copyWith(
        followActionStatus: OtherProfileFollowActionStatus.loading,
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
        debugPrint("✗ toggle follow failure title: ${failure.title}");
        debugPrint("✗ toggle follow failure message: ${failure.message}");

        emit(
          state.copyWith(
            followActionStatus: OtherProfileFollowActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final newIsFollowing = !currentIsFollowing;

        final int updatedFollowersCount = newIsFollowing
            ? currentFollowersCount + 1
            : (currentFollowersCount - 1).clamp(0, 999999999);

        debugPrint("✓ toggle follow success");
        debugPrint("→ response message: ${response.message}");
        debugPrint("→ newIsFollowing: $newIsFollowing");
        debugPrint("→ updatedFollowersCount: $updatedFollowersCount");

        final updatedOverview = overview.copyWith(
          data: overview.data.copyWith(
            header: header.copyWith(
              viewerIsFollowing: newIsFollowing,
              followersCount: updatedFollowersCount,
            ),
          ),
        );

        emit(
          state.copyWith(
            followActionStatus: OtherProfileFollowActionStatus.success,
            overview: updatedOverview,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetFollowActionState() {
    emit(
      state.copyWith(
        followActionStatus: OtherProfileFollowActionStatus.initial,
        clearError: true,
      ),
    );
  }

  ////////////// save folder unsave //////////
  Future<void> toggleFolderBookmark({required int folderId}) async {
    debugPrint(
      "============ OtherProfileCubit.toggleFolderBookmark ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    if (state.isFolderBookmarkLoading &&
        state.activeBookmarkFolderId == folderId) {
      debugPrint("✗ bookmark action already loading for this folder");
      debugPrint("=================================================");
      return;
    }

    final foldersResponse = state.foldersResponse;
    if (foldersResponse == null) {
      debugPrint("✗ foldersResponse is null");
      debugPrint("=================================================");
      return;
    }

    final index = foldersResponse.data.indexWhere(
      (folder) => folder.id == folderId,
    );

    if (index == -1) {
      debugPrint("✗ folder not found");
      debugPrint("=================================================");
      return;
    }

    final folder = foldersResponse.data[index];
    final currentIsBookmarked = folder.viewerHasBookmarked;
    final newIsBookmarked = !currentIsBookmarked;

    debugPrint("→ currentIsBookmarked: $currentIsBookmarked");

    emit(
      state.copyWith(
        folderBookmarkActionStatus: FolderBookmarkActionStatus.loading,
        activeBookmarkFolderId: folderId,
        clearError: true,
      ),
    );

    final result = currentIsBookmarked
        ? await removeFolderBookmarkUseCase(
            FolderBookmarkActionParams(folderId: folderId),
          )
        : await saveFolderBookmarkUseCase(
            FolderBookmarkActionParams(folderId: folderId),
          );

    result.fold(
      (failure) {
        debugPrint("✗ toggleFolderBookmark failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            folderBookmarkActionStatus: FolderBookmarkActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveBookmarkFolderId: true,
          ),
        );
      },
      (response) {
        final updatedFolders = List<OtherProfileFolderItemEntity>.from(
          foldersResponse.data,
        );

        updatedFolders[index] = folder.copyWith(
          viewerHasBookmarked: newIsBookmarked,
        );

        final updatedResponse = OtherProfileFoldersResponseEntity(
          success: foldersResponse.success,
          message: foldersResponse.message,
          data: updatedFolders,
          meta: foldersResponse.meta,
          statusCode: foldersResponse.statusCode,
        );

        OtherProfileFolderDetailsEntity? updatedFolderDetails =
            state.folderDetails;

        if (updatedFolderDetails != null &&
            updatedFolderDetails.data.folder.id == folderId) {
          updatedFolderDetails = OtherProfileFolderDetailsEntity(
            success: updatedFolderDetails.success,
            title: updatedFolderDetails.title,
            statusCode: updatedFolderDetails.statusCode,
            data: OtherProfileFolderDetailsDataEntity(
              folder: updatedFolderDetails.data.folder.copyWith(
                viewerHasBookmarked: newIsBookmarked,
              ),
              items: updatedFolderDetails.data.items,
            ),
          );
        }

        debugPrint("✓ toggleFolderBookmark success");
        debugPrint("→ response message: ${response.message}");
        debugPrint("→ newIsBookmarked: $newIsBookmarked");

        emit(
          state.copyWith(
            folderBookmarkActionStatus: FolderBookmarkActionStatus.success,
            foldersResponse: updatedResponse,
            folderDetails: updatedFolderDetails,
            clearError: true,
            clearActiveBookmarkFolderId: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetFolderBookmarkActionState() {
    emit(
      state.copyWith(
        folderBookmarkActionStatus: FolderBookmarkActionStatus.initial,
        clearActiveBookmarkFolderId: true,
        clearError: true,
      ),
    );
  }

  Future<void> toggleContentBookmark({required int contentId}) async {
    debugPrint(
      "============ OtherProfileCubit.toggleContentBookmark ============",
    );
    debugPrint("→ params: {contentId: $contentId}");

    if (state.isContentBookmarkLoading &&
        state.activeBookmarkContentId == contentId) {
      debugPrint("✗ bookmark action already loading for this content");
      debugPrint("=================================================");
      return;
    }

    final contentResponse = state.contentResponse;

    if (contentResponse == null) {
      debugPrint("✗ contentResponse is null");
      debugPrint("=================================================");
      return;
    }

    final index = contentResponse.data.indexWhere(
      (content) => content.id == contentId,
    );

    if (index == -1) {
      debugPrint("✗ content not found");
      debugPrint("=================================================");
      return;
    }

    final content = contentResponse.data[index];
    final currentIsBookmarked = content.viewerHasBookmarked;

    emit(
      state.copyWith(
        contentBookmarkActionStatus: ContentBookmarkActionStatus.loading,
        activeBookmarkContentId: contentId,
        clearError: true,
      ),
    );

    final result = currentIsBookmarked
        ? await removeContentBookmarkUseCase(
            ContentBookmarkActionParams(contentId: contentId),
          )
        : await saveContentBookmarkUseCase(
            ContentBookmarkActionParams(contentId: contentId),
          );

    result.fold(
      (failure) {
        debugPrint("✗ toggleContentBookmark failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            contentBookmarkActionStatus: ContentBookmarkActionStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearActiveBookmarkContentId: true,
          ),
        );
      },
      (response) {
        final updatedContents = List<OtherProfileContentItemEntity>.from(
          contentResponse.data,
        );

        updatedContents[index] = content.copyWith(
          viewerHasBookmarked: !currentIsBookmarked,
        );

        final updatedResponse = OtherProfileContentResponseEntity(
          success: contentResponse.success,
          message: contentResponse.message,
          data: updatedContents,
          meta: contentResponse.meta,
          statusCode: contentResponse.statusCode,
        );

        debugPrint("✓ toggleContentBookmark success");
        debugPrint("→ response message: ${response.message}");
        debugPrint("→ newIsBookmarked: ${!currentIsBookmarked}");

        emit(
          state.copyWith(
            contentBookmarkActionStatus: ContentBookmarkActionStatus.success,
            contentResponse: updatedResponse,
            clearError: true,
            clearActiveBookmarkContentId: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void resetContentBookmarkActionState() {
    emit(
      state.copyWith(
        contentBookmarkActionStatus: ContentBookmarkActionStatus.initial,
        clearActiveBookmarkContentId: true,
        clearError: true,
      ),
    );
  }

  /////////////// get folder details ///////////////////////
  Future<void> getOtherProfileFolderDetails({required int folderId}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileFolderDetails ============",
    );
    debugPrint("→ params: {folderId: $folderId}");

    emit(
      state.copyWith(
        getFolderDetailsStatus: GetOtherProfileFolderDetailsStatus.loading,
        clearFolderDetails: true,
        clearError: true,
      ),
    );

    final result = await fetchOtherProfileFolderDetailsUseCase(
      FetchOtherProfileFolderDetailsParams(folderId: folderId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ OtherProfileCubit.getOtherProfileFolderDetails Failure");
        debugPrint("→ Title: ${failure.title}, Message: ${failure.message}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getFolderDetailsStatus: GetOtherProfileFolderDetailsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ OtherProfileCubit.getOtherProfileFolderDetails Success");
        debugPrint("→ folder id: ${response.data.folder.id}");
        debugPrint("→ tests count: ${response.data.items.length}");
        debugPrint("=================================================");

        emit(
          state.copyWith(
            getFolderDetailsStatus: GetOtherProfileFolderDetailsStatus.success,
            folderDetails: response,
            clearError: true,
          ),
        );
      },
    );
  }

  void resetFolderDetailsState() {
    emit(
      state.copyWith(
        getFolderDetailsStatus: GetOtherProfileFolderDetailsStatus.initial,
        clearFolderDetails: true,
        clearError: true,
      ),
    );
  }

  ////////////// share profile  and receive ////////////////
  Future<void> getOtherProfileShareLink({required int userId}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileShareLink ============",
    );
    debugPrint("→ params: {userId: $userId}");

    if (state.isShareLinkLoading) return;

    emit(
      state.copyWith(
        shareLinkStatus: OtherProfileShareLinkStatus.loading,
        clearShareUrl: true,
        clearError: true,
      ),
    );

    final result = await getOtherProfileShareLinkUseCase(
      GetOtherProfileShareLinkParams(userId: userId),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            shareLinkStatus: OtherProfileShareLinkStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearShareUrl: true,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            shareLinkStatus: OtherProfileShareLinkStatus.success,
            shareUrl: response.data.shareUrl,
            clearError: true,
          ),
        );
      },
    );
  }

  void resetOtherProfileShareLinkState() {
    emit(
      state.copyWith(
        shareLinkStatus: OtherProfileShareLinkStatus.initial,
        clearShareUrl: true,
        clearError: true,
      ),
    );
  }

  Future<void> getOtherProfileReceive({required String slug}) async {
    debugPrint(
      "============ OtherProfileCubit.getOtherProfileReceive ============",
    );
    debugPrint("→ params: {slug: $slug}");

    if (state.isReceiveLoading) return;

    final cleanSlug = slug.trim();

    if (cleanSlug.isEmpty) {
      emit(
        state.copyWith(
          receiveStatus: OtherProfileReceiveStatus.failure,
          errorTitle: "خطأ",
          errorMessage: "رابط الملف الشخصي غير صالح",
          clearReceiveData: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        receiveStatus: OtherProfileReceiveStatus.loading,
        clearReceiveData: true,
        clearError: true,
      ),
    );

    final result = await getOtherProfileReceiveUseCase(
      GetOtherProfileReceiveParams(slug: cleanSlug),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            receiveStatus: OtherProfileReceiveStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
            clearReceiveData: true,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            receiveStatus: OtherProfileReceiveStatus.success,
            receivedUserId: response.data.userId,
            receivedIsThisYourProfile: response.data.isThisYourProfile,
            clearError: true,
          ),
        );
      },
    );
  }

  void resetOtherProfileReceiveState() {
    emit(
      state.copyWith(
        receiveStatus: OtherProfileReceiveStatus.initial,
        clearReceiveData: true,
        clearError: true,
      ),
    );
  }
}
