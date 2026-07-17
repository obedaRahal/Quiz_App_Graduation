class StudyPlanDetailsSubjectEntity {
  final int id;
  final String name;

  const StudyPlanDetailsSubjectEntity({required this.id, required this.name});
}

class StudyPlanDetailsSubjectsEntity {
  final int count;
  final String label;
  final List<StudyPlanDetailsSubjectEntity> items;

  const StudyPlanDetailsSubjectsEntity({
    required this.count,
    required this.label,
    required this.items,
  });

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;
}

class StudyPlanDetailsProgressEntity {
  final int remainingDays;
  final int elapsedDays;
  final int totalDays;
  final String elapsedLabel;

  final String startDate;
  final String endDate;

  final int completedTasksCount;
  final int totalTasksCount;
  final double completedPercentage;

  const StudyPlanDetailsProgressEntity({
    required this.remainingDays,
    required this.elapsedDays,
    required this.totalDays,
    required this.elapsedLabel,
    required this.startDate,
    required this.endDate,
    required this.completedTasksCount,
    required this.totalTasksCount,
    required this.completedPercentage,
  });

  /// القيمة التي يحتاجها LinearProgressIndicator.
  double get progressValue {
    final normalized = completedPercentage / 100;

    return normalized.clamp(0.0, 1.0);
  }

  String get completedPercentageLabel {
    final value = completedPercentage;

    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }

    return '${value.toStringAsFixed(1)}%';
  }

  bool get isCompleted => completedPercentage >= 100;

  bool get hasTasks => totalTasksCount > 0;
}

class StudyPlanDetailsOverviewEntity {
  final bool success;
  final String title;
  final int statusCode;

  final int id;
  final String planTitle;
  final String emoji;

  final StudyPlanDetailsSubjectsEntity subjects;
  final StudyPlanDetailsProgressEntity progress;

  const StudyPlanDetailsOverviewEntity({
    required this.success,
    required this.title,
    required this.statusCode,
    required this.id,
    required this.planTitle,
    required this.emoji,
    required this.subjects,
    required this.progress,
  });
}
