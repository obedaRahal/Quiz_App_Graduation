import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_priority.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';

// =========================================================
// UPDATE SUBTASK PARAMS
// =========================================================

class UpdateStudyTaskSubtaskParams {
  final int? id;
  final String title;
  final bool isCompleted;

  const UpdateStudyTaskSubtaskParams({
    this.id,
    required this.title,
    required this.isCompleted,
  });

  String get normalizedTitle {
    return title.trim();
  }

  bool get isNew {
    return id == null;
  }

  bool get isExisting {
    return id != null;
  }

  bool get hasValidId {
    final value = id;

    return value == null || value > 0;
  }

  bool get hasValidTitle {
    return normalizedTitle.isNotEmpty &&
        normalizedTitle.length <= UpdateStudyTaskParams.subtaskTitleMaxLength;
  }

  bool get isValid {
    return hasValidId && hasValidTitle;
  }

  Map<String, dynamic> toBody() {
    final body = <String, dynamic>{
      'title': normalizedTitle,
      'is_completed': isCompleted,
    };

    final subtaskId = id;

    if (subtaskId != null) {
      body['id'] = subtaskId;
    }

    return body;
  }

  @override
  String toString() {
    return 'UpdateStudyTaskSubtaskParams('
        'id: $id, '
        'title: $normalizedTitle, '
        'isCompleted: $isCompleted'
        ')';
  }
}

// =========================================================
// UPDATE STUDY TASK PARAMS
// =========================================================

class UpdateStudyTaskParams {
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

  final int planId;
  final int taskId;

  // =========================================================
  // OPTIONAL CHANGED FIELDS
  // =========================================================

  final String? title;
  final String? description;

  final int? studyPlanSubjectId;

  final DateTime? startDate;
  final DateTime? endDate;

  final String? startTime;
  final int? durationMinutes;

  final StudyTaskPriority? priority;

  // =========================================================
  // SUBTASKS
  // =========================================================

  /*
   * false:
   * لم تتغير المهام الفرعية، فلا نرسل المفتاح.
   *
   * true:
   * تغيرت المهام الفرعية، ونرسل القائمة كاملة،
   * حتى إن أصبحت قائمة فارغة.
   */
  final bool includeSubtasks;

  final List<UpdateStudyTaskSubtaskParams> subtasks;

  // =========================================================
  // REPEAT
  // =========================================================

  /*
   * false:
   * لم يتغير التكرار، فلا نرسل حقوله.
   *
   * true:
   * تغير التكرار، ونرسل repeat_pattern.
   */
  final bool includeRepeat;

  final StudyTaskRepeatPattern? repeatPattern;
  final int? repeatWeekday;

  // =========================================================
  // REMINDER
  // =========================================================

  /*
   * false:
   * لم يتغير التذكير، فلا نرسل المفتاح.
   *
   * true مع قيمة:
   * نرسل عدد الدقائق.
   *
   * true مع null:
   * نرسل null لحذف التذكير.
   */
  final bool includeReminderOffsetMinutes;

  final int? reminderOffsetMinutes;

  const UpdateStudyTaskParams({
    required this.planId,
    required this.taskId,

    this.title,
    this.description,

    this.studyPlanSubjectId,

    this.startDate,
    this.endDate,

    this.startTime,
    this.durationMinutes,

    this.priority,

    this.includeSubtasks = false,
    this.subtasks = const [],

    this.includeRepeat = false,
    this.repeatPattern,
    this.repeatWeekday,

    this.includeReminderOffsetMinutes = false,
    this.reminderOffsetMinutes,
  });

  // =========================================================
  // NORMALIZED VALUES
  // =========================================================

  String? get normalizedTitle {
    final value = title;

    if (value == null) {
      return null;
    }

    return value.trim();
  }

  String? get normalizedDescription {
    final value = description;

    if (value == null) {
      return null;
    }

    return value.trim();
  }

