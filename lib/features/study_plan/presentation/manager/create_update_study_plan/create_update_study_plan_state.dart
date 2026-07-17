import 'package:quiz_app_grad/features/study_plan/domain/entities/subjects/study_subject_entity.dart';

enum StudyPlanFormMode { create, update }

enum CreateUpdateStudyPlanSubjectsStatus { initial, loading, success, failure }

enum CreateUpdateStudyPlanSubmitStatus { initial, loading, success, failure }

class CreateUpdateStudyPlanState {
  static const int maxSelectedSubjects = 10;
  static const int titleMaxLength = 100;

  final StudyPlanFormMode mode;
  final int? planId;

  final String title;
  final String emoji;

  final DateTime? startDate;
  final DateTime? endDate;

  final List<StudySubjectEntity> availableSubjects;
  final Set<int> selectedSubjectIds;

  final int dailyStudyHours;
  final bool isDefault;

  final CreateUpdateStudyPlanSubjectsStatus subjectsStatus;
  final CreateUpdateStudyPlanSubmitStatus submitStatus;

  final String? actionMessage;
  final String? errorTitle;
  final String? errorMessage;

  const CreateUpdateStudyPlanState({
    this.mode = StudyPlanFormMode.create,
    this.planId,
    this.title = '',
    this.emoji = '',
    this.startDate,
    this.endDate,
    this.availableSubjects = const [],
    this.selectedSubjectIds = const {},
    this.dailyStudyHours = 0,
    this.isDefault = false,
    this.subjectsStatus = CreateUpdateStudyPlanSubjectsStatus.initial,
    this.submitStatus = CreateUpdateStudyPlanSubmitStatus.initial,
    this.actionMessage,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isCreateMode => mode == StudyPlanFormMode.create;

  bool get isUpdateMode => mode == StudyPlanFormMode.update;

  bool get isSubjectsInitial =>
      subjectsStatus == CreateUpdateStudyPlanSubjectsStatus.initial;

  bool get isSubjectsLoading =>
      subjectsStatus == CreateUpdateStudyPlanSubjectsStatus.loading;

  bool get isSubjectsSuccess =>
      subjectsStatus == CreateUpdateStudyPlanSubjectsStatus.success;

  bool get isSubjectsFailure =>
      subjectsStatus == CreateUpdateStudyPlanSubjectsStatus.failure;

  bool get isSubmitLoading =>
      submitStatus == CreateUpdateStudyPlanSubmitStatus.loading;

  bool get isSubmitSuccess =>
      submitStatus == CreateUpdateStudyPlanSubmitStatus.success;

  bool get isSubmitFailure =>
      submitStatus == CreateUpdateStudyPlanSubmitStatus.failure;

  bool get hasAvailableSubjects => availableSubjects.isNotEmpty;

  int get selectedSubjectsCount => selectedSubjectIds.length;

  bool get hasSelectedSubjects => selectedSubjectIds.isNotEmpty;

  bool get reachedSubjectsLimit => selectedSubjectsCount >= maxSelectedSubjects;

  bool isSubjectSelected(int subjectId) {
    return selectedSubjectIds.contains(subjectId);
  }

  List<int> get selectedSubjectIdsList {
    return selectedSubjectIds.toList();
  }

  bool get hasValidTitle {
    final normalizedTitle = title.trim();

    return normalizedTitle.isNotEmpty &&
        normalizedTitle.length <= titleMaxLength;
  }

  bool get hasValidEmoji => emoji.trim().isNotEmpty;

  bool get hasValidDates {
    if (startDate == null || endDate == null) {
      return false;
    }

    return !endDate!.isBefore(startDate!);
  }

  bool get hasValidDailyStudyTime =>
      dailyStudyHours >= 1 && dailyStudyHours <= 10;

  bool get canSubmit {
    return hasValidTitle &&
        hasValidEmoji &&
        hasValidDates &&
        hasSelectedSubjects &&
        hasValidDailyStudyTime &&
        !isSubmitLoading;
  }

  CreateUpdateStudyPlanState copyWith({
    StudyPlanFormMode? mode,
    int? planId,
    String? title,
    String? emoji,
    DateTime? startDate,
    DateTime? endDate,
    List<StudySubjectEntity>? availableSubjects,
    Set<int>? selectedSubjectIds,
    int? dailyStudyHours,
    bool? isDefault,
    CreateUpdateStudyPlanSubjectsStatus? subjectsStatus,
    CreateUpdateStudyPlanSubmitStatus? submitStatus,
    String? actionMessage,
    String? errorTitle,
    String? errorMessage,
    bool clearPlanId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearActionMessage = false,
    bool clearError = false,
  }) {
    return CreateUpdateStudyPlanState(
      mode: mode ?? this.mode,
      planId: clearPlanId ? null : planId ?? this.planId,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      availableSubjects: availableSubjects ?? this.availableSubjects,
      selectedSubjectIds: selectedSubjectIds ?? this.selectedSubjectIds,
      dailyStudyHours: dailyStudyHours ?? this.dailyStudyHours,
      isDefault: isDefault ?? this.isDefault,
      subjectsStatus: subjectsStatus ?? this.subjectsStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
