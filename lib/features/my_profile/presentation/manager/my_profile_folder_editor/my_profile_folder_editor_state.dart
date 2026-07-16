import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_folder_selected_test_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';

enum MyProfileFolderEditorMode { create, edit }

enum MyProfileFolderEditorSubmitStatus { initial, loading, success, failure }

enum MyProfilePickerTestsStatus { initial, loading, success, failure }

enum MyProfilePickerTestsLoadMoreStatus { initial, loading, success, failure }

enum MyProfilePickerTestsTab { public, private, paid }

extension MyProfilePickerTestsTabX on MyProfilePickerTestsTab {
  String get apiValue {
    switch (this) {
      case MyProfilePickerTestsTab.public:
        return 'public';
      case MyProfilePickerTestsTab.private:
        return 'private';
      case MyProfilePickerTestsTab.paid:
        return 'paid';
    }
  }

  String get title {
    switch (this) {
      case MyProfilePickerTestsTab.public:
        return 'عامة';
      case MyProfilePickerTestsTab.private:
        return 'خاصة';
      case MyProfilePickerTestsTab.paid:
        return 'مدفوعة';
    }
  }
}

class MyProfileFolderEditorState {
  final MyProfileFolderEditorMode mode;

  final int? folderId;
  final String name;
  final String colorCode;
  final bool isPublic;
  final List<MyProfileFolderSelectedTestEntity> selectedTests;

  final String? originalName;
  final String? originalColorCode;
  final bool originalIsPublic;
  final List<int> originalTestIds;

  final MyProfileFolderEditorSubmitStatus submitStatus;
  final String? errorTitle;
  final String? errorMessage;

  final MyProfilePickerTestsTab selectedPickerTestsTab;
  final MyProfilePickerTestsStatus pickerTestsStatus;
  final MyProfilePickerTestsLoadMoreStatus pickerTestsLoadMoreStatus;
  final MyProfilePickerTestsEntity? pickerTestsResponse;
  final List<int> tempSelectedTestIds;

  final String pickerSearchQuery;
  final MyProfilePickerSearchTestsEntity? pickerSearchResponse;

  const MyProfileFolderEditorState({
    this.mode = MyProfileFolderEditorMode.create,
    this.folderId,
    this.name = '',
    this.colorCode = '#5582FF',
    this.isPublic = false,
    this.selectedTests = const [],
    this.originalName,
    this.originalColorCode,
    this.originalIsPublic = false,
    this.originalTestIds = const [],
    this.submitStatus = MyProfileFolderEditorSubmitStatus.initial,
    this.errorTitle,
    this.errorMessage,

    this.selectedPickerTestsTab = MyProfilePickerTestsTab.public,
    this.pickerTestsStatus = MyProfilePickerTestsStatus.initial,
    this.pickerTestsLoadMoreStatus = MyProfilePickerTestsLoadMoreStatus.initial,
    this.pickerTestsResponse,
    this.tempSelectedTestIds = const [],

    this.pickerSearchQuery = '',
    this.pickerSearchResponse,
  });

  bool get isCreateMode => mode == MyProfileFolderEditorMode.create;
  bool get isEditMode => mode == MyProfileFolderEditorMode.edit;

  String get pageTitle => isCreateMode ? 'مجلد جديد' : 'تعديل معلومات مجلد';

  String get submitButtonTitle => isCreateMode ? 'حفظ المجلد' : 'حفظ التعديلات';

  String get visibilityType => isPublic ? 'عام' : 'خاص';

  List<int> get selectedTestIds =>
      selectedTests.map((item) => item.id).toList();

  bool get isSubmitLoading =>
      submitStatus == MyProfileFolderEditorSubmitStatus.loading;

  bool get isSubmitSuccess =>
      submitStatus == MyProfileFolderEditorSubmitStatus.success;

  bool get isSubmitFailure =>
      submitStatus == MyProfileFolderEditorSubmitStatus.failure;

  bool get canSubmit {
    return name.trim().isNotEmpty && selectedTests.isNotEmpty;
  }

