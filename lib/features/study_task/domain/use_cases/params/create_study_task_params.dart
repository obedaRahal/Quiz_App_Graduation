enum StudyTaskPriority { low, medium, high }

enum StudyTaskRepeatPattern {
  none,
  weekly,
  everyTwoWeeks,
  everyThreeWeeks,
  everyFourWeeks,
}

class CreateStudyTaskSubtaskParams {
  final String title;

  const CreateStudyTaskSubtaskParams({required this.title});

  String get normalizedTitle => title.trim();

  bool get isValid {
    return normalizedTitle.isNotEmpty;
  }

  Map<String, dynamic> toBody() {
    return {'title': normalizedTitle};
  }

  @override
  String toString() {
    return 'CreateStudyTaskSubtaskParams('
        'title: $normalizedTitle'
        ')';
  }
}

class CreateStudyTaskParams {
  static const int maxSubtasksCount = 20;

  static const int minDurationMinutes = 10;
  static const int maxDurationMinutes = 720;

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

  final int planId;

  final String title;
  final String description;

  final int studyPlanSubjectId;

  final DateTime startDate;
  final DateTime endDate;

  final String startTime;
  final int durationMinutes;

  final StudyTaskPriority priority;

  final List<CreateStudyTaskSubtaskParams> subtasks;

  final StudyTaskRepeatPattern repeatPattern;
  final int? repeatWeekday;

  final int? reminderOffsetMinutes;

  const CreateStudyTaskParams({
    required this.planId,
    required this.title,
    required this.description,
    required this.studyPlanSubjectId,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.durationMinutes,
    required this.priority,
    this.subtasks = const [],
    required this.repeatPattern,
    this.repeatWeekday,
    this.reminderOffsetMinutes,
  });

  // =========================================================
  // NORMALIZED VALUES
  // =========================================================

  String get normalizedTitle => title.trim();

  String get normalizedDescription => description.trim();

  String get normalizedStartTime => startTime.trim();

  DateTime get normalizedStartDate {
    return _normalizeDate(startDate);
  }

  DateTime get normalizedEndDate {
    return _normalizeDate(endDate);
  }

  // =========================================================
  // REPEAT
  // =========================================================

  bool get isRepeating {
    return repeatPattern != StudyTaskRepeatPattern.none;
  }

  bool get hasValidRepeatWeekday {
    if (!isRepeating) {
      return repeatWeekday == null;
    }

    final weekday = repeatWeekday;

    return weekday != null && weekday >= 0 && weekday <= 6;
  }

  // =========================================================
  // DATES
  // =========================================================

  bool get isStartDateTodayOrFuture {
    final today = _normalizeDate(DateTime.now());

    return !normalizedStartDate.isBefore(today);
  }

  bool get isEndDateAfterOrEqualStartDate {
    return !normalizedEndDate.isBefore(normalizedStartDate);
  }

  int get taskRangeDays {
    if (!isEndDateAfterOrEqualStartDate) {
      return 0;
    }

    return normalizedEndDate.difference(normalizedStartDate).inDays + 1;
  }

  bool get hasValidTaskRange {
    return taskRangeDays >= 1 && taskRangeDays <= 7;
  }

  // =========================================================
  // DURATION
  // =========================================================

  bool get hasValidDuration {
    return durationMinutes >= minDurationMinutes &&
        durationMinutes <= maxDurationMinutes;
  }

  // =========================================================
  // SUBTASKS
  // =========================================================

  List<CreateStudyTaskSubtaskParams> get validSubtasks {
    return subtasks.where((subtask) => subtask.isValid).toList(growable: false);
  }

  bool get hasValidSubtasksCount {
    return subtasks.length <= maxSubtasksCount;
  }

  /*
   * الحقول الفارغة تعتبر حقول واجهة غير مكتملة،
   * ولذلك لا يتم إرسالها في الطلب.
   *
   * أما كل مهمة فرعية يتم إرسالها، فيجب أن يكون
   * عنوانها غير فارغ، وهذا مضمون بواسطة validSubtasks.
   */
  bool get haveValidSubtasks {
    return hasValidSubtasksCount;
  }

