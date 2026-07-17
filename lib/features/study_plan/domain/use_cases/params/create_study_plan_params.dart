class CreateStudyPlanParams {
  final String title;
  final String emoji;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> subjectIds;
  final int dailyStudyHours;
  final bool isDefault;

  const CreateStudyPlanParams({
    required this.title,
    required this.emoji,
    required this.startDate,
    required this.endDate,
    required this.subjectIds,
    required this.dailyStudyHours,
    required this.isDefault,
  });

  Map<String, dynamic> toBody() {
    return {
      'title': title.trim(),
      'emoji': emoji.trim(),
      'start_date': _formatDate(startDate),
      'end_date': _formatDate(endDate),
      'subject_ids': subjectIds,
      'daily_study_hours': dailyStudyHours,
      'is_default': isDefault ? 1 : 0,
    };
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  @override
  String toString() {
    return 'CreateStudyPlanParams('
        'title: ${title.trim()}, '
        'emoji: ${emoji.trim()}, '
        'startDate: ${_formatDate(startDate)}, '
        'endDate: ${_formatDate(endDate)}, '
        'subjectIds: $subjectIds, '
        'dailyStudyHours: $dailyStudyHours, '
        'isDefault: $isDefault'
        ')';
  }
}