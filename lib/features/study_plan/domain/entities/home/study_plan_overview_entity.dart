import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';

class StudyPlanOverviewEntity {
  final bool success;
  final String title;
  final StudyPlanOverviewDataEntity data;
  final int statusCode;

  const StudyPlanOverviewEntity({
    required this.success,
    required this.title,
    required this.data,
    required this.statusCode,
  });

  StudyPlanOverviewEntity copyWith({
    bool? success,
    String? title,
    StudyPlanOverviewDataEntity? data,
    int? statusCode,
  }) {
    return StudyPlanOverviewEntity(
      success: success ?? this.success,
      title: title ?? this.title,
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

class StudyPlanOverviewDataEntity {
  final StudyPlanUserSettingsEntity userSettings;
  final String serverToday;
  final String selectedDate;
  final StudyPlanRangeEntity range;
  final bool hasDefaultPlan;

  /// الحقل غير موجود في حالة عدم وجود خطة.
  final bool? isSelectedDateInsidePlan;

  final StudyPlanSummaryEntity? plan;
  final List<StudyPlanDayEntity> days;
  final List<StudyPlanDailyTaskEntity> tasks;

  const StudyPlanOverviewDataEntity({
    required this.userSettings,
    required this.serverToday,
    required this.selectedDate,
    required this.range,
    required this.hasDefaultPlan,
    required this.isSelectedDateInsidePlan,
    required this.plan,
    required this.days,
    required this.tasks,
  });

  bool get hasPlan => hasDefaultPlan && plan != null;

  bool get hasTasks => tasks.isNotEmpty;

  bool get selectedDateIsInsidePlan =>
      isSelectedDateInsidePlan ?? false;

  StudyPlanOverviewDataEntity copyWith({
    StudyPlanUserSettingsEntity? userSettings,
    String? serverToday,
    String? selectedDate,
    StudyPlanRangeEntity? range,
    bool? hasDefaultPlan,
    bool? isSelectedDateInsidePlan,
    bool clearIsSelectedDateInsidePlan = false,
    StudyPlanSummaryEntity? plan,
    bool clearPlan = false,
    List<StudyPlanDayEntity>? days,
    List<StudyPlanDailyTaskEntity>? tasks,
  }) {
    return StudyPlanOverviewDataEntity(
      userSettings: userSettings ?? this.userSettings,
      serverToday: serverToday ?? this.serverToday,
      selectedDate: selectedDate ?? this.selectedDate,
      range: range ?? this.range,
      hasDefaultPlan: hasDefaultPlan ?? this.hasDefaultPlan,
      isSelectedDateInsidePlan: clearIsSelectedDateInsidePlan
          ? null
          : isSelectedDateInsidePlan ??
              this.isSelectedDateInsidePlan,
      plan: clearPlan ? null : plan ?? this.plan,
      days: days ?? this.days,
      tasks: tasks ?? this.tasks,
    );
  }
}

class StudyPlanUserSettingsEntity {
  final int id;
  final String weekStartsOn;
  final String timeFormat;

  const StudyPlanUserSettingsEntity({
    required this.id,
    required this.weekStartsOn,
    required this.timeFormat,
  });

  StudyPlanUserSettingsEntity copyWith({
    int? id,
    String? weekStartsOn,
    String? timeFormat,
  }) {
    return StudyPlanUserSettingsEntity(
      id: id ?? this.id,
      weekStartsOn: weekStartsOn ?? this.weekStartsOn,
      timeFormat: timeFormat ?? this.timeFormat,
    );
  }
}

class StudyPlanRangeEntity {
  final String start;
  final String end;

  const StudyPlanRangeEntity({
    required this.start,
    required this.end,
  });

  StudyPlanRangeEntity copyWith({
    String? start,
    String? end,
  }) {
    return StudyPlanRangeEntity(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}