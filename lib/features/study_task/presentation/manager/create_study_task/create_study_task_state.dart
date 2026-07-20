
import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/create_study_task_params.dart';

enum CreateStudyTaskSubjectsStatus { initial, loading, success, failure }

enum CreateStudyTaskSubmitStatus { initial, loading, success, failure }

class CreateStudyTaskState {
  // =========================================================
  // CONSTANTS
  // =========================================================

  static const int titleMaxLength = 100;

  static const int descriptionMaxLength = 1000;

  static const int subtaskTitleMaxLength = 200;

  static const int maxSubtasksCount = 20;

  static const int minDurationMinutes = 10;

  static const int maxDurationMinutes = 720;

  static const int maxTaskRangeDays = 7;

  static const Set<int> allowedReminderOffsetMinutes = {
    0,
    5,
    15,
    30,
    45,
    60,
    120,
    240,
    720,
    1440,
    2880,
    10080,
  };

  // =========================================================
  // FIELDS
  // =========================================================

  final int planId;

  final String title;
  final String description;

  final List<StudyPlanSubjectEntity> availableSubjects;
  final int? selectedStudyPlanSubjectId;

  final DateTime? startDate;
  final DateTime? endDate;

  final String startTime;
  final int? durationMinutes;

  final StudyTaskPriority? priority;

  final List<String> subtasks;

  final StudyTaskRepeatPattern repeatPattern;
  final int? repeatWeekday;

  final int? reminderOffsetMinutes;

  final CreateStudyTaskSubjectsStatus subjectsStatus;
  final CreateStudyTaskSubmitStatus submitStatus;

  final String? actionMessage;
  final String? errorTitle;
  final String? errorMessage;

  const CreateStudyTaskState({
    this.planId = 0,
    this.title = '',
    this.description = '',
    this.availableSubjects = const [],
    this.selectedStudyPlanSubjectId,
    this.startDate,
    this.endDate,
    this.startTime = '',
    this.durationMinutes,
    this.priority,
    this.subtasks = const [''],
    this.repeatPattern = StudyTaskRepeatPattern.none,
    this.repeatWeekday,
    this.reminderOffsetMinutes,
    this.subjectsStatus = CreateStudyTaskSubjectsStatus.initial,
    this.submitStatus = CreateStudyTaskSubmitStatus.initial,
    this.actionMessage,
    this.errorTitle,
    this.errorMessage,
  });

  // =========================================================
  // SUBJECTS STATUS
  // =========================================================

  bool get isSubjectsInitial {
    return subjectsStatus == CreateStudyTaskSubjectsStatus.initial;
  }

  bool get isSubjectsLoading {
    return subjectsStatus == CreateStudyTaskSubjectsStatus.loading;
  }

  bool get isSubjectsSuccess {
    return subjectsStatus == CreateStudyTaskSubjectsStatus.success;
  }

  bool get isSubjectsFailure {
    return subjectsStatus == CreateStudyTaskSubjectsStatus.failure;
  }

  // =========================================================
  // SUBMIT STATUS
  // =========================================================

  bool get isSubmitInitial {
    return submitStatus == CreateStudyTaskSubmitStatus.initial;
  }

  bool get isSubmitLoading {
    return submitStatus == CreateStudyTaskSubmitStatus.loading;
  }

  bool get isSubmitSuccess {
    return submitStatus == CreateStudyTaskSubmitStatus.success;
  }

  bool get isSubmitFailure {
    return submitStatus == CreateStudyTaskSubmitStatus.failure;
  }

  // =========================================================
  // PLAN
  // =========================================================

  bool get hasValidPlanId {
    return planId > 0;
  }

  // =========================================================
  // TITLE
  // =========================================================

  String get normalizedTitle {
    return title.trim();
  }

  bool get hasValidTitle {
    return normalizedTitle.isNotEmpty &&
        normalizedTitle.length <= titleMaxLength;
  }

  // =========================================================
  // DESCRIPTION
  // =========================================================

  String get normalizedDescription {
    return description.trim();
  }

  bool get hasValidDescription {
    return normalizedDescription.isNotEmpty &&
        normalizedDescription.length <= descriptionMaxLength;
  }

