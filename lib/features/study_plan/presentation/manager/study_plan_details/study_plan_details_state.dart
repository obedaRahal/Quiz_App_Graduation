import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_tasks_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_daily_task_entity.dart';

enum StudyPlanDetailsTab { overview, tasks }

enum StudyPlanDetailsOverviewStatus { initial, loading, success, failure }

enum StudyPlanDetailsTasksStatus { initial, loading, success, failure }

class StudyPlanDetailsState {
  final StudyPlanDetailsTab selectedTab;

  final StudyPlanDetailsOverviewStatus overviewStatus;
  final StudyPlanDetailsOverviewEntity? overview;

  final String? errorTitle;
  final String? errorMessage;

  final StudyPlanDetailsTasksStatus tasksStatus;
  final StudyPlanDetailsTasksEntity? tasks;
  final String tasksSearchQuery;
  final bool isOldExpanded;
  final bool isUpcomingExpanded;
  final bool isCompletedExpanded;

  const StudyPlanDetailsState({
    this.selectedTab = StudyPlanDetailsTab.overview,
    this.overviewStatus = StudyPlanDetailsOverviewStatus.initial,
    this.overview,
    this.errorTitle,
    this.errorMessage,

    this.tasksStatus = StudyPlanDetailsTasksStatus.initial,
    this.tasks,
    this.tasksSearchQuery = '',
    this.isOldExpanded = true,
    this.isUpcomingExpanded = true,
    this.isCompletedExpanded = true,
  });

  bool get isOverviewInitial =>
      overviewStatus == StudyPlanDetailsOverviewStatus.initial;
  bool get isOverviewLoading =>
      overviewStatus == StudyPlanDetailsOverviewStatus.loading;
  bool get isOverviewSuccess =>
      overviewStatus == StudyPlanDetailsOverviewStatus.success;
  bool get isOverviewFailure =>
      overviewStatus == StudyPlanDetailsOverviewStatus.failure;

  bool get hasOverview => overview != null;

  bool get isOverviewTab => selectedTab == StudyPlanDetailsTab.overview;
  bool get isTasksTab => selectedTab == StudyPlanDetailsTab.tasks;

  bool get isTasksInitial => tasksStatus == StudyPlanDetailsTasksStatus.initial;
  bool get isTasksLoading => tasksStatus == StudyPlanDetailsTasksStatus.loading;
  bool get isTasksSuccess => tasksStatus == StudyPlanDetailsTasksStatus.success;
  bool get isTasksFailure => tasksStatus == StudyPlanDetailsTasksStatus.failure;

  bool get hasTasksData => tasks != null;

  String get normalizedTasksSearchQuery =>
      tasksSearchQuery.trim().toLowerCase();
  List<StudyPlanDailyTaskEntity> get filteredOldTasks {
    return _filterTasks(tasks?.old.tasks ?? const []);
  }

  List<StudyPlanDailyTaskEntity> get filteredUpcomingTasks {
    return _filterTasks(tasks?.upcoming.tasks ?? const []);
  }

  List<StudyPlanDailyTaskEntity> get filteredCompletedTasks {
    return _filterTasks(tasks?.completed.tasks ?? const []);
  }

  List<StudyPlanDailyTaskEntity> _filterTasks(
    List<StudyPlanDailyTaskEntity> items,
  ) {
    final query = normalizedTasksSearchQuery;
    if (query.isEmpty) {
      return items;
    }
    return items.where((task) {
      return task.title.trim().toLowerCase().contains(query);
    }).toList();
  }

  bool get hasSearchResults {
    return filteredOldTasks.isNotEmpty ||
        filteredUpcomingTasks.isNotEmpty ||
        filteredCompletedTasks.isNotEmpty;
  }

  StudyPlanDetailsState copyWith({
    StudyPlanDetailsTab? selectedTab,
    StudyPlanDetailsOverviewStatus? overviewStatus,
    StudyPlanDetailsOverviewEntity? overview,
    String? errorTitle,
    String? errorMessage,
    bool clearOverview = false,
    bool clearError = false,

    StudyPlanDetailsTasksStatus? tasksStatus,
    StudyPlanDetailsTasksEntity? tasks,
    String? tasksSearchQuery,
    bool? isOldExpanded,
    bool? isUpcomingExpanded,
    bool? isCompletedExpanded,
    bool clearTasks = false,
  }) {
    return StudyPlanDetailsState(
      selectedTab: selectedTab ?? this.selectedTab,
      overviewStatus: overviewStatus ?? this.overviewStatus,
      overview: clearOverview ? null : overview ?? this.overview,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      tasksStatus: tasksStatus ?? this.tasksStatus,
      tasks: clearTasks ? null : tasks ?? this.tasks,
      tasksSearchQuery: tasksSearchQuery ?? this.tasksSearchQuery,
      isOldExpanded: isOldExpanded ?? this.isOldExpanded,
      isUpcomingExpanded: isUpcomingExpanded ?? this.isUpcomingExpanded,
      isCompletedExpanded: isCompletedExpanded ?? this.isCompletedExpanded,
    );
  }
}