  // =========================================================
  // REMINDER
  // =========================================================

  bool get hasValidReminder {
    final value = reminderOffsetMinutes;

    return value == null || allowedReminderOffsetMinutes.contains(value);
  }

  // =========================================================
  // VALIDATION
  // =========================================================

  bool get isValid {
    if (planId <= 0) {
      return false;
    }

    if (normalizedTitle.isEmpty) {
      return false;
    }

    if (normalizedDescription.isEmpty) {
      return false;
    }

    if (studyPlanSubjectId <= 0) {
      return false;
    }

    if (!isStartDateTodayOrFuture) {
      return false;
    }

    if (!isEndDateAfterOrEqualStartDate) {
      return false;
    }

    if (!hasValidTaskRange) {
      return false;
    }

    if (!_isValidTime(normalizedStartTime)) {
      return false;
    }

    if (!hasValidDuration) {
      return false;
    }

    if (!haveValidSubtasks) {
      return false;
    }

    if (!hasValidRepeatWeekday) {
      return false;
    }

    if (!hasValidReminder) {
      return false;
    }

    return true;
  }

  // =========================================================
  // BODY
  // =========================================================

  Map<String, dynamic> toBody() {
    final body = <String, dynamic>{
      'title': normalizedTitle,
      'description': normalizedDescription,
      'study_plan_subject_id': studyPlanSubjectId,
      'start_date': _formatDate(normalizedStartDate),
      'end_date': _formatDate(normalizedEndDate),
      'start_time': normalizedStartTime,
      'duration_minutes': durationMinutes,
      'priority': priority.apiValue,
    };

    final filteredSubtasks = validSubtasks;

    if (filteredSubtasks.isNotEmpty) {
      body['subtasks'] = filteredSubtasks
          .map((subtask) => subtask.toBody())
          .toList(growable: false);
    }

    if (isRepeating) {
      body['repeat_pattern'] = repeatPattern.apiValue;

      body['repeat_weekday'] = repeatWeekday;
    }

    if (reminderOffsetMinutes != null) {
      body['reminder_offset_minutes'] = reminderOffsetMinutes;
    }

    return body;
  }

  // =========================================================
  // HELPERS
  // =========================================================

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  static bool _isValidTime(String value) {
    final timePattern = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

    return timePattern.hasMatch(value.trim());
  }

  // =========================================================
  // TO STRING
  // =========================================================

  @override
  String toString() {
    return 'CreateStudyTaskParams('
        'planId: $planId, '
        'title: $normalizedTitle, '
        'description: $normalizedDescription, '
        'studyPlanSubjectId: $studyPlanSubjectId, '
        'startDate: ${_formatDate(normalizedStartDate)}, '
        'endDate: ${_formatDate(normalizedEndDate)}, '
        'taskRangeDays: $taskRangeDays, '
        'startTime: $normalizedStartTime, '
        'durationMinutes: $durationMinutes, '
        'priority: ${priority.apiValue}, '
        'subtasks: $validSubtasks, '
        'repeatPattern: ${repeatPattern.apiValue}, '
        'repeatWeekday: $repeatWeekday, '
        'reminderOffsetMinutes: $reminderOffsetMinutes'
        ')';
  }
}

extension StudyTaskPriorityApiValue on StudyTaskPriority {
  String get apiValue {
    switch (this) {
      case StudyTaskPriority.low:
        return 'منخفضة';

      case StudyTaskPriority.medium:
        return 'متوسطة';

      case StudyTaskPriority.high:
        return 'عالية';
    }
  }
}

extension StudyTaskRepeatPatternApiValue on StudyTaskRepeatPattern {
  String get apiValue {
    switch (this) {
      case StudyTaskRepeatPattern.none:
        return 'بدون تكرار';

      case StudyTaskRepeatPattern.weekly:
        return 'كل أسبوع';

      case StudyTaskRepeatPattern.everyTwoWeeks:
        return 'كل أسبوعين';

      case StudyTaskRepeatPattern.everyThreeWeeks:
        return 'كل 3 أسابيع';

      case StudyTaskRepeatPattern.everyFourWeeks:
        return 'كل 4 أسابيع';
    }
  }
}
