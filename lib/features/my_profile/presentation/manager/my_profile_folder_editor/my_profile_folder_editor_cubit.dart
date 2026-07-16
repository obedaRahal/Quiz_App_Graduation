import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/my_profile/data/models/my_profile_folder_editor_route_args.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_selected_test_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_folder_content_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/create_my_profile_folder_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_%5Bicker_search_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_folder_content_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/fetch_my_profile_picker_tests_use_case.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/create_my_profile_folder_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_folder_content_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_picker_search_tests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/fetch_my_profile_picker_tests_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/params/update_my_profile_folder_params.dart';
import 'package:quiz_app_grad/features/my_profile/domain/use_cases/update_my_profile_folder_use_case.dart';
import 'my_profile_folder_editor_state.dart';

class MyProfileFolderEditorCubit extends Cubit<MyProfileFolderEditorState> {
  final FetchMyProfilePickerTestsUseCase fetchMyProfilePickerTestsUseCase;

  final FetchMyProfilePickerSearchTestsUseCase
  fetchMyProfilePickerSearchTestsUseCase;
  Timer? _pickerSearchDebounce;

  final CreateMyProfileFolderUseCase createMyProfileFolderUseCase;

  final UpdateMyProfileFolderUseCase updateMyProfileFolderUseCase;
  final FetchMyProfileFolderContentUseCase fetchMyProfileFolderContentUseCase;

  MyProfileFolderEditorCubit({
    required this.fetchMyProfilePickerTestsUseCase,
    required this.fetchMyProfilePickerSearchTestsUseCase,
    required this.createMyProfileFolderUseCase,
    required this.updateMyProfileFolderUseCase,
    required this.fetchMyProfileFolderContentUseCase,
  }) : super(const MyProfileFolderEditorState()) {
    debugPrint("============ MyProfileFolderEditorCubit INIT ============");
  }

  void init(MyProfileFolderEditorRouteArgs args) {
    debugPrint("============ MyProfileFolderEditorCubit.init ============");
    debugPrint("→ mode: ${args.mode}");
    debugPrint("→ folderId: ${args.folder?.id}");

    final folder = args.folder;

    if (args.mode == MyProfileFolderEditorMode.create || folder == null) {
      emit(
        const MyProfileFolderEditorState().copyWith(
          mode: MyProfileFolderEditorMode.create,
          selectedTests: const [],
          originalTestIds: const [],
        ),
      );

      debugPrint("✓ init create mode");
      debugPrint("=================================================");
      return;
    }

    final isPublic = folder.folderKind.trim() == 'عام';

    emit(
      MyProfileFolderEditorState(
        mode: MyProfileFolderEditorMode.edit,
        folderId: folder.id,
        name: folder.name,
        colorCode: folder.colorCode,
        isPublic: isPublic,
        selectedTests: const [],
        originalName: folder.name,
        originalColorCode: folder.colorCode,
        originalIsPublic: isPublic,
        originalTestIds: const [],
      ),
    );
    fetchFolderTestsForEdit(folder.id);

    debugPrint("✓ init edit mode");
    debugPrint("=================================================");
  }
  // List<MyProfileFolderSelectedTestEntity> get _demoSelectedTests => const [
  //   MyProfileFolderSelectedTestEntity(
  //     id: 1,
  //     title: 'اختبار Flutter',
  //     description: 'اختبار تدريبي لتطوير تطبيقات Flutter.',
  //     interests: ['Flutter', 'Dart', 'Flutter', 'Dart'],
  //     difficultyLevel: 'متوسط',
  //     questionCount: 30,
  //     averageRating: 4.5,
  //     price: 0,
  //     publishedAt: 'منذ ساعة',
  //   ),
  //   MyProfileFolderSelectedTestEntity(
  //     id: 3,
  //     title: 'اختبار قواعد البيانات',
  //     description: 'اختبار شامل في SQL وقواعد البيانات.',
  //     interests: ['SQL', 'Database'],
  //     difficultyLevel: 'صعب',
  //     questionCount: 40,
  //     averageRating: 4.8,
  //     price: 10000,
  //     publishedAt: 'منذ يوم',
  //   ),
  //   MyProfileFolderSelectedTestEntity(
  //     id: 4,
  //     title: 'اختبار قواعد البيانات',
  //     description: 'اختبار شامل في SQL وقواعد البيانات.',
  //     interests: ['SQL', 'Database'],
  //     difficultyLevel: 'صعب',
  //     questionCount: 40,
  //     averageRating: 4.8,
  //     price: 10000,
  //     publishedAt: 'منذ يوم',
  //   ),
  //   MyProfileFolderSelectedTestEntity(
  //     id: 5,
  //     title: 'اختبار قواعد البيانات',
  //     description: 'اختبار شامل في SQL وقواعد البيانات.',
  //     interests: ['SQL', 'Database'],
  //     difficultyLevel: 'صعب',
  //     questionCount: 40,
  //     averageRating: 4.8,
  //     price: 10000,
  //     publishedAt: 'منذ يوم',
  //   ),
  // ];

