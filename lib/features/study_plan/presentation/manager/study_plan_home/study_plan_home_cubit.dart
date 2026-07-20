import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/mock/study_plan_home_mock_data.dart';
import 'package:quiz_app_grad/features/study_plan/domain/mock/study_plan_home_mock_scenario.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_daily_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_daily_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_home/study_plan_home_state.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/utils/study_plan_date_utils.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/change_study_task_status_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/change_study_task_status_params.dart';

class StudyPlanHomeCubit extends Cubit<StudyPlanHomeState> {
  static const bool useMockData = false;

  final GetStudyPlanDailyOverviewUseCase getStudyPlanDailyOverviewUseCase;
  final ChangeStudyTaskStatusUseCase changeStudyTaskStatusUseCase;

  StudyPlanHomeCubit({
    required this.getStudyPlanDailyOverviewUseCase,
    required this.changeStudyTaskStatusUseCase,
  }) : super(const StudyPlanHomeState()) {
    debugPrint("============ StudyPlanHomeCubit INIT ============");
  }

  Future<void> loadInitialMock({
    StudyPlanHomeMockScenario scenario = StudyPlanHomeMockScenario.noPlan,
  }) async {
    debugPrint('============ StudyPlanHomeCubit.loadInitialMock ============');
    debugPrint('→ scenario: $scenario');

    emit(
      state.copyWith(
        status: StudyPlanHomeStatus.loading,
        activeMockScenario: scenario,
        clearOverview: true,
        taskUpdateStatus: StudyPlanTaskUpdateStatus.initial,
        clearUpdatingTaskId: true,
        clearError: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 700));

    final response = StudyPlanHomeMockData.fromScenario(scenario);

    emit(
      state.copyWith(
        status: StudyPlanHomeStatus.success,
        overview: response,
        activeMockScenario: scenario,
        clearError: true,
      ),
    );

    debugPrint('✓ mock overview loaded');
    debugPrint('→ has plan: ${response.data.hasPlan}');
    debugPrint('→ tasks count: ${response.data.tasks.length}');
    debugPrint('=================================================');
  }

  Future<void> changeMockScenario(StudyPlanHomeMockScenario scenario) async {
    if (state.activeMockScenario == scenario && state.isSuccess) {
      return;
    }

    await loadInitialMock(scenario: scenario);
  }

  Future<void> selectMockDay(StudyPlanDayEntity day) async {
    debugPrint('============ StudyPlanHomeCubit.selectMockDay ============');
    debugPrint('→ selected date: ${day.date}');

    final currentOverview = state.overview;

    if (currentOverview == null) {
      debugPrint('✗ selectMockDay ignored: overview is null');
      debugPrint('==========================================================');
      return;
    }

    if (state.isLoading) {
      debugPrint('✗ selectMockDay ignored: request is loading');
      debugPrint('==========================================================');
      return;
    }

    if (day.date == currentOverview.data.selectedDate) {
      debugPrint('✗ selectMockDay ignored: same selected date');
      debugPrint('==========================================================');
      return;
    }

    emit(state.copyWith(status: StudyPlanHomeStatus.loading, clearError: true));

    await Future.delayed(const Duration(milliseconds: 450));

    final updatedData = currentOverview.data.copyWith(selectedDate: day.date);

    final updatedOverview = currentOverview.copyWith(data: updatedData);

    emit(
      state.copyWith(
        status: StudyPlanHomeStatus.success,
        overview: updatedOverview,
        clearError: true,
      ),
    );

    debugPrint('✓ selected mock day updated locally');
    debugPrint('==========================================================');
  }

  Future<void> goToNextWeek() async {
    debugPrint('============ StudyPlanHomeCubit.goToNextWeek ============');

    await _moveWeek(daysOffset: 7);
  }

