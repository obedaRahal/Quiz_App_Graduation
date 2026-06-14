import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_content_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_folders_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_overview_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/fetch_other_profile_tests_use_case.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_content_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_folders_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_overview_params.dart';
import 'package:quiz_app_grad/features/other_profile/domain/use_cases/params/fetch_other_profile_tests_params.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileCubit extends Cubit<OtherProfileState> {
  final FetchOtherProfileOverviewUseCase fetchOtherProfileOverviewUseCase;
  final FetchOtherProfileTestsUseCase fetchOtherProfileTestsUseCase;
  bool _isFetchingMoreTests = false;

  final FetchOtherProfileFoldersUseCase fetchOtherProfileFoldersUseCase;
  bool _isFetchingMoreFolders = false;

  final FetchOtherProfileContentUseCase fetchOtherProfileContentUseCase;
  bool _isFetchingMoreContent = false;

  OtherProfileCubit({
    required this.fetchOtherProfileOverviewUseCase,
    required this.fetchOtherProfileTestsUseCase,
    required this.fetchOtherProfileFoldersUseCase,
    required this.fetchOtherProfileContentUseCase,
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
}
