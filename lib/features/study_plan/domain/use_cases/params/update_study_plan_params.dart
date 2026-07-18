class UpdateStudyPlanParams {
  final int planId;

  final String? title;
  final String? emoji;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int>? subjectIds;
  final int? dailyStudyHours;
  final bool? isDefault;

  const UpdateStudyPlanParams({
    required this.planId,
    this.title,
    this.emoji,
    this.startDate,
    this.endDate,
    this.subjectIds,
    this.dailyStudyHours,
    this.isDefault,
  });

  bool get hasChanges {
    return title != null ||
        emoji != null ||
        startDate != null ||
        endDate != null ||
        subjectIds != null ||
        dailyStudyHours != null ||
        isDefault != null;
  }

  bool get isValid => planId > 0 && hasChanges;

  Map<String, dynamic> toBody() {
    final body = <String, dynamic>{};

    if (title != null) {
      body['title'] = title!.trim();
    }

    if (emoji != null) {
      body['emoji'] = emoji!.trim();
    }

    if (startDate != null) {
      body['start_date'] = _formatDate(startDate!);
    }

    if (endDate != null) {
      body['end_date'] = _formatDate(endDate!);
    }

    if (subjectIds != null) {
      body['subject_ids'] = subjectIds;
    }

    if (dailyStudyHours != null) {
      body['daily_study_hours'] = dailyStudyHours;
    }

    if (isDefault != null) {
      body['is_default'] = isDefault! ? 1 : 0;
    }

    return body;
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  @override
  String toString() {
    return 'UpdateStudyPlanParams('
        'planId: $planId, '
        'body: ${toBody()}'
        ')';
  }
}
