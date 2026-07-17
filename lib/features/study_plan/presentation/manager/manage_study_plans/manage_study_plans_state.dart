import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';

enum ManageStudyPlansStatus { initial, loading, success, failure }

class ManageStudyPlansState {
  static const int maxPlansCount = 5;

  final ManageStudyPlansStatus status;
  final StudyPlansTab selectedTab;

  final int plansCount;
  final List<ManagedStudyPlanEntity> plans;

  final String searchQuery;

  final String? errorTitle;
  final String? errorMessage;

  const ManageStudyPlansState({
    this.status = ManageStudyPlansStatus.initial,
    this.selectedTab = StudyPlansTab.current,
    this.plansCount = 0,
    this.plans = const [],
    this.searchQuery = '',
    this.errorTitle,
    this.errorMessage,
  });

  bool get isInitial => status == ManageStudyPlansStatus.initial;

  bool get isLoading => status == ManageStudyPlansStatus.loading;

  bool get isSuccess => status == ManageStudyPlansStatus.success;

  bool get isFailure => status == ManageStudyPlansStatus.failure;

  bool get hasPlans => plans.isNotEmpty;

  bool get hasNoPlans => plans.isEmpty;

  bool get hasSearchQuery => searchQuery.trim().isNotEmpty;

  bool get hasReachedPlansLimit => plansCount >= maxPlansCount;

  String get plansLimitLabel => '$plansCount/$maxPlansCount';

  bool get hasCachedPlans => plans.isNotEmpty;

  List<ManagedStudyPlanEntity> get filteredPlans {
    final normalizedQuery = _normalizeSearchValue(searchQuery);

    if (normalizedQuery.isEmpty) {
      return plans;
    }

    return plans.where((plan) {
      final normalizedTitle = _normalizeSearchValue(plan.title);

      return normalizedTitle.contains(normalizedQuery);
    }).toList();
  }

  bool get hasFilteredPlans => filteredPlans.isNotEmpty;

  bool get searchHasNoResults {
    return hasSearchQuery && plans.isNotEmpty && filteredPlans.isEmpty;
  }

  ManageStudyPlansState copyWith({
    ManageStudyPlansStatus? status,
    StudyPlansTab? selectedTab,
    int? plansCount,
    List<ManagedStudyPlanEntity>? plans,
    String? searchQuery,
    String? errorTitle,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ManageStudyPlansState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
      plansCount: plansCount ?? this.plansCount,
      plans: plans ?? this.plans,
      searchQuery: searchQuery ?? this.searchQuery,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  static String _normalizeSearchValue(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
  }
}
