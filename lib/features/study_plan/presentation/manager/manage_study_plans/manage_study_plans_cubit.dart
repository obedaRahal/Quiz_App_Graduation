import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/manage/managed_study_plan_entity.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plans_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/manage_study_plans/manage_study_plans_state.dart';

class ManageStudyPlansCubit extends Cubit<ManageStudyPlansState> {
  final GetStudyPlansUseCase getStudyPlansUseCase;

  ManageStudyPlansCubit({required this.getStudyPlansUseCase})
    : super(const ManageStudyPlansState()) {
    debugPrint('============ ManageStudyPlansCubit INIT ============');
  }

  // =========================================================
  // INITIALIZE
  // =========================================================

  Future<void> initialize() async {
    debugPrint('============ ManageStudyPlansCubit.initialize ============');
    debugPrint('→ default tab: ${state.selectedTab.apiValue}');

    await getPlans();

    debugPrint('==========================================================');
  }

  // =========================================================
  // GET PLANS
  // =========================================================

  Future<void> getPlans({bool showFullLoading = true}) async {
    debugPrint('============ ManageStudyPlansCubit.getPlans ============');
    debugPrint('→ selected tab: ${state.selectedTab.apiValue}');
    debugPrint('→ showFullLoading: $showFullLoading');

    if (state.isLoading) {
      debugPrint('✗ getPlans ignored: request already loading');
      debugPrint('=========================================================');
      return;
    }

    if (showFullLoading) {
      emit(
        state.copyWith(
          status: ManageStudyPlansStatus.loading,
          clearError: true,
        ),
      );
    } else {
      emit(state.copyWith(clearError: true));
    }

    final params = GetStudyPlansParams(tab: state.selectedTab);

    debugPrint('→ params: $params');
    debugPrint('→ queryParameters: ${params.toQueryParameters()}');

    try {
      final result = await getStudyPlansUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ ManageStudyPlansCubit.getPlans failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          final nextStatus = !showFullLoading && state.plans.isNotEmpty
              ? ManageStudyPlansStatus.success
              : ManageStudyPlansStatus.failure;

          emit(
            state.copyWith(
              status: nextStatus,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ ManageStudyPlansCubit.getPlans success');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ plansCount: ${response.plansCount}');
          debugPrint('→ plans length: ${response.plans.length}');

          for (final plan in response.plans) {
            debugPrint(
              '→ plan: '
              'id=${plan.id}, '
              'title=${plan.title}, '
              'isDefault=${plan.isDefault}, '
              'hours=${plan.dailyStudyHours}, '
              'subjects=${plan.subjectsCount}',
            );
          }

          emit(
            state.copyWith(
              status: ManageStudyPlansStatus.success,
              plansCount: response.plansCount,
              plans: List<ManagedStudyPlanEntity>.unmodifiable(response.plans),
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ ManageStudyPlansCubit.getPlans unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          status: ManageStudyPlansStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب الخطط الدراسية',
        ),
      );
    } finally {
      debugPrint('=========================================================');
    }
  }

  // =========================================================
  // CHANGE TAB
  // =========================================================

  Future<void> changeTab(StudyPlansTab tab) async {
    debugPrint('============ ManageStudyPlansCubit.changeTab ============');
    debugPrint('→ current tab: ${state.selectedTab.apiValue}');
    debugPrint('→ new tab: ${tab.apiValue}');

    if (tab == state.selectedTab) {
      debugPrint('✗ changeTab ignored: tab already selected');
      debugPrint('=========================================================');
      return;
    }

    emit(
      state.copyWith(
        selectedTab: tab,
        searchQuery: '',
        plans: const [],
        clearError: true,
      ),
    );

    await getPlans();

    debugPrint('=========================================================');
  }

  // =========================================================
  // SEARCH
  // =========================================================

  void changeSearchQuery(String value) {
    debugPrint(
      '============ ManageStudyPlansCubit.changeSearchQuery ============',
    );
    debugPrint('→ query: "$value"');

    emit(state.copyWith(searchQuery: value));

    debugPrint('→ filtered plans count: ${state.filteredPlans.length}');
    debugPrint(
      '================================================================',
    );
  }

  void clearSearch() {
    debugPrint('============ ManageStudyPlansCubit.clearSearch ============');

    if (state.searchQuery.isEmpty) {
      debugPrint('→ search already empty');
      return;
    }

    emit(state.copyWith(searchQuery: ''));

    debugPrint('✓ search cleared');
  }

  // =========================================================
  // REFRESH AND RETRY
  // =========================================================

  Future<void> refreshPlans() async {
    debugPrint('============ ManageStudyPlansCubit.refreshPlans ============');

    await getPlans(showFullLoading: false);
  }

  Future<void> retry() async {
    debugPrint('============ ManageStudyPlansCubit.retry ============');

    await getPlans();
  }

  // =========================================================
  // RESET ERROR
  // =========================================================

  void resetError() {
    emit(state.copyWith(clearError: true));
  }

  /////////////////////
  void markDataChanged() {
    if (state.hasDataChanges) {
      debugPrint('→ ManageStudyPlansCubit already marked as changed');
      return;
    }

    debugPrint('✓ ManageStudyPlansCubit marked as changed');

    emit(state.copyWith(hasDataChanges: true));
  }
}
