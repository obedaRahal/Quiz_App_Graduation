import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_overview_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/mock/study_plan_home_mock_scenario.dart';

enum StudyPlanHomeStatus { initial, loading, success, failure }

enum StudyPlanTaskUpdateStatus { initial, loading, success, failure }

class StudyPlanHomeState {
  final StudyPlanHomeStatus status;
  final StudyPlanOverviewEntity? overview;

  final StudyPlanHomeMockScenario activeMockScenario;

  final StudyPlanTaskUpdateStatus taskUpdateStatus;
  final int? updatingTaskId;
  final String? taskUpdateMessage;

  final String? errorTitle;
  final String? errorMessage;

  const StudyPlanHomeState({
    this.status = StudyPlanHomeStatus.initial,
    this.overview,
    this.activeMockScenario = StudyPlanHomeMockScenario.noPlan,
    this.taskUpdateStatus = StudyPlanTaskUpdateStatus.initial,
    this.updatingTaskId,
    this.taskUpdateMessage,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isInitial => status == StudyPlanHomeStatus.initial;

  bool get isLoading => status == StudyPlanHomeStatus.loading;

  bool get isSuccess => status == StudyPlanHomeStatus.success;

  bool get isFailure => status == StudyPlanHomeStatus.failure;

  bool get isTaskUpdating =>
      taskUpdateStatus == StudyPlanTaskUpdateStatus.loading;

  bool get isTaskUpdateSuccess =>
      taskUpdateStatus == StudyPlanTaskUpdateStatus.success;

  bool get isTaskUpdateFailure =>
      taskUpdateStatus == StudyPlanTaskUpdateStatus.failure;

  StudyPlanOverviewDataEntity? get data => overview?.data;

  bool get hasDefaultPlan => data?.hasDefaultPlan ?? false;

  bool get hasPlan => data?.hasPlan ?? false;

  bool get hasTasks => data?.tasks.isNotEmpty ?? false;

  bool get hasNoPlan => !hasDefaultPlan || data?.plan == null;

  bool get hasPlanWithoutTasks => hasPlan && !hasTasks;

  bool get hasPlanWithTasks => hasPlan && hasTasks;

  bool get isSelectedDateInsidePlan => data?.selectedDateIsInsidePlan ?? false;

  String get selectedDate => data?.selectedDate ?? '';

  String get serverToday => data?.serverToday ?? '';

  String get weekStartsOn => data?.userSettings.weekStartsOn ?? 'السبت';

  String get timeFormat => data?.userSettings.timeFormat ?? '12 ساعة';

  String get rangeStart => data?.range.start ?? '';

  String get rangeEnd => data?.range.end ?? '';

  List<StudyPlanDayEntity> get days => data?.days ?? const [];

  List<StudyPlanDailyTaskEntity> get tasks => data?.tasks ?? const [];

  int get dailyTasksCount => tasks.length;

  bool isUpdatingTask(int taskId) {
    return isTaskUpdating && updatingTaskId == taskId;
  }

  StudyPlanHomeState copyWith({
    StudyPlanHomeStatus? status,
    StudyPlanOverviewEntity? overview,
    bool clearOverview = false,

    StudyPlanHomeMockScenario? activeMockScenario,

    StudyPlanTaskUpdateStatus? taskUpdateStatus,
    int? updatingTaskId,
    bool clearUpdatingTaskId = false,
    String? taskUpdateMessage,
    bool clearTaskUpdateMessage = false,

    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StudyPlanHomeState(
      status: status ?? this.status,

      overview: clearOverview ? null : overview ?? this.overview,

      activeMockScenario: activeMockScenario ?? this.activeMockScenario,

      taskUpdateStatus: taskUpdateStatus ?? this.taskUpdateStatus,

      updatingTaskId: clearUpdatingTaskId
          ? null
          : updatingTaskId ?? this.updatingTaskId,

      taskUpdateMessage: clearTaskUpdateMessage
          ? null
          : taskUpdateMessage ?? this.taskUpdateMessage,

      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