  void nameChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void colorChanged(String colorCode) {
    debugPrint("MyProfileFolderEditorCubit.colorChanged -> $colorCode");

    emit(
      state.copyWith(
        colorCode: colorCode,
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void visibilityChanged(bool isPublic) {
    debugPrint("MyProfileFolderEditorCubit.visibilityChanged -> $isPublic");

    emit(
      state.copyWith(
        isPublic: isPublic,
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void addSelectedTest(MyProfileFolderSelectedTestEntity test) {
    final alreadyExists = state.selectedTests.any((item) => item.id == test.id);

    if (alreadyExists) {
      debugPrint("✗ test already selected: ${test.id}");
      return;
    }

    emit(
      state.copyWith(
        selectedTests: [...state.selectedTests, test],
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void removeSelectedTest(int testId) {
    emit(
      state.copyWith(
        selectedTests: state.selectedTests
            .where((item) => item.id != testId)
            .toList(),
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void setSelectedTests(List<MyProfileFolderSelectedTestEntity> tests) {
    emit(
      state.copyWith(
        selectedTests: tests,
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  void resetSubmitState() {
    emit(
      state.copyWith(
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  Future<void> createMyProfileFolder() async {
    debugPrint(
      "============ MyProfileFolderEditorCubit.createMyProfileFolder ============",
    );

    final name = state.name.trim();
    final testIds = state.selectedTestIds;

    debugPrint("→ name: $name");
    debugPrint("→ colorCode: ${state.colorCode}");
    debugPrint("→ visibilityType: ${state.visibilityType}");
    debugPrint("→ testIds: $testIds");

    if (state.isSubmitLoading) {
      debugPrint("✗ submit already loading");
      debugPrint("=================================================");
      return;
    }

    if (name.isEmpty) {
      emit(
        state.copyWith(
          submitStatus: MyProfileFolderEditorSubmitStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال اسم المجلد',
        ),
      );
      return;
    }

    if (testIds.isEmpty) {
      emit(
        state.copyWith(
          submitStatus: MyProfileFolderEditorSubmitStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار اختبار واحد على الأقل',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submitStatus: MyProfileFolderEditorSubmitStatus.loading,
        clearError: true,
      ),
    );

    final result = await createMyProfileFolderUseCase(
      CreateMyProfileFolderParams(
        name: name,
        colorCode: state.colorCode,
        visibilityType: state.visibilityType,
        testIds: testIds,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ createMyProfileFolder failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            submitStatus: MyProfileFolderEditorSubmitStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ createMyProfileFolder success");
        debugPrint("→ message: ${response.message}");

        emit(
          state.copyWith(
            submitStatus: MyProfileFolderEditorSubmitStatus.success,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> submitFolderEditor() async {
    if (state.isCreateMode) {
      await createMyProfileFolder();
      return;
    }

    await updateMyProfileFolder();
  }

  Future<void> updateMyProfileFolder() async {
    final folderId = state.folderId;
    final name = state.name.trim();
    final testIds = state.selectedTestIds;

    if (folderId == null) return;

    if (state.isSubmitLoading) return;

    if (name.isEmpty) {
      emit(
        state.copyWith(
          submitStatus: MyProfileFolderEditorSubmitStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى إدخال اسم المجلد',
        ),
      );
      return;
    }

    if (testIds.isEmpty) {
      emit(
        state.copyWith(
          submitStatus: MyProfileFolderEditorSubmitStatus.failure,
          errorTitle: 'تنبيه',
          errorMessage: 'يرجى اختيار اختبار واحد على الأقل',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        submitStatus: MyProfileFolderEditorSubmitStatus.loading,
        clearError: true,
      ),
    );

    final result = await updateMyProfileFolderUseCase(
      UpdateMyProfileFolderParams(
        folderId: folderId,
        name: name,
        colorCode: state.colorCode,
        visibilityType: state.shouldSendVisibilityType
            ? state.visibilityType
            : null,
        testIds: testIds,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            submitStatus: MyProfileFolderEditorSubmitStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            submitStatus: MyProfileFolderEditorSubmitStatus.success,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> fetchFolderTestsForEdit(int folderId) async {
    debugPrint(
      "============ MyProfileFolderEditorCubit.fetchFolderTestsForEdit ============",
    );
    debugPrint("→ folderId: $folderId");

    final result = await fetchMyProfileFolderContentUseCase(
      FetchMyProfileFolderContentParams(folderId: folderId),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchFolderTestsForEdit failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        final selectedTests = response.data
            .map(_mapFolderContentToSelectedTest)
            .toList();

        emit(
          state.copyWith(
            selectedTests: selectedTests,
            originalTestIds: selectedTests.map((e) => e.id).toList(),
            clearError: true,
          ),
        );

        debugPrint("✓ fetchFolderTestsForEdit success");
        debugPrint("→ selectedTests count: ${selectedTests.length}");
      },
    );

    debugPrint("=================================================");
  }

  MyProfileFolderSelectedTestEntity _mapFolderContentToSelectedTest(
    MyProfileFolderContentTestEntity item,
  ) {
    return MyProfileFolderSelectedTestEntity(
      id: item.id,
      title: item.title,
      description: item.description,
      interests: item.interests,
      difficultyLevel: item.difficultyLevel,
      questionCount: item.questionCount,
      averageRating: item.averageRating,
      price: item.price,
      publishedAt: item.publishedAt,
    );
  }

  ///////////////// bottom sheet to get  my tests /////////////
  Future<void> openPicker({required int userId}) async {
    debugPrint(
      "============ MyProfileFolderEditorCubit.openPicker ============",
    );
    debugPrint("→ userId: $userId");

    emit(
      state.copyWith(
        tempSelectedTestIds: state.selectedTestIds,
        selectedPickerTestsTab: MyProfilePickerTestsTab.public,
        pickerTestsStatus: MyProfilePickerTestsStatus.loading,
        pickerTestsLoadMoreStatus: MyProfilePickerTestsLoadMoreStatus.initial,
        clearPickerTestsResponse: true,
        clearError: true,
      ),
    );

    await fetchPickerTestsInitial(userId: userId);

    debugPrint("=================================================");
  }

  Future<void> changePickerTestsTab({
    required int userId,
    required MyProfilePickerTestsTab tab,
  }) async {
    if (state.selectedPickerTestsTab == tab) return;

    debugPrint(
      "============ MyProfileFolderEditorCubit.changePickerTestsTab ============",
    );
    debugPrint("→ from: ${state.selectedPickerTestsTab.apiValue}");
    debugPrint("→ to: ${tab.apiValue}");

    emit(
      state.copyWith(
        selectedPickerTestsTab: tab,
        pickerSearchQuery: '',
        clearPickerSearchResponse: true,
        pickerTestsStatus: MyProfilePickerTestsStatus.loading,
        pickerTestsLoadMoreStatus: MyProfilePickerTestsLoadMoreStatus.initial,
        clearPickerTestsResponse: true,
        clearError: true,
      ),
    );

    await fetchPickerTestsInitial(userId: userId);

    debugPrint("=================================================");
  }

  Future<void> fetchPickerTestsInitial({required int userId}) async {
    debugPrint(
      "============ MyProfileFolderEditorCubit.fetchPickerTestsInitial ============",
    );
    debugPrint(
      "→ params: {userId: $userId, tab: ${state.selectedPickerTestsTab.apiValue}}",
    );

    emit(
      state.copyWith(
        pickerTestsStatus: MyProfilePickerTestsStatus.loading,
        pickerTestsLoadMoreStatus: MyProfilePickerTestsLoadMoreStatus.initial,
        clearPickerTestsResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchMyProfilePickerTestsUseCase(
      FetchMyProfilePickerTestsParams(
        userId: userId,
        tab: state.selectedPickerTestsTab.apiValue,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchPickerTestsInitial failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            pickerTestsStatus: MyProfilePickerTestsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        debugPrint("✓ fetchPickerTestsInitial success");
        debugPrint("→ tests count: ${response.data.length}");
        debugPrint("→ hasMorePages: ${response.meta.hasMorePages}");
        debugPrint("→ nextCursor: ${response.meta.nextCursor}");

        emit(
          state.copyWith(
            pickerTestsStatus: MyProfilePickerTestsStatus.success,
            pickerTestsResponse: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMorePickerTestsIfNeeded({required int userId}) async {
    final response = state.pickerTestsResponse;

    if (state.isPickerTestsLoading ||
        state.isPickerTestsLoadingMore ||
        response == null ||
        !response.meta.hasMorePages) {
      return;
    }

    final cursor = response.meta.nextCursor;
    if (cursor == null || cursor.trim().isEmpty) return;

    debugPrint(
      "============ MyProfileFolderEditorCubit.fetchMorePickerTestsIfNeeded ============",
    );
    debugPrint("→ tab: ${state.selectedPickerTestsTab.apiValue}");
    debugPrint("→ cursor: $cursor");

    emit(
      state.copyWith(
        pickerTestsLoadMoreStatus: MyProfilePickerTestsLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchMyProfilePickerTestsUseCase(
      FetchMyProfilePickerTestsParams(
        userId: userId,
        tab: state.selectedPickerTestsTab.apiValue,
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) {
        debugPrint("✗ fetchMorePickerTestsIfNeeded failure");
        debugPrint("→ title: ${failure.title}");
        debugPrint("→ message: ${failure.message}");

        emit(
          state.copyWith(
            pickerTestsLoadMoreStatus:
                MyProfilePickerTestsLoadMoreStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final updatedResponse = MyProfilePickerTestsEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...response.data, ...newResponse.data],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        debugPrint("✓ fetchMorePickerTestsIfNeeded success");
        debugPrint("→ old count: ${response.data.length}");
        debugPrint("→ new count: ${newResponse.data.length}");
        debugPrint("→ total count: ${updatedResponse.data.length}");

        emit(
          state.copyWith(
            pickerTestsLoadMoreStatus:
                MyProfilePickerTestsLoadMoreStatus.success,
            pickerTestsResponse: updatedResponse,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  void togglePickerTestSelection(int testId) {
    final selectedIds = List<int>.from(state.tempSelectedTestIds);

    if (selectedIds.contains(testId)) {
      selectedIds.remove(testId);
    } else {
      if (selectedIds.length >= 10) {
        emit(
          state.copyWith(
            errorTitle: 'تنبيه',
            errorMessage: 'يمكنك اختيار 10 اختبارات كحد أقصى',
          ),
        );
        return;
      }

      selectedIds.add(testId);
    }

    emit(state.copyWith(tempSelectedTestIds: selectedIds, clearError: true));
  }

  void applyPickerSelection() {
    final tests = state.pickerTestsResponse?.data ?? [];

    final selectedFromCurrentLoadedTests = tests
        .where((item) => state.tempSelectedTestIds.contains(item.id))
        .map(_mapPickerTestToSelectedTest)
        .toList();

    final oldSelectedStillKept = state.selectedTests
        .where((item) => state.tempSelectedTestIds.contains(item.id))
        .toList();

    final merged = [
      ...oldSelectedStillKept,
      ...selectedFromCurrentLoadedTests.where(
        (newItem) => !oldSelectedStillKept.any((old) => old.id == newItem.id),
      ),
    ];

    emit(
      state.copyWith(
        selectedTests: merged,
        submitStatus: MyProfileFolderEditorSubmitStatus.initial,
        clearError: true,
      ),
    );
  }

  MyProfileFolderSelectedTestEntity _mapPickerTestToSelectedTest(
    MyProfilePickerTestItemEntity item,
  ) {
    return MyProfileFolderSelectedTestEntity(
      id: item.id,
      title: item.title,
      description: item.description,
      interests: item.interestNames,
      difficultyLevel: item.targetLevel,
      questionCount: item.questionCount,
      averageRating: item.averageRating,
      price: item.price,
      publishedAt: item.publishedAt,
    );
  }

  void changePickerSearchQuery({required int userId, required String value}) {
    final query = value.trim();

    emit(state.copyWith(pickerSearchQuery: value, clearError: true));

    _pickerSearchDebounce?.cancel();

    _pickerSearchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (query.isEmpty) {
        emit(
          state.copyWith(
            clearPickerSearchResponse: true,
            pickerTestsStatus: MyProfilePickerTestsStatus.loading,
            clearError: true,
          ),
        );

        fetchPickerTestsInitial(userId: userId);
        return;
      }

      fetchPickerSearchInitial(query: query);
    });
  }

  Future<void> fetchPickerSearchInitial({required String query}) async {
    debugPrint(
      "============ MyProfileFolderEditorCubit.fetchPickerSearchInitial ============",
    );
    debugPrint("→ query: $query");

    emit(
      state.copyWith(
        pickerTestsStatus: MyProfilePickerTestsStatus.loading,
        pickerTestsLoadMoreStatus: MyProfilePickerTestsLoadMoreStatus.initial,
        clearPickerTestsResponse: true,
        clearPickerSearchResponse: true,
        clearError: true,
      ),
    );

    final result = await fetchMyProfilePickerSearchTestsUseCase(
      FetchMyProfilePickerSearchTestsParams(query: query, page: 1),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            pickerTestsStatus: MyProfilePickerTestsStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            pickerTestsStatus: MyProfilePickerTestsStatus.success,
            pickerSearchResponse: response,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  Future<void> fetchMorePickerSearchIfNeeded() async {
    final query = state.pickerSearchQuery.trim();
    final response = state.pickerSearchResponse;

    if (query.isEmpty ||
        state.isPickerTestsLoading ||
        state.isPickerTestsLoadingMore ||
        response == null ||
        !response.meta.hasMorePages) {
      return;
    }

    final nextPage = response.meta.nextPage;

    debugPrint(
      "============ MyProfileFolderEditorCubit.fetchMorePickerSearchIfNeeded ============",
    );
    debugPrint("→ query: $query");
    debugPrint("→ nextPage: $nextPage");

    emit(
      state.copyWith(
        pickerTestsLoadMoreStatus: MyProfilePickerTestsLoadMoreStatus.loading,
        clearError: true,
      ),
    );

    final result = await fetchMyProfilePickerSearchTestsUseCase(
      FetchMyProfilePickerSearchTestsParams(query: query, page: nextPage),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            pickerTestsLoadMoreStatus:
                MyProfilePickerTestsLoadMoreStatus.failure,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (newResponse) {
        final updatedResponse = MyProfilePickerSearchTestsEntity(
          success: newResponse.success,
          message: newResponse.message,
          data: [...response.data, ...newResponse.data],
          meta: newResponse.meta,
          statusCode: newResponse.statusCode,
        );

        emit(
          state.copyWith(
            pickerTestsLoadMoreStatus:
                MyProfilePickerTestsLoadMoreStatus.success,
            pickerSearchResponse: updatedResponse,
            clearError: true,
          ),
        );
      },
    );

    debugPrint("=================================================");
  }

  @override
  Future<void> close() {
    _pickerSearchDebounce?.cancel();
    return super.close();
  }
}
