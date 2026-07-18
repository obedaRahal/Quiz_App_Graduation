import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_summary_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/mock/study_plan_home_mock_scenario.dart';

class StudyPlanHomeMockData {
  const StudyPlanHomeMockData._();

  static StudyPlanOverviewEntity fromScenario(
    StudyPlanHomeMockScenario scenario,
  ) {
    switch (scenario) {
      case StudyPlanHomeMockScenario.noPlan:
        return noPlan;

      case StudyPlanHomeMockScenario.planWithoutTasks:
        return planWithoutTasks;

      case StudyPlanHomeMockScenario.planWithTasks:
        return planWithTasks;
    }
  }

  // ============================================================
  // الحالة الأولى: لا توجد خطة افتراضية
  // ============================================================

  static const StudyPlanOverviewEntity noPlan = StudyPlanOverviewEntity(
    success: true,
    title: '! تم جلب البيانات بنجاح',
    statusCode: 200,
    data: StudyPlanOverviewDataEntity(
      userSettings: StudyPlanUserSettingsEntity(
        id: 1,
        weekStartsOn: 'السبت',
        timeFormat: '12 ساعة',
      ),
      serverToday: '2026-06-27',
      selectedDate: '2026-06-27',
      range: StudyPlanRangeEntity(start: '2026-06-27', end: '2026-07-3'),
      hasDefaultPlan: false,
      isSelectedDateInsidePlan: null,
      plan: null,
      days: [],
      tasks: [],
    ),
  );

  // ============================================================
  // الحالة الثانية: توجد خطة ولكن لا توجد مهام
  // ============================================================

  static const StudyPlanOverviewEntity planWithoutTasks =
      StudyPlanOverviewEntity(
        success: true,
        title: '! تم جلب البيانات بنجاح',
        statusCode: 200,
        data: StudyPlanOverviewDataEntity(
          userSettings: StudyPlanUserSettingsEntity(
            id: 1,
            weekStartsOn: 'السبت',
            timeFormat: '12 ساعة',
          ),
          serverToday: '2026-06-28',
          selectedDate: '2026-06-27',
          range: StudyPlanRangeEntity(start: '2026-06-22', end: '2026-06-28'),
          hasDefaultPlan: true,
          isSelectedDateInsidePlan: false,
          plan: StudyPlanSummaryEntity(
            id: 1,
            emoji: '😘',
            title: 'خطة التخرج للأقوياء',
            subjectsCount: 1,
            dailyStudyMinutes: 240,
            dailyStudyHours: 4,
            durationDays: 3,
            startDate: 'منذ 25 دقيقة',
            endDate: 'يوم من الآن',
            startsInDays: 0,
            remainingDays: 2,
            endDateLabel: '',
            startDateLabel: '',
            isDefault: true,
            statistics: StudyPlanStatisticsEntity(
              tasksCount: 0,
              completedTasksCount: 0,
              missedTasksCount: 0,
              pendingTasksCount: 0,
            ),
          ),
          days: [
            StudyPlanDayEntity(
              date: '2026-06-22',
              dayNumber: 22,
              dayName: 'الإثنين',
              isToday: false,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'empty',
            ),
            StudyPlanDayEntity(
              date: '2026-06-23',
              dayNumber: 23,
              dayName: 'الثلاثاء',
              isToday: false,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'empty',
            ),
            StudyPlanDayEntity(
              date: '2026-06-24',
              dayNumber: 24,
              dayName: 'الأربعاء',
              isToday: false,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'empty',
            ),
            StudyPlanDayEntity(
              date: '2026-06-25',
              dayNumber: 25,
              dayName: 'الخميس',
              isToday: false,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'empty',
            ),
            StudyPlanDayEntity(
              date: '2026-06-26',
              dayNumber: 26,
              dayName: 'الجمعة',
              isToday: false,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'empty',
            ),
            StudyPlanDayEntity(
              date: '2026-06-27',
              dayNumber: 27,
              dayName: 'السبت',
              isToday: false,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'empty',
            ),
            StudyPlanDayEntity(
              date: '2026-06-28',
              dayNumber: 28,
              dayName: 'الأحد',
              isToday: true,
              hasTasks: false,
              totalTasks: 0,
              completedTasks: 0,
              completionState: 'empty',
              displayState: 'today',
            ),
          ],
          tasks: [],
        ),
      );

