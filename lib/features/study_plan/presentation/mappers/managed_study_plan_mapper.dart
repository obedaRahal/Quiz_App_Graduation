import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart'
    as home;
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/study_plan_statistics_entity.dart'
    as manage;

extension ManagedStudyPlanMapper on ManagedStudyPlanEntity {
  home.StudyPlanSummaryEntity toStudyPlanSummaryEntity() {
    return home.StudyPlanSummaryEntity(
      id: id,
      title: title,
      emoji: emoji,
      subjectsCount: subjectsCount,
      dailyStudyHours: dailyStudyHours,
      durationDays: durationDays,
      startDate: startDate,
      endDate: endDate,
      isDefault: isDefault,
      dailyStudyMinutes: dailyStudyMinutes,
      startsInDays: startsInDays,
      remainingDays: remainingDays,
      statistics: statistics.toHomeEntity(),
      startDateLabel: startDateLabel,
      endDateLabel: endDateLabel,
    );
  }
}

extension ManagedStatisticsMapper on manage.StudyPlanStatisticsEntity {
  home.StudyPlanStatisticsEntity toHomeEntity() {
    return home.StudyPlanStatisticsEntity(
      tasksCount: tasksCount,
      completedTasksCount: completedTasksCount,
      missedTasksCount: missedTasksCount,
      pendingTasksCount: pendingTasksCount,
    );
  }
}
