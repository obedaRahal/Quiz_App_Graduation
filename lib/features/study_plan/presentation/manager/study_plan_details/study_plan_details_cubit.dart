import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';

class StudyPlanDetailsCubit extends Cubit<StudyPlanDetailsState> {
  final GetStudyPlanDetailsOverviewUseCase getStudyPlanDetailsOverviewUseCase;

  int? _planId;

  StudyPlanDetailsCubit({required this.getStudyPlanDetailsOverviewUseCase})
    : super(const StudyPlanDetailsState()) {
    debugPrint('============ StudyPlanDetailsCubit INIT ============');
  }

  int? get planId => _planId;

  Future<void> initialize({required int planId}) async {
    debugPrint('============ StudyPlanDetailsCubit.initialize ============');
    debugPrint('→ planId: $planId');

    _planId = planId;

    if (planId <= 0) {
      debugPrint('✗ initialize failed: invalid planId');

      emit(
        state.copyWith(
          overviewStatus: StudyPlanDetailsOverviewStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      debugPrint('=========================================================');
      return;
    }

    await getOverview();

    debugPrint('=========================================================');
  }

  // =========================================================
  // CHANGE TAB
  // =========================================================

  Future<void> changeTab(StudyPlanDetailsTab tab) async {
    debugPrint('============ StudyPlanDetailsCubit.changeTab ============');
    debugPrint('→ current tab: ${state.selectedTab.name}');
    debugPrint('→ new tab: ${tab.name}');

    if (tab == state.selectedTab) {
      debugPrint('→ ignored: tab already selected');
      debugPrint('========================================================');
      return;
    }

    emit(state.copyWith(selectedTab: tab, clearError: true));

    switch (tab) {
      case StudyPlanDetailsTab.overview:
        if (!state.hasOverview && !state.isOverviewLoading) {
          await getOverview();
        }
        break;

      case StudyPlanDetailsTab.tasks:
        /*
         * سنستدعي هنا لاحقًا:
         *
         * if (!state.hasTasks) {
         *   await getTasks();
         * }
         */
        debugPrint('→ tasks tab selected; API will be connected next');
        break;
    }

    debugPrint('========================================================');
  }

  // =========================================================
  // GET OVERVIEW
  // =========================================================

  Future<void> getOverview({bool forceRefresh = false}) async {
    debugPrint('============ StudyPlanDetailsCubit.getOverview ============');
    debugPrint('→ planId: $_planId');
    debugPrint('→ forceRefresh: $forceRefresh');

    final currentPlanId = _planId;

    if (currentPlanId == null || currentPlanId <= 0) {
      debugPrint('✗ getOverview failed: invalid planId');

      emit(
        state.copyWith(
          overviewStatus: StudyPlanDetailsOverviewStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      debugPrint('=========================================================');
      return;
    }

    if (state.isOverviewLoading) {
      debugPrint('→ request ignored: overview already loading');
      debugPrint('=========================================================');
      return;
    }

    if (state.hasOverview && !forceRefresh) {
      debugPrint('→ request ignored: overview already loaded');
      debugPrint('=========================================================');
      return;
    }

    emit(
      state.copyWith(
        overviewStatus: StudyPlanDetailsOverviewStatus.loading,
        clearError: true,
      ),
    );

    final params = GetStudyPlanDetailsOverviewParams(planId: currentPlanId);

    debugPrint('→ params: $params');

    try {
      final result = await getStudyPlanDetailsOverviewUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ StudyPlanDetailsCubit.getOverview failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              overviewStatus: StudyPlanDetailsOverviewStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (overview) {
          debugPrint('✓ StudyPlanDetailsCubit.getOverview success');
          debugPrint('→ response title: ${overview.title}');
          debugPrint('→ planId: ${overview.id}');
          debugPrint('→ planTitle: ${overview.planTitle}');
          debugPrint(
            '→ subjectsCount: '
            '${overview.subjects.count}',
          );
          debugPrint(
            '→ subjectsLabel: '
            '${overview.subjects.label}',
          );
          debugPrint(
            '→ remainingDays: '
            '${overview.progress.remainingDays}',
          );
          debugPrint(
            '→ elapsedLabel: '
            '${overview.progress.elapsedLabel}',
          );
          debugPrint(
            '→ completedPercentage: '
            '${overview.progress.completedPercentage}',
          );

          emit(
            state.copyWith(
              overviewStatus: StudyPlanDetailsOverviewStatus.success,
              overview: overview,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyPlanDetailsCubit.getOverview '
        'unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          overviewStatus: StudyPlanDetailsOverviewStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب تفاصيل الخطة الدراسية',
        ),
      );
    } finally {
      debugPrint('=========================================================');
    }
  }

  // =========================================================
  // REFRESH
  // =========================================================

  Future<void> refreshCurrentTab() async {
    debugPrint(
      '============ StudyPlanDetailsCubit.refreshCurrentTab ============',
    );
    debugPrint('→ selectedTab: ${state.selectedTab.name}');

    switch (state.selectedTab) {
      case StudyPlanDetailsTab.overview:
        await getOverview(forceRefresh: true);
        break;

      case StudyPlanDetailsTab.tasks:
        debugPrint('→ tasks refresh will be connected next');
        break;
    }

    debugPrint(
      '================================================================',
    );
  }

  Future<void> retryOverview() async {
    debugPrint('============ StudyPlanDetailsCubit.retryOverview ============');

    await getOverview(forceRefresh: true);
  }

  void clearError() {
    if (state.errorTitle == null && state.errorMessage == null) {
      return;
    }

    emit(state.copyWith(clearError: true));
  }
}
