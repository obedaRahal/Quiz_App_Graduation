import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/get_study_task_details_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_state.dart';

class StudyTaskDetailsCubit extends Cubit<StudyTaskDetailsState> {
  final GetStudyTaskDetailsUseCase getStudyTaskDetailsUseCase;

  StudyTaskDetailsCubit({required this.getStudyTaskDetailsUseCase})
    : super(const StudyTaskDetailsState()) {
    debugPrint('============ StudyTaskDetailsCubit INIT ============');
  }

  // =========================================================
  // GET TASK DETAILS
  // =========================================================

  Future<void> getStudyTaskDetails({
    required int planId,
    required int taskId,
  }) async {
    debugPrint(
      '============ StudyTaskDetailsCubit.getStudyTaskDetails ============',
    );
    debugPrint('→ planId: $planId');
    debugPrint('→ taskId: $taskId');

    if (state.isLoading) {
      debugPrint('✗ getStudyTaskDetails ignored: request already loading');
      debugPrint(
        '=================================================================',
      );
      return;
    }

    if (planId <= 0 || taskId <= 0) {
      debugPrint('✗ invalid planId or taskId');

      emit(
        state.copyWith(
          loadStatus: StudyTaskDetailsLoadStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة أو المهمة غير صالح',
        ),
      );

      debugPrint(
        '=================================================================',
      );
      return;
    }

    emit(
      state.copyWith(
        loadStatus: StudyTaskDetailsLoadStatus.loading,
        clearError: true,
        clearActionMessage: true,
      ),
    );

    try {
      final params = GetStudyTaskDetailsParams(planId: planId, taskId: taskId);

      debugPrint('→ params: $params');

      final result = await getStudyTaskDetailsUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ StudyTaskDetailsCubit.getStudyTaskDetails failure');
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              loadStatus: StudyTaskDetailsLoadStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint('✓ StudyTaskDetailsCubit.getStudyTaskDetails success');
          debugPrint('→ taskId: ${response.data.basicInfo.id}');
          debugPrint('→ title: ${response.data.basicInfo.title}');
          debugPrint('→ status: ${response.data.basicInfo.status}');
          debugPrint('→ subtasks: ${response.data.subtasks.length}');

          emit(
            state.copyWith(
              taskDetails: response,
              loadStatus: StudyTaskDetailsLoadStatus.success,
              changeStatus: ChangeStudyTaskStatus.initial,
              toggleSubTaskStatus: ToggleStudySubTaskStatus.initial,
              deleteStatus: DeleteStudyTaskStatus.initial,
              clearUpdatingSubTaskId: true,
              clearDeletedTaskId: true,
              clearActionMessage: true,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskDetailsCubit.getStudyTaskDetails unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          loadStatus: StudyTaskDetailsLoadStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر جلب تفاصيل المهمة',
        ),
      );
    } finally {
      debugPrint(
        '=================================================================',
      );
    }
  }

  // =========================================================
  // CHANGE TASK STATUS LOCALLY
  // =========================================================

