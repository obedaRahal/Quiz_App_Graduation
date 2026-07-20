import 'package:quiz_app_grad/features/study_task/domain/entities/study_plan_subjects_response_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';

// =========================================================
// STATUSES
// =========================================================

enum UpdateStudyTaskInitialDataStatus { initial, loading, success, failure }

enum UpdateStudyTaskSubmitStatus { initial, loading, success, failure }

// =========================================================
// SUBTASK STATE
// =========================================================

class UpdateStudyTaskSubtaskState {
  final int? id;
  final String title;
  final bool isCompleted;

  const UpdateStudyTaskSubtaskState({
    this.id,
    this.title = '',
    this.isCompleted = false,
  });

  String get normalizedTitle => title.trim();

  bool get isNew => id == null;

  bool get isExisting => id != null;

  bool get hasValidId {
    final value = id;

    return value == null || value > 0;
  }

  bool get hasValidTitle {
    return normalizedTitle.isNotEmpty;
  }

  bool get isEmptyNewSubtask {
    return id == null && normalizedTitle.isEmpty;
  }

  bool get isValid {
    return hasValidId && hasValidTitle;
  }

  UpdateStudyTaskSubtaskState copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    bool clearId = false,
  }) {
    return UpdateStudyTaskSubtaskState(
      id: clearId ? null : id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'UpdateStudyTaskSubtaskState('
        'id: $id, '
        'title: $normalizedTitle, '
        'isCompleted: $isCompleted'
        ')';
  }
}

// =========================================================
// UPDATE STUDY TASK STATE
// =========================================================

class UpdateStudyTaskState {
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
  // IDS
  // =========================================================

  final int? planId;
  final int? taskId;

  // =========================================================
  // CURRENT FORM VALUES
  // =========================================================

  final String title;
  final String description;

  final List<StudyPlanSubjectEntity> availableSubjects;
  final int? selectedStudyPlanSubjectId;

  final DateTime? startDate;
  final DateTime? endDate;

  final String startTime;
  final int? durationMinutes;

  final StudyTaskPriority? priority;

  final List<UpdateStudyTaskSubtaskState> subtasks;

  final StudyTaskRepeatPattern repeatPattern;
  final int? repeatWeekday;

  final int? reminderOffsetMinutes;

  // =========================================================
  // STATUSES
  // =========================================================

  final UpdateStudyTaskInitialDataStatus initialDataStatus;
  final UpdateStudyTaskSubmitStatus submitStatus;

  final String? actionMessage;
  final String? errorTitle;
  final String? errorMessage;

  // =========================================================
  // INITIAL VALUES
  // =========================================================

  final String initialTitle;
  final String initialDescription;

  final int? initialSelectedStudyPlanSubjectId;

  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  final String initialStartTime;
  final int? initialDurationMinutes;

  final StudyTaskPriority? initialPriority;

  final List<UpdateStudyTaskSubtaskState> initialSubtasks;

  final StudyTaskRepeatPattern initialRepeatPattern;
  final int? initialRepeatWeekday;

  final int? initialReminderOffsetMinutes;

  final bool isFormInitialized;

  const UpdateStudyTaskState({
    this.planId,
    this.taskId,

    this.title = '',
    this.description = '',

    this.availableSubjects = const [],
    this.selectedStudyPlanSubjectId,

    this.startDate,
    this.endDate,

    this.startTime = '',
    this.durationMinutes,

    this.priority,

    this.subtasks = const [],

    this.repeatPattern = StudyTaskRepeatPattern.none,
    this.repeatWeekday,

    this.reminderOffsetMinutes,

    this.initialDataStatus = UpdateStudyTaskInitialDataStatus.initial,

    this.submitStatus = UpdateStudyTaskSubmitStatus.initial,

    this.actionMessage,
    this.errorTitle,
    this.errorMessage,

    this.initialTitle = '',
    this.initialDescription = '',

    this.initialSelectedStudyPlanSubjectId,

    this.initialStartDate,
    this.initialEndDate,

    this.initialStartTime = '',
    this.initialDurationMinutes,

    this.initialPriority,

    this.initialSubtasks = const [],

    this.initialRepeatPattern = StudyTaskRepeatPattern.none,

    this.initialRepeatWeekday,

    this.initialReminderOffsetMinutes,

    this.isFormInitialized = false,
  });

  // =========================================================
  // INITIAL DATA STATUS
  // =========================================================

  bool get isInitialDataInitial {
    return initialDataStatus == UpdateStudyTaskInitialDataStatus.initial;
  }