  List<StudyPlanDayEntity> _buildLocalWeekDays({
    required DateTime weekStart,
    required String serverToday,
  }) {
    final today = StudyPlanDateUtils.tryParseApiDate(serverToday);

    final dates = StudyPlanDateUtils.buildWeekDates(weekStart: weekStart);

    return dates.map((date) {
      final formattedDate = StudyPlanDateUtils.formatApiDate(date);

      final isToday = today != null && DateUtils.isSameDay(today, date);

      return StudyPlanDayEntity(
        date: formattedDate,
        dayNumber: date.day,
        dayName: StudyPlanDateUtils.arabicDayName(date),
        isToday: isToday,
        hasTasks: false,
        totalTasks: 0,
        completedTasks: 0,
        completionState: 'empty',
        displayState: isToday ? 'today' : 'empty',
      );
    }).toList();
  }

  Future<void> toggleTaskStatus({required int taskId}) async {
    debugPrint('============ StudyPlanHomeCubit.toggleTaskStatus ============');
    debugPrint('→ taskId: $taskId');
    debugPrint('→ useMockData: $useMockData');

    if (!useMockData) {
      await _changeTaskStatus(taskId: taskId);
      return;
    }

    await _toggleMockTaskStatus(taskId: taskId);
  }

  Future<void> _changeTaskStatus({required int taskId}) async {
    final currentOverview = state.overview;

    if (currentOverview == null || state.isTaskUpdating) {
      return;
    }

    final planId = currentOverview.data.plan?.id;
    StudyPlanDailyTaskEntity? selectedTask;

    for (final task in currentOverview.data.tasks) {
      if (task.id == taskId) {
        selectedTask = task;
        break;
      }
    }

    if (planId == null || planId <= 0 || selectedTask == null || taskId <= 0) {
      emit(
        state.copyWith(
          taskUpdateStatus: StudyPlanTaskUpdateStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة أو المهمة غير صالح',
          clearTaskUpdateMessage: true,
        ),
      );
      return;
    }

    final currentStatus = selectedTask.parsedStatus;

    if (currentStatus == StudyTaskStatus.missed) {
      emit(
        state.copyWith(
          taskUpdateStatus: StudyPlanTaskUpdateStatus.failure,
          errorTitle: 'عملية غير متاحة',
          errorMessage: 'لا يمكن تغيير حالة المهمة الفائتة',
          clearTaskUpdateMessage: true,
        ),
      );
      return;
    }

    final targetStatus = currentStatus.nextStatus;

    emit(
      state.copyWith(
        taskUpdateStatus: StudyPlanTaskUpdateStatus.loading,
        updatingTaskId: taskId,
        clearTaskUpdateMessage: true,
        clearError: true,
      ),
    );

    try {
      final result = await changeStudyTaskStatusUseCase(
        ChangeStudyTaskStatusParams(
          planId: planId,
          taskId: taskId,
          targetStatus: targetStatus,
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              taskUpdateStatus: StudyPlanTaskUpdateStatus.failure,
              clearUpdatingTaskId: true,
              clearTaskUpdateMessage: true,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          if (!response.success) {
            emit(
              state.copyWith(
                taskUpdateStatus: StudyPlanTaskUpdateStatus.failure,
                clearUpdatingTaskId: true,
                clearTaskUpdateMessage: true,
                errorTitle: response.title,
                errorMessage: response.message,
              ),
            );
            return;
          }

          final latestOverview = state.overview;

          if (latestOverview == null) {
            emit(
              state.copyWith(
                taskUpdateStatus: StudyPlanTaskUpdateStatus.failure,
                clearUpdatingTaskId: true,
                clearTaskUpdateMessage: true,
                errorTitle: 'تعذر تحديث الواجهة',
                errorMessage: 'بيانات الخطة لم تعد متاحة',
              ),
            );
            return;
          }

          final updatedTasks = latestOverview.data.tasks
              .map((task) {
                return task.id == taskId
                    ? task.copyWith(status: targetStatus.label)
                    : task;
              })
              .toList(growable: false);

          final updatedDays = _updateSelectedDayAfterTaskToggle(
            data: latestOverview.data,
            updatedTasks: updatedTasks,
          );
          final updatedData = latestOverview.data.copyWith(
            tasks: updatedTasks,
            days: updatedDays,
          );

          emit(
            state.copyWith(
              overview: latestOverview.copyWith(data: updatedData),
              taskUpdateStatus: StudyPlanTaskUpdateStatus.success,
              clearUpdatingTaskId: true,
              taskUpdateMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ StudyPlanHomeCubit._changeTaskStatus error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          taskUpdateStatus: StudyPlanTaskUpdateStatus.failure,
          clearUpdatingTaskId: true,
          clearTaskUpdateMessage: true,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر تغيير حالة المهمة',
        ),
      );
    }
  }

  Future<void> _toggleMockTaskStatus({required int taskId}) async {
    final currentOverview = state.overview;

    if (currentOverview == null || state.isTaskUpdating) {
      return;
    }

    final taskExists = currentOverview.data.tasks.any(
      (task) => task.id == taskId,
    );

    if (!taskExists) return;

    debugPrint('============ StudyPlanHomeCubit.toggleTaskStatus ============');
    debugPrint('→ taskId: $taskId');

    emit(
      state.copyWith(
        taskUpdateStatus: StudyPlanTaskUpdateStatus.loading,
        updatingTaskId: taskId,
        clearError: true,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 450));

    final updatedTasks = currentOverview.data.tasks.map((task) {
      if (task.id != taskId) {
        return task;
      }

      final newStatus = task.isCompleted ? 'للقيام' : 'تم الإنجاز';

      return task.copyWith(status: newStatus);
    }).toList();

    final updatedDays = _updateSelectedDayAfterTaskToggle(
      data: currentOverview.data,
      updatedTasks: updatedTasks,
    );

    final updatedData = currentOverview.data.copyWith(
      tasks: updatedTasks,
      days: updatedDays,
    );

    final updatedOverview = currentOverview.copyWith(data: updatedData);

    emit(
      state.copyWith(
        overview: updatedOverview,
        taskUpdateStatus: StudyPlanTaskUpdateStatus.success,
        clearUpdatingTaskId: true,
        clearError: true,
      ),
    );

    debugPrint('✓ task status changed locally');
    debugPrint('=================================================');
  }

  List<StudyPlanDayEntity> _updateSelectedDayAfterTaskToggle({
    required StudyPlanOverviewDataEntity data,
    required List<StudyPlanDailyTaskEntity> updatedTasks,
  }) {
    final completedCount = updatedTasks
        .where((task) => task.isCompleted)
        .length;

    final totalCount = updatedTasks.length;

    String displayState;

    if (totalCount == 0) {
      displayState = 'empty';
    } else if (completedCount == totalCount) {
      displayState = 'completed';
    } else {
      displayState = 'incompleted';
    }

    return data.days.map((day) {
      if (day.date != data.selectedDate) {
        return day;
      }

      return day.copyWith(
        hasTasks: totalCount > 0,
        totalTasks: totalCount,
        completedTasks: completedCount,
        completionState: completedCount == totalCount && totalCount > 0
            ? 'completed'
            : 'incompleted',
        displayState: day.isToday ? 'today' : displayState,
      );
    }).toList();
  }

  void resetTaskUpdateState() {
    emit(
      state.copyWith(
        taskUpdateStatus: StudyPlanTaskUpdateStatus.initial,
        clearUpdatingTaskId: true,
        clearTaskUpdateMessage: true,
        clearError: true,
      ),
    );
  }

  Future<void> refreshMockOverview() async {
    await loadInitialMock(scenario: state.activeMockScenario);
  }

  Future<void> refreshOverview() async {
    debugPrint('============ StudyPlanHomeCubit.refreshOverview ============');
    debugPrint('→ useMockData: $useMockData');

    if (useMockData) {
      debugPrint('→ refreshing current mock scenario');
      debugPrint('===========================================================');

      await refreshMockOverview();
      return;
    }

    final data = state.data;

    if (data == null) {
      debugPrint('✗ refreshOverview ignored: overview data is null');
      debugPrint('===========================================================');
      return;
    }

    final date = StudyPlanDateUtils.tryParseApiDate(data.selectedDate);

    final rangeStart = StudyPlanDateUtils.tryParseApiDate(data.range.start);

    final rangeEnd = StudyPlanDateUtils.tryParseApiDate(data.range.end);

    if (date == null || rangeStart == null || rangeEnd == null) {
      debugPrint('✗ refreshOverview failed: invalid dates');
      debugPrint('→ date: ${data.selectedDate}');
      debugPrint('→ rangeStart: ${data.range.start}');
      debugPrint('→ rangeEnd: ${data.range.end}');
      debugPrint('===========================================================');
      return;
    }

    debugPrint('→ refreshing date: ${data.selectedDate}');
    debugPrint('→ refreshing range: ${data.range.start} → ${data.range.end}');
    debugPrint('===========================================================');

    await getDailyOverview(
      date: date,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }

  /////////////////// API ///////////////////////
  /////////////////// API ///////////////////////
  /////////////////// API ///////////////////////
  /////////////////// API ///////////////////////
  Future<void> initialize({
    StudyPlanHomeMockScenario mockScenario =
        StudyPlanHomeMockScenario.planWithTasks,
    String weekStartsOn = 'السبت',
  }) async {
    debugPrint('============ StudyPlanHomeCubit.initialize ============');
    debugPrint('→ useMockData: $useMockData');
    debugPrint('→ mockScenario: $mockScenario');

    if (useMockData) {
      debugPrint('→ loading local mock overview');
      debugPrint('=======================================================');

      await loadInitialMock(scenario: mockScenario);
      return;
    }

    debugPrint('→ loading overview from API');

    final today = DateTime.now();

    final rangeStart = StudyPlanDateUtils.calculateWeekStart(
      date: today,
      weekStartsOn: weekStartsOn,
    );

    final rangeEnd = StudyPlanDateUtils.calculateWeekEnd(weekStart: rangeStart);

    debugPrint('→ initial date: ${StudyPlanDateUtils.formatApiDate(today)}');
    debugPrint(
      '→ initial rangeStart: ${StudyPlanDateUtils.formatApiDate(rangeStart)}',
    );
    debugPrint(
      '→ initial rangeEnd: ${StudyPlanDateUtils.formatApiDate(rangeEnd)}',
    );
    debugPrint('→ local weekStartsOn: $weekStartsOn');
    debugPrint('=======================================================');

    await getDailyOverview(
      date: today,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      clearPreviousData: true,
    );
  }

  Future<void> getDailyOverview({
    required DateTime date,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    bool clearPreviousData = false,
  }) async {
    debugPrint('============ StudyPlanHomeCubit.getDailyOverview ============');

    if (state.isLoading) {
      debugPrint('✗ getDailyOverview ignored: request already loading');
      debugPrint(
        '============================================================',
      );
      return;
    }

    final params = GetStudyPlanDailyOverviewParams(
      date: StudyPlanDateUtils.formatApiDate(date),
      rangeStart: StudyPlanDateUtils.formatApiDate(rangeStart),
      rangeEnd: StudyPlanDateUtils.formatApiDate(rangeEnd),
    );

    debugPrint('→ params: $params');
    debugPrint('→ clearPreviousData: $clearPreviousData');

    emit(
      state.copyWith(
        status: StudyPlanHomeStatus.loading,
        clearOverview: clearPreviousData,
        clearError: true,
      ),
    );

    try {
      final result = await getStudyPlanDailyOverviewUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ getDailyOverview failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              status: StudyPlanHomeStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ getDailyOverview success');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ serverToday: ${response.data.serverToday}');
          debugPrint('→ selectedDate: ${response.data.selectedDate}');
          debugPrint(
            '→ weekStartsOn: ${response.data.userSettings.weekStartsOn}',
          );
          debugPrint('→ timeFormat: ${response.data.userSettings.timeFormat}');
          debugPrint('→ rangeStart: ${response.data.range.start}');
          debugPrint('→ rangeEnd: ${response.data.range.end}');
          debugPrint('→ hasDefaultPlan: ${response.data.hasDefaultPlan}');
          debugPrint(
            '→ isSelectedDateInsidePlan: '
            '${response.data.isSelectedDateInsidePlan}',
          );
          debugPrint('→ planId: ${response.data.plan?.id}');
          debugPrint('→ days count: ${response.data.days.length}');
          debugPrint('→ tasks count: ${response.data.tasks.length}');

          final resolvedOverview = _resolveOverviewDays(response);

          debugPrint(
            '→ resolved days count: '
            '${resolvedOverview.data.days.length}',
          );

          emit(
            state.copyWith(
              status: StudyPlanHomeStatus.success,
              overview: resolvedOverview,
              clearError: true,
            ),
          );
        },
      );
    } finally {
      debugPrint(
        '============================================================',
      );
    }
  }