  void changeTaskStatus() {
    debugPrint(
      '============ StudyTaskDetailsCubit.changeTaskStatus ============',
    );

    if (state.isChangeStatusLoading) {
      debugPrint('✗ changeTaskStatus ignored: operation already loading');
      debugPrint(
        '===============================================================',
      );
      return;
    }

    final currentTask = state.taskDetails;

    if (currentTask == null) {
      debugPrint('✗ task details are not available');

      emit(
        state.copyWith(
          changeStatus: ChangeStudyTaskStatus.failure,
          errorTitle: 'تعذر تنفيذ العملية',
          errorMessage: 'تفاصيل المهمة غير متاحة',
        ),
      );

      debugPrint(
        '===============================================================',
      );
      return;
    }

    emit(
      state.copyWith(
        changeStatus: ChangeStudyTaskStatus.loading,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final currentStatus = currentTask.data.basicInfo.status;

      final newStatus = currentStatus.nextStatus;

      debugPrint('→ old status: $currentStatus');
      debugPrint('→ new status: $newStatus');

      final updatedBasicInfo = currentTask.data.basicInfo.copyWith(
        status: newStatus,
      );

      final updatedData = currentTask.data.copyWith(
        basicInfo: updatedBasicInfo,
      );

      final updatedTask = StudyTaskDetailsEntity(
        success: currentTask.success,
        title: currentTask.title,
        data: updatedData,
        statusCode: currentTask.statusCode,
      );

      emit(
        state.copyWith(
          taskDetails: updatedTask,
          changeStatus: ChangeStudyTaskStatus.success,
          actionMessage: _statusActionMessage(newStatus),
          clearError: true,
        ),
      );

      debugPrint('✓ task status changed locally');
    } catch (error, stackTrace) {
      debugPrint('✗ StudyTaskDetailsCubit.changeTaskStatus unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          changeStatus: ChangeStudyTaskStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر تغيير حالة المهمة',
        ),
      );
    } finally {
      debugPrint(
        '===============================================================',
      );
    }
  }

  // =========================================================
  // TOGGLE SUBTASK STATUS LOCALLY
  // =========================================================