  // ============================================================
  // الحالة الثالثة: توجد خطة وتوجد مهام
  // ============================================================

  static const StudyPlanOverviewEntity planWithTasks = StudyPlanOverviewEntity(
    success: true,
    title: '! تم جلب البيانات بنجاح',
    statusCode: 200,
    data: StudyPlanOverviewDataEntity(
      userSettings: StudyPlanUserSettingsEntity(
        id: 1,
        weekStartsOn: 'السبت',
        timeFormat: '12 ساعة',
      ),
      serverToday: '2026-06-29',
      selectedDate: '2026-07-02',
      range: StudyPlanRangeEntity(start: '2026-06-29', end: '2026-07-05'),
      hasDefaultPlan: true,
      isSelectedDateInsidePlan: true,
      plan: StudyPlanSummaryEntity(
        id: 3,
        emoji: '😘',
        title: 'خطة التخرج للأقوياء',
        subjectsCount: 1,
        dailyStudyMinutes: 600,
        dailyStudyHours: 10,
        durationDays: 32,
        startDate: 'منذ 21 ساعة',
        endDate: '30 July 2026',
        endDateLabel: '',
        startDateLabel: '',
        startsInDays: 0,
        remainingDays: 31,
        isDefault: true,
        statistics: StudyPlanStatisticsEntity(
          tasksCount: 8,
          completedTasksCount: 0,
          missedTasksCount: 0,
          pendingTasksCount: 8,
        ),
      ),
      days: [
        StudyPlanDayEntity(
          date: '2026-06-29',
          dayNumber: 29,
          dayName: 'الإثنين',
          isToday: true,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'completed',
        ),
        StudyPlanDayEntity(
          date: '2026-06-30',
          dayNumber: 30,
          dayName: 'الثلاثاء',
          isToday: false,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'inCompleted',
        ),
        StudyPlanDayEntity(
          date: '2026-07-01',
          dayNumber: 1,
          dayName: 'الأربعاء',
          isToday: false,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'empty',
        ),
        StudyPlanDayEntity(
          date: '2026-07-02',
          dayNumber: 2,
          dayName: 'الخميس',
          isToday: false,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'empty',
        ),
        StudyPlanDayEntity(
          date: '2026-07-03',
          dayNumber: 3,
          dayName: 'الجمعة',
          isToday: false,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'scheduled',
        ),
        StudyPlanDayEntity(
          date: '2026-07-04',
          dayNumber: 4,
          dayName: 'السبت',
          isToday: false,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'empty',
        ),
        StudyPlanDayEntity(
          date: '2026-07-05',
          dayNumber: 5,
          dayName: 'الأحد',
          isToday: false,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState: 'empty',
        ),
      ],
      tasks: [
        StudyPlanDailyTaskEntity(
          id: 5,
          occurrenceId: 22,
          taskNumber: 1,
          title: 'مراجعة فصل قواعد البيانات',
          status: 'قيد المعالجة',
          priority: 'منخفضة',
          subtasks: StudyPlanTaskSubtasksEntity(
            completed: 0,
            total: 2,
            label: '0/2',
          ),
          time: StudyPlanTaskTimeEntity(
            start: '14:00',
            end: '15:30',
            durationSeconds: 5400,
            durationMinutes: 90,
          ),
        ),

        StudyPlanDailyTaskEntity(
          id: 6,
          occurrenceId: 23,
          taskNumber: 2,
          title: 'مراجعة فصل قواعد البيانات',
          status: 'للقيام',
          priority: 'متوسطة',
          subtasks: StudyPlanTaskSubtasksEntity(
            completed: 0,
            total: 2,
            label: '0/2',
          ),
          time: StudyPlanTaskTimeEntity(
            start: '14:00',
            end: '15:30',
            durationSeconds: 5400,
            durationMinutes: 90,
          ),
        ),
      ],
    ),
  );
}
