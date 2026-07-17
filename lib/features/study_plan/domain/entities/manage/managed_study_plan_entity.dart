import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plan_statistics_entity.dart';

class ManagedStudyPlanEntity {
  final int id;
  final String emoji;
  final String title;

  final int subjectsCount;
  final int dailyStudyMinutes;
  final int dailyStudyHours;
  final int durationDays;

  final String startDate;
  final String endDate;

  final int startsInDays;
  final int remainingDays;

  final bool isDefault;

  final StudyPlanStatisticsEntity statistics;

  const ManagedStudyPlanEntity({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subjectsCount,
    required this.dailyStudyMinutes,
    required this.dailyStudyHours,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.startsInDays,
    required this.remainingDays,
    required this.isDefault,
    required this.statistics,
  });

  bool get hasStarted => startsInDays <= 0;

  bool get hasRemainingDays => remainingDays > 0;

  String get displayEmoji {
    final value = emoji.trim();

    return value.isEmpty ? '📚' : value;
  }
}