  void toggleSubTaskStatus({required int subTaskId}) {
    debugPrint(
      '============ StudyTaskDetailsCubit.toggleSubTaskStatus ============',
    );
    debugPrint('→ subTaskId: $subTaskId');

    if (state.isToggleSubTaskLoading) {
      debugPrint('✗ toggleSubTaskStatus ignored: operation already loading');
      debugPrint(
        '=================================================================',
      );
      return;
    }

    final currentTask = state.taskDetails;

    if (currentTask == null) {
      debugPrint('✗ task details are not available');

      emit(
        state.copyWith(
          toggleSubTaskStatus: ToggleStudySubTaskStatus.failure,
          errorTitle: 'تعذر تنفيذ العملية',
          errorMessage: 'تفاصيل المهمة غير متاحة',
        ),
      );

      debugPrint(
        '=================================================================',
      );
      return;
    }

    final subTaskExists = currentTask.data.subtasks.any(
      (subTask) => subTask.id == subTaskId,
    );

    if (!subTaskExists) {
      debugPrint('✗ subtask not found');

      emit(
        state.copyWith(
          toggleSubTaskStatus: ToggleStudySubTaskStatus.failure,
          errorTitle: 'تعذر تنفيذ العملية',
          errorMessage: 'المهمة الفرعية غير موجودة',
        ),
      );

      debugPrint(
        '=================================================================',
      );
      return;
    }

    emit(
      state.copyWith(
        toggleSubTaskStatus: ToggleStudySubTaskStatus.loading,
        updatingSubTaskId: subTaskId,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final updatedSubTasks = currentTask.data.subtasks.map((subTask) {
        if (subTask.id != subTaskId) {
          return subTask;
        }

        debugPrint(
          '→ isCompleted: '
          '${subTask.isCompleted} → ${!subTask.isCompleted}',
        );

        return subTask.copyWith(isCompleted: !subTask.isCompleted);
      }).toList();

      final completedCount = updatedSubTasks
          .where((subTask) => subTask.isCompleted)
          .length;

      final totalCount = updatedSubTasks.length;

      final updatedCount = currentTask.data.basicInfo.subtasksCount.copyWith(
        completed: completedCount,
        total: totalCount,
        label: '$completedCount من $totalCount',
      );

      final updatedBasicInfo = currentTask.data.basicInfo.copyWith(
        subtasksCount: updatedCount,
      );

      final updatedData = currentTask.data.copyWith(
        basicInfo: updatedBasicInfo,
        subtasks: List<StudySubTaskEntity>.unmodifiable(updatedSubTasks),
      );

      final updatedTask = StudyTaskDetailsEntity(
        success: currentTask.success,
        title: currentTask.title,
        data: updatedData,
        statusCode: currentTask.statusCode,
      );

      emit(
        state.copyWith(
          taskDetails: updatedTask,
          toggleSubTaskStatus: ToggleStudySubTaskStatus.success,
          clearUpdatingSubTaskId: true,
          actionMessage: 'تم تحديث حالة المهمة الفرعية',
          clearError: true,
        ),
      );

      debugPrint('✓ subtask status changed locally');
      debugPrint('→ completed: $completedCount');
      debugPrint('→ total: $totalCount');
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskDetailsCubit.toggleSubTaskStatus unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          toggleSubTaskStatus: ToggleStudySubTaskStatus.failure,
          clearUpdatingSubTaskId: true,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر تحديث حالة المهمة الفرعية',
        ),
      );
    } finally {
      debugPrint(
        '=================================================================',
      );
    }
  }

  // =========================================================
  // DELETE TASK LOCALLY
  // =========================================================

  void deleteTask() {
    debugPrint('============ StudyTaskDetailsCubit.deleteTask ============');

    if (state.isDeleteLoading) {
      debugPrint('✗ deleteTask ignored: operation already loading');
      debugPrint('==========================================================');
      return;
    }

    final currentTask = state.taskDetails;

    if (currentTask == null) {
      debugPrint('✗ task details are not available');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudyTaskStatus.failure,
          errorTitle: 'تعذر تنفيذ العملية',
          errorMessage: 'تفاصيل المهمة غير متاحة',
        ),
      );

      debugPrint('==========================================================');
      return;
    }

    final taskId = currentTask.data.basicInfo.id;

    emit(
      state.copyWith(
        deleteStatus: DeleteStudyTaskStatus.loading,
        clearDeletedTaskId: true,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      debugPrint('→ deleting task locally');
      debugPrint('→ taskId: $taskId');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudyTaskStatus.success,
          deletedTaskId: taskId,
          clearTaskDetails: true,
          actionMessage: 'تم حذف المهمة',
          clearError: true,
        ),
      );

      debugPrint('✓ local task deletion emitted');
    } catch (error, stackTrace) {
      debugPrint('✗ StudyTaskDetailsCubit.deleteTask unexpected error');
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudyTaskStatus.failure,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر حذف المهمة',
        ),
      );
    } finally {
      debugPrint('==========================================================');
    }
  }

  // =========================================================
  // HELPERS
  // =========================================================

  String _statusActionMessage(StudyTaskStatus status) {
    switch (status) {
      case StudyTaskStatus.todo:
        return 'تمت إعادة فتح المهمة';

      case StudyTaskStatus.inProgress:
        return 'تم بدء المهمة';

      case StudyTaskStatus.completed:
        return 'تم إكمال المهمة';
      case StudyTaskStatus.missed:
        return 'المهمة فائتة';
    }
  }

  // =========================================================
  // RESET ACTION STATES
  // =========================================================

  void resetChangeStatusState() {
    debugPrint(
      '============ StudyTaskDetailsCubit.resetChangeStatusState ============',
    );

    emit(
      state.copyWith(
        changeStatus: ChangeStudyTaskStatus.initial,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void resetToggleSubTaskState() {
    debugPrint(
      '============ StudyTaskDetailsCubit.resetToggleSubTaskState ============',
    );

    emit(
      state.copyWith(
        toggleSubTaskStatus: ToggleStudySubTaskStatus.initial,
        clearUpdatingSubTaskId: true,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void resetDeleteState() {
    debugPrint(
      '============ StudyTaskDetailsCubit.resetDeleteState ============',
    );

    emit(
      state.copyWith(
        deleteStatus: DeleteStudyTaskStatus.initial,
        clearDeletedTaskId: true,
        clearActionMessage: true,
        clearError: true,
      ),
    );
  }

  void resetError() {
    emit(state.copyWith(clearError: true));
  }

  void resetActionMessage() {
    emit(state.copyWith(clearActionMessage: true));
  }
}