  bool get isInitialDataLoading {
    return initialDataStatus == UpdateStudyTaskInitialDataStatus.loading;
  }

  bool get isInitialDataSuccess {
    return initialDataStatus == UpdateStudyTaskInitialDataStatus.success;
  }

  bool get isInitialDataFailure {
    return initialDataStatus == UpdateStudyTaskInitialDataStatus.failure;
  }

  // =========================================================
  // SUBMIT STATUS
  // =========================================================

  bool get isSubmitInitial {
    return submitStatus == UpdateStudyTaskSubmitStatus.initial;
  }

  bool get isSubmitLoading {
    return submitStatus == UpdateStudyTaskSubmitStatus.loading;
  }

  bool get isSubmitSuccess {
    return submitStatus == UpdateStudyTaskSubmitStatus.success;
  }

  bool get isSubmitFailure {
    return submitStatus == UpdateStudyTaskSubmitStatus.failure;
  }

  // =========================================================
  // IDS
  // =========================================================

  bool get hasValidPlanId {
    final value = planId;

    return value != null && value > 0;
  }

  bool get hasValidTaskId {
    final value = taskId;

    return value != null && value > 0;
  }

  bool get hasValidIds {
    return hasValidPlanId && hasValidTaskId;
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

  bool isSubjectSelected(int subjectId) {
    return selectedStudyPlanSubjectId == subjectId;
  }

  bool containsSubject(int subjectId) {
    return availableSubjects.any((subject) => subject.id == subjectId);
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

    return normalizeDate(value);
  }

  DateTime? get normalizedEndDate {
    final value = endDate;

    if (value == null) {
      return null;
    }

    return normalizeDate(value);
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

  /*
   * عند فتح مهمة قديمة لا نرفضها لأن تاريخ البداية
   * أصبح في الماضي.
   *
   * لكن عند تغيير تاريخ البداية، يجب أن يكون التاريخ
   * الجديد اليوم أو تاريخًا مستقبليًا.
   */
  bool get hasValidStartDateForUpdate {
    if (!hasStartDateChanged) {
      return true;
    }

    final start = normalizedStartDate;

    if (start == null) {
      return false;
    }

    final today = normalizeDate(DateTime.now());

    return !start.isBefore(today);
  }

  bool get hasValidDates {
    return hasStartDate &&
        hasEndDate &&
        isEndDateAfterOrEqualStartDate &&
        isTaskRangeWithinLimit &&
        hasValidStartDateForUpdate;
  }

  // =========================================================
  // START TIME
  // =========================================================

  String get normalizedStartTime {
    return startTime.trim();
  }

  bool get hasValidStartTime {
    return isValidTime(normalizedStartTime);
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

  List<UpdateStudyTaskSubtaskState> get normalizedSubtasks {
    return subtasks
        .where(
          (subtask) => subtask.id != null || subtask.normalizedTitle.isNotEmpty,
        )
        .toList(growable: false);
  }

  int get subtasksCount {
    return normalizedSubtasks.length;
  }

  bool get hasSubtasks {
    return normalizedSubtasks.isNotEmpty;
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

  bool get hasValidSubtasksCount {
    return subtaskFieldsCount <= maxSubtasksCount;
  }

  bool get haveValidSubtasks {
    if (!hasValidSubtasksCount) {
      return false;
    }

    return subtasks.every((subtask) {
      /*
       * يسمح بحقل جديد فارغ في واجهة المستخدم،
       * ولا يعتبره مهمة فرعية حقيقية.
       */
      if (subtask.isEmptyNewSubtask) {
        return true;
      }

      return subtask.isValid &&
          subtask.normalizedTitle.length <= subtaskTitleMaxLength;
    });
  }

  // =========================================================
  // REPEAT
  // =========================================================

  bool get isRepeating {
    return repeatPattern != StudyTaskRepeatPattern.none;
  }

  /*
   * لأن الـBackend لا يعيد يوم التكرار:
   *
   * - إذا كانت المهمة بدون تكرار، يجب أن يكون اليوم null.
   * - إذا كانت المهمة متكررة، يجب على المستخدم اختيار
   *   اليوم من جديد قبل الحفظ.
   */
  bool get hasValidRepeatWeekday {
    if (!isRepeating) {
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
  // CHANGED FIELDS
  // =========================================================

  bool get hasTitleChanged {
    return normalizedTitle != initialTitle.trim();
  }

  bool get hasDescriptionChanged {
    return normalizedDescription != initialDescription.trim();
  }

  bool get hasSubjectChanged {
    return selectedStudyPlanSubjectId != initialSelectedStudyPlanSubjectId;
  }

  bool get hasStartDateChanged {
    return !isSameDate(normalizedStartDate, initialStartDate);
  }

  bool get hasEndDateChanged {
    return !isSameDate(normalizedEndDate, initialEndDate);
  }

  bool get hasStartTimeChanged {
    return normalizedStartTime != initialStartTime.trim();
  }

  bool get hasDurationChanged {
    return durationMinutes != initialDurationMinutes;
  }

  bool get hasPriorityChanged {
    return priority != initialPriority;
  }

  bool get haveSubtasksChanged {
    return !areSameSubtasks(normalizedSubtasks, initialSubtasks);
  }

  bool get hasRepeatPatternChanged {
    return repeatPattern != initialRepeatPattern;
  }

  bool get hasRepeatWeekdayChanged {
    return repeatWeekday != initialRepeatWeekday;
  }

  bool get hasRepeatChanged {
    if (hasRepeatPatternChanged) {
      return true;
    }

    /*
     * إذا كان النوع بدون تكرار في القيمتين،
     * فلا نهتم بقيمة اليوم.
     */
    if (!isRepeating && initialRepeatPattern == StudyTaskRepeatPattern.none) {
      return false;
    }

    /*
     * عندما تكون المهمة متكررة ويختار المستخدم يومًا،
     * ستكون initialRepeatWeekday تساوي null،
     * وبالتالي سيعتبر التكرار قد تغيّر.
     */
    return hasRepeatWeekdayChanged;
  }

  bool get hasReminderChanged {
    return reminderOffsetMinutes != initialReminderOffsetMinutes;
  }

  bool get hasChanges {
    if (!isFormInitialized) {
      return false;
    }

    return hasTitleChanged ||
        hasDescriptionChanged ||
        hasSubjectChanged ||
        hasStartDateChanged ||
        hasEndDateChanged ||
        hasStartTimeChanged ||
        hasDurationChanged ||
        hasPriorityChanged ||
        haveSubtasksChanged ||
        hasRepeatChanged ||
        hasReminderChanged;
  }

  // =========================================================
  // FORM VALIDATION
  // =========================================================

  bool get isFormValid {
    return hasValidIds &&
        hasValidTitle &&
        hasValidDescription &&
        hasAvailableSubjects &&
        hasSelectedSubject &&
        hasValidDates &&
        hasValidStartTime &&
        hasValidDuration &&
        hasValidPriority &&
        haveValidSubtasks &&
        hasValidRepeatWeekday &&
        hasValidReminder;
  }

  bool get canSubmit {
    return isFormInitialized &&
        isInitialDataSuccess &&
        isFormValid &&
        hasChanges &&
        !isSubmitLoading;
  }

  // =========================================================
  // SUBTASK COMPARISON
  // =========================================================

  bool areSameSubtasks(
    List<UpdateStudyTaskSubtaskState> first,
    List<UpdateStudyTaskSubtaskState> second,
  ) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (int index = 0; index < first.length; index++) {
      final firstSubtask = first[index];
      final secondSubtask = second[index];

      if (firstSubtask.id != secondSubtask.id) {
        return false;
      }

      if (firstSubtask.normalizedTitle != secondSubtask.normalizedTitle) {
        return false;
      }

      if (firstSubtask.isCompleted != secondSubtask.isCompleted) {
        return false;
      }
    }

    return true;
  }

  // =========================================================
  // DATE AND TIME HELPERS
  // =========================================================

  static DateTime normalizeDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static bool isSameDate(DateTime? first, DateTime? second) {
    if (first == null || second == null) {
      return first == second;
    }

    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  static bool isValidTime(String value) {
    return RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(value.trim());
  }

  // =========================================================
  // COPY WITH
  // =========================================================

  UpdateStudyTaskState copyWith({
    int? planId,
    int? taskId,

    String? title,
    String? description,

    List<StudyPlanSubjectEntity>? availableSubjects,
    int? selectedStudyPlanSubjectId,

    DateTime? startDate,
    DateTime? endDate,

    String? startTime,
    int? durationMinutes,

    StudyTaskPriority? priority,

    List<UpdateStudyTaskSubtaskState>? subtasks,

    StudyTaskRepeatPattern? repeatPattern,
    int? repeatWeekday,

    int? reminderOffsetMinutes,

    UpdateStudyTaskInitialDataStatus? initialDataStatus,

    UpdateStudyTaskSubmitStatus? submitStatus,

    String? actionMessage,
    String? errorTitle,
    String? errorMessage,

    String? initialTitle,
    String? initialDescription,

    int? initialSelectedStudyPlanSubjectId,

    DateTime? initialStartDate,
    DateTime? initialEndDate,

    String? initialStartTime,
    int? initialDurationMinutes,

    StudyTaskPriority? initialPriority,

    List<UpdateStudyTaskSubtaskState>? initialSubtasks,

    StudyTaskRepeatPattern? initialRepeatPattern,

    int? initialRepeatWeekday,

    int? initialReminderOffsetMinutes,

    bool? isFormInitialized,

    bool clearPlanId = false,
    bool clearTaskId = false,

    bool clearSelectedStudyPlanSubjectId = false,

    bool clearStartDate = false,
    bool clearEndDate = false,

    bool clearDuration = false,
    bool clearPriority = false,

    bool clearRepeatWeekday = false,
    bool clearReminderOffsetMinutes = false,

    bool clearActionMessage = false,
    bool clearError = false,

    bool clearInitialSelectedStudyPlanSubjectId = false,

    bool clearInitialStartDate = false,
    bool clearInitialEndDate = false,

    bool clearInitialDuration = false,
    bool clearInitialPriority = false,

    bool clearInitialRepeatWeekday = false,

    bool clearInitialReminderOffsetMinutes = false,
  }) {
    return UpdateStudyTaskState(
      planId: clearPlanId ? null : planId ?? this.planId,

      taskId: clearTaskId ? null : taskId ?? this.taskId,

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

      reminderOffsetMinutes: clearReminderOffsetMinutes
          ? null
          : reminderOffsetMinutes ?? this.reminderOffsetMinutes,

      initialDataStatus: initialDataStatus ?? this.initialDataStatus,

      submitStatus: submitStatus ?? this.submitStatus,

      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,

      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      initialTitle: initialTitle ?? this.initialTitle,

      initialDescription: initialDescription ?? this.initialDescription,

      initialSelectedStudyPlanSubjectId: clearInitialSelectedStudyPlanSubjectId
          ? null
          : initialSelectedStudyPlanSubjectId ??
                this.initialSelectedStudyPlanSubjectId,

      initialStartDate: clearInitialStartDate
          ? null
          : initialStartDate ?? this.initialStartDate,

      initialEndDate: clearInitialEndDate
          ? null
          : initialEndDate ?? this.initialEndDate,

      initialStartTime: initialStartTime ?? this.initialStartTime,

      initialDurationMinutes: clearInitialDuration
          ? null
          : initialDurationMinutes ?? this.initialDurationMinutes,

      initialPriority: clearInitialPriority
          ? null
          : initialPriority ?? this.initialPriority,

      initialSubtasks: initialSubtasks ?? this.initialSubtasks,

      initialRepeatPattern: initialRepeatPattern ?? this.initialRepeatPattern,

      initialRepeatWeekday: clearInitialRepeatWeekday
          ? null
          : initialRepeatWeekday ?? this.initialRepeatWeekday,

      initialReminderOffsetMinutes: clearInitialReminderOffsetMinutes
          ? null
          : initialReminderOffsetMinutes ?? this.initialReminderOffsetMinutes,

      isFormInitialized: isFormInitialized ?? this.isFormInitialized,
    );
  }

  // =========================================================
  // TO STRING
  // =========================================================

  @override
  String toString() {
    return 'UpdateStudyTaskState('
        'planId: $planId, '
        'taskId: $taskId, '
        'title: $title, '
        'availableSubjectsCount: '
        '${availableSubjects.length}, '
        'selectedStudyPlanSubjectId: '
        '$selectedStudyPlanSubjectId, '
        'startDate: $startDate, '
        'endDate: $endDate, '
        'taskRangeDays: $taskRangeDays, '
        'startTime: $startTime, '
        'durationMinutes: $durationMinutes, '
        'priority: $priority, '
        'subtaskFieldsCount: '
        '$subtaskFieldsCount, '
        'subtasksCount: $subtasksCount, '
        'repeatPattern: $repeatPattern, '
        'repeatWeekday: $repeatWeekday, '
        'reminderOffsetMinutes: '
        '$reminderOffsetMinutes, '
        'initialDataStatus: '
        '$initialDataStatus, '
        'submitStatus: $submitStatus, '
        'isFormInitialized: '
        '$isFormInitialized, '
        'hasChanges: $hasChanges, '
        'isFormValid: $isFormValid, '
        'canSubmit: $canSubmit'
        ')';
  }
}