  String? get normalizedStartTime {
    final value = startTime;

    if (value == null) {
      return null;
    }

    return value.trim();
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

  // =========================================================
  // CHANGE GETTERS
  // =========================================================

  bool get hasTitle {
    return title != null;
  }

  bool get hasDescription {
    return description != null;
  }

  bool get hasStudyPlanSubjectId {
    return studyPlanSubjectId != null;
  }

  bool get hasStartDate {
    return startDate != null;
  }

  bool get hasEndDate {
    return endDate != null;
  }

  bool get hasStartTime {
    return startTime != null;
  }

  bool get hasDuration {
    return durationMinutes != null;
  }

  bool get hasPriority {
    return priority != null;
  }

  bool get hasAnyChanges {
    return hasTitle ||
        hasDescription ||
        hasStudyPlanSubjectId ||
        hasStartDate ||
        hasEndDate ||
        hasStartTime ||
        hasDuration ||
        hasPriority ||
        includeSubtasks ||
        includeRepeat ||
        includeReminderOffsetMinutes;
  }

  // =========================================================
  // TITLE VALIDATION
  // =========================================================

  bool get hasValidTitle {
    if (!hasTitle) {
      return true;
    }

    final value = normalizedTitle;

    return value != null && value.isNotEmpty && value.length <= titleMaxLength;
  }

  // =========================================================
  // DESCRIPTION VALIDATION
  // =========================================================

  bool get hasValidDescription {
    if (!hasDescription) {
      return true;
    }

    final value = normalizedDescription;

    return value != null &&
        value.isNotEmpty &&
        value.length <= descriptionMaxLength;
  }

  // =========================================================
  // SUBJECT VALIDATION
  // =========================================================

  bool get hasValidStudyPlanSubjectId {
    final value = studyPlanSubjectId;

    return value == null || value > 0;
  }

  // =========================================================
  // DATES VALIDATION
  // =========================================================

  bool get hasValidStartDate {
    final value = normalizedStartDate;

    if (value == null) {
      return true;
    }

    final today = _normalizeDate(DateTime.now());

    return !value.isBefore(today);
  }

  /*
   * عند إرسال التاريخين معًا، نتحقق من ترتيبهما.
   *
   * أما عند إرسال تاريخ واحد فقط، فالتحقق الكامل
   * يكون قد تم مسبقًا داخل الـState.
   */
  bool get haveValidDateOrder {
    final start = normalizedStartDate;
    final end = normalizedEndDate;

    if (start == null || end == null) {
      return true;
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

  bool get hasValidTaskRange {
    final start = normalizedStartDate;
    final end = normalizedEndDate;

    if (start == null || end == null) {
      return true;
    }

    return taskRangeDays >= 1 && taskRangeDays <= maxTaskRangeDays;
  }

  // =========================================================
  // TIME VALIDATION
  // =========================================================

  bool get hasValidStartTime {
    if (!hasStartTime) {
      return true;
    }

    final value = normalizedStartTime;

    return value != null && _isValidTime(value);
  }

  // =========================================================
  // DURATION VALIDATION
  // =========================================================

  bool get hasValidDuration {
    final value = durationMinutes;

    return value == null ||
        value >= minDurationMinutes && value <= maxDurationMinutes;
  }

  // =========================================================
  // SUBTASKS VALIDATION
  // =========================================================

  bool get hasValidSubtasksCount {
    if (!includeSubtasks) {
      return true;
    }

    return subtasks.length <= maxSubtasksCount;
  }

  bool get haveValidSubtasks {
    if (!includeSubtasks) {
      return true;
    }

    if (!hasValidSubtasksCount) {
      return false;
    }

    return subtasks.every((subtask) => subtask.isValid);
  }

  // =========================================================
  // REPEAT VALIDATION
  // =========================================================

  bool get hasValidRepeat {
    if (!includeRepeat) {
      return repeatPattern == null && repeatWeekday == null;
    }

    final pattern = repeatPattern;

    if (pattern == null) {
      return false;
    }

    if (pattern == StudyTaskRepeatPattern.none) {
      return repeatWeekday == null;
    }

    final weekday = repeatWeekday;

    return weekday != null && weekday >= 0 && weekday <= 6;
  }

  // =========================================================
  // REMINDER VALIDATION
  // =========================================================

  bool get hasValidReminder {
    if (!includeReminderOffsetMinutes) {
      /*
       * عندما لا نرسل التذكير، يجب ألا نحمل
       * قيمة غير مستخدمة داخله.
       */
      return reminderOffsetMinutes == null;
    }

    final value = reminderOffsetMinutes;

    /*
     * null مسموحة هنا لأنها تعني حذف التذكير.
     */
    return value == null || allowedReminderOffsetMinutes.contains(value);
  }

  // =========================================================
  // GENERAL VALIDATION
  // =========================================================

  bool get hasValidIds {
    return planId > 0 && taskId > 0;
  }

  bool get isValid {
    return hasValidIds &&
        hasAnyChanges &&
        hasValidTitle &&
        hasValidDescription &&
        hasValidStudyPlanSubjectId &&
        hasValidStartDate &&
        haveValidDateOrder &&
        hasValidTaskRange &&
        hasValidStartTime &&
        hasValidDuration &&
        haveValidSubtasks &&
        hasValidRepeat &&
        hasValidReminder;
  }

  // =========================================================
  // BODY
  // =========================================================

  Map<String, dynamic> toBody() {
    final body = <String, dynamic>{};

    if (hasTitle) {
      body['title'] = normalizedTitle;
    }

    if (hasDescription) {
      body['description'] = normalizedDescription;
    }

    final subjectId = studyPlanSubjectId;

    if (subjectId != null) {
      body['study_plan_subject_id'] = subjectId;
    }

    final normalizedStart = normalizedStartDate;

    if (normalizedStart != null) {
      body['start_date'] = _formatDate(normalizedStart);
    }

    final normalizedEnd = normalizedEndDate;

    if (normalizedEnd != null) {
      body['end_date'] = _formatDate(normalizedEnd);
    }

    final normalizedTime = normalizedStartTime;

    if (normalizedTime != null) {
      body['start_time'] = normalizedTime;
    }

    final duration = durationMinutes;

    if (duration != null) {
      body['duration_minutes'] = duration;
    }

    final selectedPriority = priority;

    if (selectedPriority != null) {
      body['priority'] = selectedPriority.apiValue;
    }

    /*
     * نرسل القائمة حتى إن كانت فارغة،
     * لأن القائمة الفارغة تعني حذف جميع المهام الفرعية.
     */
    if (includeSubtasks) {
      body['subtasks'] = subtasks
          .map((subtask) => subtask.toBody())
          .toList(growable: false);
    }

    if (includeRepeat) {
      final pattern = repeatPattern;

      if (pattern != null) {
        body['repeat_pattern'] = pattern.apiValue;

        if (pattern != StudyTaskRepeatPattern.none) {
          body['repeat_weekday'] = repeatWeekday;
        }
      }
    }

    /*
     * عند includeReminderOffsetMinutes == true
     * نرسل المفتاح دائمًا، حتى إن كانت القيمة null.
     */
    if (includeReminderOffsetMinutes) {
      body['reminder_offset_minutes'] = reminderOffsetMinutes;
    }

    return body;
  }

  // =========================================================
  // HELPERS
  // =========================================================

  static DateTime _normalizeDate(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static String _formatDate(DateTime value) {
    final year = value.year.toString().padLeft(4, '0');

    final month = value.month.toString().padLeft(2, '0');

    final day = value.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static bool _isValidTime(String value) {
    return RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(value.trim());
  }

  // =========================================================
  // TO STRING
  // =========================================================

  @override
  String toString() {
    return 'UpdateStudyTaskParams('
        'planId: $planId, '
        'taskId: $taskId, '
        'title: $normalizedTitle, '
        'description: $normalizedDescription, '
        'studyPlanSubjectId: '
        '$studyPlanSubjectId, '
        'startDate: $normalizedStartDate, '
        'endDate: $normalizedEndDate, '
        'startTime: $normalizedStartTime, '
        'durationMinutes: $durationMinutes, '
        'priority: ${priority?.apiValue}, '
        'includeSubtasks: $includeSubtasks, '
        'subtasks: $subtasks, '
        'includeRepeat: $includeRepeat, '
        'repeatPattern: '
        '${repeatPattern?.apiValue}, '
        'repeatWeekday: $repeatWeekday, '
        'includeReminderOffsetMinutes: '
        '$includeReminderOffsetMinutes, '
        'reminderOffsetMinutes: '
        '$reminderOffsetMinutes, '
        'hasAnyChanges: $hasAnyChanges, '
        'isValid: $isValid'
        ')';
  }
}
