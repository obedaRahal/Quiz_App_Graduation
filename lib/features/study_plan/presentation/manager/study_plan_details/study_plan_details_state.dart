import 'package:quiz_app_grad/features/study_plan/domain/entities/details/study_plan_details_subject_entity.dart';

enum StudyPlanDetailsTab { overview, tasks }

enum StudyPlanDetailsOverviewStatus { initial, loading, success, failure }

class StudyPlanDetailsState {
  final StudyPlanDetailsTab selectedTab;

  final StudyPlanDetailsOverviewStatus overviewStatus;
  final StudyPlanDetailsOverviewEntity? overview;

  final String? errorTitle;
  final String? errorMessage;

  const StudyPlanDetailsState({
    this.selectedTab = StudyPlanDetailsTab.overview,
    this.overviewStatus = StudyPlanDetailsOverviewStatus.initial,
    this.overview,
    this.errorTitle,
    this.errorMessage,
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

  StudyPlanDetailsState copyWith({
    StudyPlanDetailsTab? selectedTab,
    StudyPlanDetailsOverviewStatus? overviewStatus,
    StudyPlanDetailsOverviewEntity? overview,
    String? errorTitle,
    String? errorMessage,
    bool clearOverview = false,
    bool clearError = false,
  }) {
    return StudyPlanDetailsState(
      selectedTab: selectedTab ?? this.selectedTab,
      overviewStatus: overviewStatus ?? this.overviewStatus,
      overview: clearOverview ? null : overview ?? this.overview,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