  bool get hasChanges {
    if (isCreateMode) {
      return name.trim().isNotEmpty ||
          selectedTests.isNotEmpty ||
          colorCode != '#5582FF' ||
          isPublic != false;
    }

    final currentTestIds = selectedTestIds;

    final sameTests =
        currentTestIds.length == originalTestIds.length &&
        currentTestIds.every(originalTestIds.contains);

    return name.trim() != (originalName ?? '').trim() ||
        colorCode != originalColorCode ||
        isPublic != originalIsPublic ||
        !sameTests;
  }

  bool get isPickerTestsLoading =>
      pickerTestsStatus == MyProfilePickerTestsStatus.loading;
  bool get isPickerTestsFailure =>
      pickerTestsStatus == MyProfilePickerTestsStatus.failure;
  bool get isPickerTestsSuccess =>
      pickerTestsStatus == MyProfilePickerTestsStatus.success;
  bool get isPickerTestsLoadingMore =>
      pickerTestsLoadMoreStatus == MyProfilePickerTestsLoadMoreStatus.loading;
  bool get hasMorePickerTestsPages =>
      pickerTestsResponse?.meta.hasMorePages ?? false;
  String? get nextPickerTestsCursor => pickerTestsResponse?.meta.nextCursor;
  int get pickerSelectedCount => tempSelectedTestIds.length;
  bool get canSavePickerSelection => tempSelectedTestIds.isNotEmpty;

  bool get hasPickerSearchQuery => pickerSearchQuery.trim().isNotEmpty;
  bool get hasMorePickerSearchPages =>
      pickerSearchResponse?.meta.hasMorePages ?? false;
  int get nextPickerSearchPage => pickerSearchResponse?.meta.nextPage ?? 1;

  bool get shouldSendVisibilityType {
    if (isCreateMode) return true;

    return (originalIsPublic ?? false) != isPublic;
  }

  MyProfileFolderEditorState copyWith({
    MyProfileFolderEditorMode? mode,
    int? folderId,
    String? name,
    String? colorCode,
    bool? isPublic,
    List<MyProfileFolderSelectedTestEntity>? selectedTests,
    String? originalName,
    String? originalColorCode,
    bool? originalIsPublic,
    List<int>? originalTestIds,
    MyProfileFolderEditorSubmitStatus? submitStatus,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,

    MyProfilePickerTestsTab? selectedPickerTestsTab,
    MyProfilePickerTestsStatus? pickerTestsStatus,
    MyProfilePickerTestsLoadMoreStatus? pickerTestsLoadMoreStatus,
    MyProfilePickerTestsEntity? pickerTestsResponse,
    List<int>? tempSelectedTestIds,
    bool clearPickerTestsResponse = false,

    String? pickerSearchQuery,
    MyProfilePickerSearchTestsEntity? pickerSearchResponse,
    bool clearPickerSearchResponse = false,
  }) {
    return MyProfileFolderEditorState(
      mode: mode ?? this.mode,
      folderId: folderId ?? this.folderId,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      isPublic: isPublic ?? this.isPublic,
      selectedTests: selectedTests ?? this.selectedTests,
      originalName: originalName ?? this.originalName,
      originalColorCode: originalColorCode ?? this.originalColorCode,
      originalIsPublic: originalIsPublic ?? this.originalIsPublic,
      originalTestIds: originalTestIds ?? this.originalTestIds,
      submitStatus: submitStatus ?? this.submitStatus,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      selectedPickerTestsTab:
          selectedPickerTestsTab ?? this.selectedPickerTestsTab,
      pickerTestsStatus: pickerTestsStatus ?? this.pickerTestsStatus,
      pickerTestsLoadMoreStatus:
          pickerTestsLoadMoreStatus ?? this.pickerTestsLoadMoreStatus,
      pickerTestsResponse: clearPickerTestsResponse
          ? null
          : pickerTestsResponse ?? this.pickerTestsResponse,
      tempSelectedTestIds: tempSelectedTestIds ?? this.tempSelectedTestIds,

      pickerSearchQuery: pickerSearchQuery ?? this.pickerSearchQuery,
      pickerSearchResponse: clearPickerSearchResponse
          ? null
          : pickerSearchResponse ?? this.pickerSearchResponse,
    );
  }
}