  StudyPlanOverviewEntity _resolveOverviewDays(
    StudyPlanOverviewEntity overview,
  ) {
    final data = overview.data;

    if (data.days.isNotEmpty) {
      debugPrint('→ using days returned by API');

      return overview;
    }

    debugPrint('→ API returned empty days, building week locally');

    final rangeStart = StudyPlanDateUtils.tryParseApiDate(data.range.start);

    if (rangeStart == null) {
      debugPrint(
        '✗ cannot build local week: invalid range start '
        '${data.range.start}',
      );

      return overview;
    }

    final localDays = _buildLocalWeekDays(
      weekStart: rangeStart,
      serverToday: data.serverToday,
    );

    final updatedData = data.copyWith(days: localDays);

    return overview.copyWith(data: updatedData);
  }

  Future<void> selectDay(StudyPlanDayEntity day) async {
    debugPrint('============ StudyPlanHomeCubit.selectDay ============');
    debugPrint('→ selected day: ${day.date}');

    final data = state.data;

    if (data == null) {
      debugPrint('✗ selectDay ignored: overview data is null');
      debugPrint('=====================================================');
      return;
    }

    if (state.isLoading) {
      debugPrint('✗ selectDay ignored: request is loading');
      debugPrint('=====================================================');
      return;
    }

    if (day.date == data.selectedDate) {
      debugPrint('✗ selectDay ignored: same selected date');
      debugPrint('=====================================================');
      return;
    }

    if (useMockData) {
      debugPrint('→ updating selected day locally using mock');

      await selectMockDay(day);
      return;
    }

    final selectedDate = StudyPlanDateUtils.tryParseApiDate(day.date);

    final rangeStart = StudyPlanDateUtils.tryParseApiDate(data.range.start);

    final rangeEnd = StudyPlanDateUtils.tryParseApiDate(data.range.end);

    if (selectedDate == null || rangeStart == null || rangeEnd == null) {
      debugPrint('✗ selectDay invalid date values');

      emit(
        state.copyWith(
          status: StudyPlanHomeStatus.failure,
          errorTitle: 'خطأ',
          errorMessage: 'تعذر قراءة تاريخ اليوم المحدد',
        ),
      );

      debugPrint('=====================================================');
      return;
    }

    debugPrint('→ API date: ${day.date}');
    debugPrint('→ API rangeStart: ${data.range.start}');
    debugPrint('→ API rangeEnd: ${data.range.end}');
    debugPrint('=====================================================');

    await getDailyOverview(
      date: selectedDate,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
  }

  Future<void> goToPreviousWeek() async {
    debugPrint('============ StudyPlanHomeCubit.goToPreviousWeek ============');

    await _moveWeek(daysOffset: -7);
  }

  Future<void> _moveWeek({required int daysOffset}) async {
    debugPrint('============ StudyPlanHomeCubit._moveWeek ============');
    debugPrint('→ daysOffset: $daysOffset');
    debugPrint('→ useMockData: $useMockData');

    final data = state.data;

    if (data == null) {
      debugPrint('✗ _moveWeek ignored: overview data is null');
      debugPrint('=====================================================');
      return;
    }

    if (state.isLoading) {
      debugPrint('✗ _moveWeek ignored: request is loading');
      debugPrint('=====================================================');
      return;
    }

    final currentDate = StudyPlanDateUtils.tryParseApiDate(data.selectedDate);

    if (currentDate == null) {
      debugPrint('✗ invalid selected date: ${data.selectedDate}');

      emit(
        state.copyWith(
          status: StudyPlanHomeStatus.failure,
          errorTitle: 'خطأ',
          errorMessage: 'تعذر قراءة تاريخ اليوم المحدد',
        ),
      );

      debugPrint('=====================================================');
      return;
    }

    // نحافظ على نفس اليوم داخل الأسبوع.
    final newDate = currentDate.add(Duration(days: daysOffset));

    final weekStartsOn = data.userSettings.weekStartsOn;

    final newRangeStart = StudyPlanDateUtils.calculateWeekStart(
      date: newDate,
      weekStartsOn: weekStartsOn,
    );

    final newRangeEnd = StudyPlanDateUtils.calculateWeekEnd(
      weekStart: newRangeStart,
    );

    debugPrint('→ currentDate: ${data.selectedDate}');
    debugPrint('→ newDate: ${StudyPlanDateUtils.formatApiDate(newDate)}');
    debugPrint('→ weekStartsOn: $weekStartsOn');
    debugPrint(
      '→ newRangeStart: ${StudyPlanDateUtils.formatApiDate(newRangeStart)}',
    );
    debugPrint(
      '→ newRangeEnd: ${StudyPlanDateUtils.formatApiDate(newRangeEnd)}',
    );

    if (useMockData) {
      debugPrint('→ updating week locally from mock');
      debugPrint('=====================================================');

      await _moveMockWeekLocally(
        newSelectedDate: newDate,
        newWeekStart: newRangeStart,
        newWeekEnd: newRangeEnd,
      );
      return;
    }

    debugPrint('→ requesting week from API');
    debugPrint('=====================================================');

    await getDailyOverview(
      date: newDate,
      rangeStart: newRangeStart,
      rangeEnd: newRangeEnd,
    );
  }

  Future<void> _moveMockWeekLocally({
    required DateTime newSelectedDate,
    required DateTime newWeekStart,
    required DateTime newWeekEnd,
  }) async {
    final currentOverview = state.overview;

    if (currentOverview == null) {
      debugPrint('✗ _moveMockWeekLocally: overview is null');
      return;
    }

    emit(state.copyWith(status: StudyPlanHomeStatus.loading, clearError: true));

    await Future.delayed(const Duration(milliseconds: 500));

    final newDays = _buildLocalWeekDays(
      weekStart: newWeekStart,
      serverToday: currentOverview.data.serverToday,
    );

    final updatedData = currentOverview.data.copyWith(
      selectedDate: StudyPlanDateUtils.formatApiDate(newSelectedDate),
      range: StudyPlanRangeEntity(
        start: StudyPlanDateUtils.formatApiDate(newWeekStart),
        end: StudyPlanDateUtils.formatApiDate(newWeekEnd),
      ),
      days: newDays,
      tasks: const [],
    );

    final updatedOverview = currentOverview.copyWith(data: updatedData);

    emit(
      state.copyWith(
        status: StudyPlanHomeStatus.success,
        overview: updatedOverview,
        clearError: true,
      ),
    );

    debugPrint('✓ mock week updated locally');
  }
}
