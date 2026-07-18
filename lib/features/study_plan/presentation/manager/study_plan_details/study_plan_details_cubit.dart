import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/delete_study_plan_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_details_overview_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/get_study_plan_details_tasks_use_case.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/delete_study_plan_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_overview_params.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plan_details_tasks_params.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';

class StudyPlanDetailsCubit extends Cubit<StudyPlanDetailsState> {
  final GetStudyPlanDetailsOverviewUseCase getStudyPlanDetailsOverviewUseCase;
  final GetStudyPlanDetailsTasksUseCase getStudyPlanDetailsTasksUseCase;
  int? _planId;

  final DeleteStudyPlanUseCase deleteStudyPlanUseCase;

  StudyPlanDetailsCubit({
    required this.getStudyPlanDetailsOverviewUseCase,
    required this.getStudyPlanDetailsTasksUseCase,
    required this.deleteStudyPlanUseCase,
  }) : super(const StudyPlanDetailsState()) {
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
        if (!state.hasTasksData && !state.isTasksLoading) {
          await getTasks();
        }
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
        await getTasks(forceRefresh: true);
        break;
    }

    debugPrint(
      '================================================================',
    );
  }

  Future<void> refreshAfterPlanUpdate() async {
    debugPrint(
      '============ StudyPlanDetailsCubit.refreshAfterPlanUpdate ============',
    );

    await getOverview(forceRefresh: true);

    if (state.hasTasksData) {
      await getTasks(forceRefresh: true);
    }

    debugPrint(
      '=====================================================================',
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

  Future<void> getTasks({bool forceRefresh = false}) async {
    debugPrint('============ StudyPlanDetailsCubit.getTasks ============');
    debugPrint('→ planId: $_planId');
    debugPrint('→ forceRefresh: $forceRefresh');

    final currentPlanId = _planId;

    if (currentPlanId == null || currentPlanId <= 0) {
      debugPrint('✗ invalid planId');

      emit(
        state.copyWith(
          tasksStatus: StudyPlanDetailsTasksStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة الدراسية غير صالح',
        ),
      );

      debugPrint('======================================================');
      return;
    }

    if (state.isTasksLoading) {
      debugPrint('→ ignored: tasks already loading');
      debugPrint('======================================================');
      return;
    }

    if (state.hasTasksData && !forceRefresh) {
      debugPrint('→ ignored: tasks already loaded');
      debugPrint('======================================================');
      return;
    }

    emit(
      state.copyWith(
        tasksStatus: StudyPlanDetailsTasksStatus.loading,
        clearError: true,
      ),
    );

    final params = GetStudyPlanDetailsTasksParams(planId: currentPlanId);

    debugPrint('→ params: $params');

    try {
      final result = await getStudyPlanDetailsTasksUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ getTasks failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              tasksStatus: StudyPlanDetailsTasksStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ getTasks success');
          debugPrint('→ old count: ${response.old.count}');
          debugPrint('→ upcoming count: ${response.upcoming.count}');
          debugPrint('→ completed count: ${response.completed.count}');

          emit(
            state.copyWith(
              tasksStatus: StudyPlanDetailsTasksStatus.success,
              tasks: response,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint('✗ getTasks unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          tasksStatus: StudyPlanDetailsTasksStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب مهام الخطة الدراسية',
        ),
      );
    } finally {
      debugPrint('======================================================');
    }
  }

  void searchTasks(String value) {
    debugPrint('============ StudyPlanDetailsCubit.searchTasks ============');
    debugPrint('→ query: $value');

    emit(state.copyWith(tasksSearchQuery: value));
  }

  void clearTasksSearch() {
    if (state.tasksSearchQuery.isEmpty) {
      return;
    }

    debugPrint(
      '============ StudyPlanDetailsCubit.clearTasksSearch ============',
    );

    emit(state.copyWith(tasksSearchQuery: ''));
  }

  void toggleOldTasks() {
    emit(state.copyWith(isOldExpanded: !state.isOldExpanded));
  }

  void toggleUpcomingTasks() {
    emit(state.copyWith(isUpcomingExpanded: !state.isUpcomingExpanded));
  }

  void toggleCompletedTasks() {
    emit(state.copyWith(isCompletedExpanded: !state.isCompletedExpanded));
  }

  ////////////////// delete STUDY PLAN ///////////////

  Future<void> deleteStudyPlan({required int planId}) async {
    debugPrint(
      '============ StudyPlanDetailsCubit.deleteStudyPlan ============',
    );
    debugPrint('→ planId: $planId');
    debugPrint('→ current deleteStatus: ${state.deleteStatus}');

    if (state.isDeleteLoading) {
      debugPrint('→ delete already loading, request ignored');
      return;
    }

    if (planId <= 0) {
      debugPrint('✗ invalid planId');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudyPlanStatus.failure,
          deleteErrorTitle: 'خطأ',
          deleteErrorMessage: 'معرّف الخطة الدراسية غير صالح',
          clearDeleteSuccessData: true,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        deleteStatus: DeleteStudyPlanStatus.loading,
        clearDeleteSuccessData: true,
        clearDeleteError: true,
      ),
    );

    final params = DeleteStudyPlanParams(planId: planId);

    debugPrint('→ params: $params');

    final result = await deleteStudyPlanUseCase(params);

    result.fold(
      (failure) {
        debugPrint('✗ delete study plan failed');
        debugPrint('→ failure: $failure');

        emit(
          state.copyWith(
            deleteStatus: DeleteStudyPlanStatus.failure,
            deleteErrorTitle: failure.title ?? 'تعذر حذف الخطة',
            deleteErrorMessage:
                failure.message ?? 'حدث خطأ أثناء حذف الخطة الدراسية',
            clearDeleteSuccessData: true,
          ),
        );
      },
      (response) {
        debugPrint('✓ delete study plan succeeded');
        debugPrint('→ success: ${response.success}');
        debugPrint('→ title: ${response.title}');
        debugPrint('→ message: ${response.message}');
        debugPrint('→ statusCode: ${response.statusCode}');

        if (!response.success) {
          emit(
            state.copyWith(
              deleteStatus: DeleteStudyPlanStatus.failure,
              deleteErrorTitle: response.title.isNotEmpty
                  ? response.title
                  : 'تعذر حذف الخطة',
              deleteErrorMessage: response.message.isNotEmpty
                  ? response.message
                  : 'تعذر حذف الخطة الدراسية',
              clearDeleteSuccessData: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            deleteStatus: DeleteStudyPlanStatus.success,
            deleteSuccessTitle: response.title.isNotEmpty
                ? response.title
                : 'تم بنجاح',
            deleteSuccessMessage: response.message.isNotEmpty
                ? response.message
                : 'تم حذف الخطة الدراسية بنجاح',
            clearDeleteError: true,
          ),
        );
      },
    );

    debugPrint(
      '===============================================================',
    );
  }

  void resetDeleteState() {
    debugPrint(
      '============ StudyPlanDetailsCubit.resetDeleteState ============',
    );

    emit(
      state.copyWith(
        deleteStatus: DeleteStudyPlanStatus.initial,
        clearDeleteSuccessData: true,
        clearDeleteError: true,
      ),
    );
  }
}
