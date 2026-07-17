import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';

enum StudySubjectsLoadStatus {
  initial,
  loading,
  success,
  failure,
}

enum CreateStudySubjectStatus {
  initial,
  loading,
  success,
  failure,
}

enum DeleteStudySubjectStatus {
  initial,
  loading,
  success,
  failure,
}

class StudySubjectsState {
  final List<StudySubjectEntity> subjects;

  final String draftName;

  final StudySubjectsLoadStatus loadStatus;
  final CreateStudySubjectStatus createStatus;
  final DeleteStudySubjectStatus deleteStatus;

  final int? deletingSubjectId;

  final String? actionMessage;
  final String? errorTitle;
  final String? errorMessage;

  const StudySubjectsState({
    this.subjects = const [],
    this.draftName = '',
    this.loadStatus = StudySubjectsLoadStatus.initial,
    this.createStatus = CreateStudySubjectStatus.initial,
    this.deleteStatus = DeleteStudySubjectStatus.initial,
    this.deletingSubjectId,
    this.actionMessage,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isInitial =>
      loadStatus == StudySubjectsLoadStatus.initial;

  bool get isLoading =>
      loadStatus == StudySubjectsLoadStatus.loading;

  bool get isLoadSuccess =>
      loadStatus == StudySubjectsLoadStatus.success;

  bool get isLoadFailure =>
      loadStatus == StudySubjectsLoadStatus.failure;

  bool get isCreateLoading =>
      createStatus == CreateStudySubjectStatus.loading;

  bool get isCreateSuccess =>
      createStatus == CreateStudySubjectStatus.success;

  bool get isCreateFailure =>
      createStatus == CreateStudySubjectStatus.failure;

  bool get isDeleteLoading =>
      deleteStatus == DeleteStudySubjectStatus.loading;

  bool get isDeleteSuccess =>
      deleteStatus == DeleteStudySubjectStatus.success;

  bool get isDeleteFailure =>
      deleteStatus == DeleteStudySubjectStatus.failure;

  bool get hasSubjects => subjects.isNotEmpty;

  bool get hasNoSubjects => subjects.isEmpty;

  bool get hasValidDraftName {
    final normalizedName = draftName.trim();

    return normalizedName.isNotEmpty &&
        normalizedName.length <= 50;
  }

  bool get canCreateSubject =>
      hasValidDraftName && !isCreateLoading;

  bool isDeletingSubject(int subjectId) {
    return isDeleteLoading &&
        deletingSubjectId == subjectId;
  }

  StudySubjectsState copyWith({
    List<StudySubjectEntity>? subjects,
    String? draftName,
    StudySubjectsLoadStatus? loadStatus,
    CreateStudySubjectStatus? createStatus,
    DeleteStudySubjectStatus? deleteStatus,
    int? deletingSubjectId,
    String? actionMessage,
    String? errorTitle,
    String? errorMessage,
    bool clearDeletingSubjectId = false,
    bool clearActionMessage = false,
    bool clearError = false,
  }) {
    return StudySubjectsState(
      subjects: subjects ?? this.subjects,
      draftName: draftName ?? this.draftName,
      loadStatus: loadStatus ?? this.loadStatus,
      createStatus: createStatus ?? this.createStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      deletingSubjectId: clearDeletingSubjectId
          ? null
          : deletingSubjectId ?? this.deletingSubjectId,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
      errorTitle: clearError
          ? null
          : errorTitle ?? this.errorTitle,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}