  // =========================================================
  // SUBJECTS
  // =========================================================

  bool get hasAvailableSubjects {
    return availableSubjects.isNotEmpty;
  }

  bool get hasSelectedSubject {
    final subjectId = selectedStudyPlanSubjectId;

    if (subjectId == null || subjectId <= 0) {
      return false;
    }

    return availableSubjects.any((subject) => subject.id == subjectId);
  }

  StudyPlanSubjectEntity? get selectedSubject {
    final subjectId = selectedStudyPlanSubjectId;

    if (subjectId == null) {
      return null;
    }

    for (final subject in availableSubjects) {
      if (subject.id == subjectId) {
        return subject;
      }
    }

    return null;
  }

  bool isSubjectSelected(int studyPlanSubjectId) {
    return selectedStudyPlanSubjectId == studyPlanSubjectId;
  }

  // =========================================================
  // DATES
  // =========================================================

  bool get hasStartDate {
    return startDate != null;
  }

  bool get hasEndDate {
    return endDate != null;
  }

  DateTime? get normalizedStartDate {
    final value = startDate;

    if (value == null) {
      return null;
    }

    return _normalizeDate(value);
  }

  DateTime? get normalizedEndDate {
    final value = endDate;

    if (value == null) {
      return null;
    }

    return _normalizeDate(value);
  }

  bool get isStartDateTodayOrFuture {
    final start = normalizedStartDate;

    if (start == null) {
      return false;
    }

    final today = _normalizeDate(DateTime.now());

    return !start.isBefore(today);
  }

  bool get isEndDateAfterOrEqualStartDate {
    final start = normalizedStartDate;
    final end = normalizedEndDate;

    if (start == null || end == null) {
      return false;
    }

    return !end.isBefore(start);
  }

  int get taskRangeDays {
    final start = normalizedStartDate;
    final end = normalizedEndDate;

    if (start == null || end == null || end.isBefore(start)) {
      return 0;
    }

    return end.difference(start).inDays + 1;
  }

  bool get isTaskRangeWithinLimit {
    return taskRangeDays >= 1 && taskRangeDays <= maxTaskRangeDays;
  }

  bool get hasValidDates {
    return hasStartDate &&
        hasEndDate &&
        isStartDateTodayOrFuture &&
        isEndDateAfterOrEqualStartDate &&
        isTaskRangeWithinLimit;
  }

  // =========================================================
  // START TIME
  // =========================================================

  String get normalizedStartTime {
    return startTime.trim();
  }

  bool get hasValidStartTime {
    return RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(normalizedStartTime);
  }

  // =========================================================
  // DURATION
  // =========================================================

  bool get hasValidDuration {
    final value = durationMinutes;

    return value != null &&
        value >= minDurationMinutes &&
        value <= maxDurationMinutes;
  }

  // =========================================================
  // PRIORITY
  // =========================================================

  bool get hasValidPriority {
    return priority != null;
  }

  // =========================================================
  // SUBTASKS
  // =========================================================

  int get subtaskFieldsCount {
    return subtasks.length;
  }

  List<String> get validSubtaskTitles {
    return subtasks
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  /*
   * هذا العداد يمثل المهام المكتوبة فعليًا،
   * وليس عدد حقول الإدخال الظاهرة.
   */
  int get subtasksCount {
    return validSubtaskTitles.length;
  }

  bool get hasValidSubtasksCount {
    return subtaskFieldsCount <= maxSubtasksCount;
  }

  bool get reachedSubtasksLimit {
    return subtaskFieldsCount >= maxSubtasksCount;
  }

  bool get canAddSubtask {
    return !reachedSubtasksLimit;
  }

  bool get canRemoveSubtask {
    return subtaskFieldsCount > 1;
  }

  bool get haveValidSubtaskLengths {
    return subtasks.every((item) {
      final normalizedTitle = item.trim();

      return normalizedTitle.isEmpty ||
          normalizedTitle.length <= subtaskTitleMaxLength;
    });
  }

  bool get haveValidSubtasks {
    return hasValidSubtasksCount && haveValidSubtaskLengths;
  }

  List<CreateStudyTaskSubtaskParams> get subtaskParams {
    return validSubtaskTitles
        .map((title) => CreateStudyTaskSubtaskParams(title: title))
        .toList(growable: false);
  }

  // =========================================================
  // REPEAT
  // =========================================================

  bool get isRepeating {
    return repeatPattern != StudyTaskRepeatPattern.none;
  }

  bool get hasValidRepeatWeekday {
    if (!isRepeating) {
      /*
       * عند عدم وجود تكرار يجب ألا يبقى
       * يوم تكرار محفوظ في الحالة.
       */
      return repeatWeekday == null;
    }

    final weekday = repeatWeekday;

    return weekday != null && weekday >= 0 && weekday <= 6;
  }

  // =========================================================
  // REMINDER
  // =========================================================

  bool get hasValidReminder {
    final value = reminderOffsetMinutes;

    return value == null || allowedReminderOffsetMinutes.contains(value);
  }

  // =========================================================
  // FORM
  // =========================================================

  bool get canSubmit {
    return hasValidPlanId &&
        isSubjectsSuccess &&
        hasAvailableSubjects &&
        hasValidTitle &&
        hasValidDescription &&
        hasSelectedSubject &&
        hasValidDates &&
        hasValidStartTime &&
        hasValidDuration &&
        hasValidPriority &&
        haveValidSubtasks &&
        hasValidRepeatWeekday &&
        hasValidReminder &&
        !isSubmitLoading;
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  CreateStudyTaskState copyWith({
    int? planId,
    String? title,
    String? description,
    List<StudyPlanSubjectEntity>? availableSubjects,
    int? selectedStudyPlanSubjectId,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    int? durationMinutes,
    StudyTaskPriority? priority,
    List<String>? subtasks,
    StudyTaskRepeatPattern? repeatPattern,
    int? repeatWeekday,
    int? reminderOffsetMinutes,
    CreateStudyTaskSubjectsStatus? subjectsStatus,
    CreateStudyTaskSubmitStatus? submitStatus,
    String? actionMessage,
    String? errorTitle,
    String? errorMessage,
    bool clearSelectedStudyPlanSubjectId = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearDuration = false,
    bool clearPriority = false,
    bool clearRepeatWeekday = false,
    bool clearReminder = false,
    bool clearActionMessage = false,
    bool clearError = false,
  }) {
    return CreateStudyTaskState(
      planId: planId ?? this.planId,
      title: title ?? this.title,
      description: description ?? this.description,
      availableSubjects: availableSubjects ?? this.availableSubjects,
      selectedStudyPlanSubjectId: clearSelectedStudyPlanSubjectId
          ? null
          : selectedStudyPlanSubjectId ?? this.selectedStudyPlanSubjectId,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      durationMinutes: clearDuration
          ? null
          : durationMinutes ?? this.durationMinutes,
      priority: clearPriority ? null : priority ?? this.priority,
      subtasks: subtasks ?? this.subtasks,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      repeatWeekday: clearRepeatWeekday
          ? null
          : repeatWeekday ?? this.repeatWeekday,
      reminderOffsetMinutes: clearReminder
          ? null
          : reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      subjectsStatus: subjectsStatus ?? this.subjectsStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================

  static DateTime _normalizeDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  // =========================================================
  // TO STRING
  // =========================================================

  @override
  String toString() {
    return 'CreateStudyTaskState('
        'planId: $planId, '
        'title: $title, '
        'availableSubjectsCount: ${availableSubjects.length}, '
        'selectedStudyPlanSubjectId: $selectedStudyPlanSubjectId, '
        'startDate: $startDate, '
        'endDate: $endDate, '
        'taskRangeDays: $taskRangeDays, '
        'startTime: $startTime, '
        'durationMinutes: $durationMinutes, '
        'priority: $priority, '
        'subtaskFieldsCount: $subtaskFieldsCount, '
        'subtasksCount: $subtasksCount, '
        'repeatPattern: $repeatPattern, '
        'repeatWeekday: $repeatWeekday, '
        'reminderOffsetMinutes: $reminderOffsetMinutes, '
        'subjectsStatus: $subjectsStatus, '
        'submitStatus: $submitStatus, '
        'canSubmit: $canSubmit'
        ')';
  }
}
