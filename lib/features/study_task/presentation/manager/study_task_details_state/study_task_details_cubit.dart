import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_status.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/change_study_task_status_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/delete_study_task_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/get_study_task_details_use_case.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/change_study_task_status_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/delete_study_task_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/get_study_task_details_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/params/toggle_study_sub_task_status_params.dart';
import 'package:quiz_app_grad/features/study_task/domain/use_cases/toggle_study_sub_task_status_use_case.dart';
import 'package:quiz_app_grad/features/study_task/presentation/manager/study_task_details_state/study_task_details_state.dart';

class StudyTaskDetailsCubit extends Cubit<StudyTaskDetailsState> {
  final GetStudyTaskDetailsUseCase getStudyTaskDetailsUseCase;
  final DeleteStudyTaskUseCase deleteStudyTaskUseCase;
  final ChangeStudyTaskStatusUseCase changeStudyTaskStatusUseCase;
  final ToggleStudySubTaskStatusUseCase toggleStudySubTaskStatusUseCase;
  bool _hasDataChanges = false;

  StudyTaskDetailsCubit({
    required this.getStudyTaskDetailsUseCase,
    required this.deleteStudyTaskUseCase,
    required this.changeStudyTaskStatusUseCase,
    required this.toggleStudySubTaskStatusUseCase,
  }) : super(const StudyTaskDetailsState()) {
    debugPrint('============ StudyTaskDetailsCubit INIT ============');
  }

  bool get hasDataChanges => _hasDataChanges;

  void markDataChanged() {
    _hasDataChanges = true;
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
  // CHANGE TASK STATUS
  // =========================================================

  Future<void> changeTaskStatus({required int planId}) async {
    debugPrint(
      '============ '
      'StudyTaskDetailsCubit.changeTaskStatus '
      '============',
    );

    debugPrint('→ planId: $planId');

    if (state.isChangeStatusLoading) {
      debugPrint(
        '✗ changeTaskStatus ignored: '
        'operation already loading',
      );

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

    final taskId = currentTask.data.basicInfo.id;
    final currentStatus = currentTask.data.basicInfo.status;
    final targetStatus = currentStatus.nextStatus;

    debugPrint('→ taskId: $taskId');
    debugPrint('→ currentStatus: $currentStatus');
    debugPrint('→ targetStatus: $targetStatus');

    if (planId <= 0 || taskId <= 0) {
      debugPrint('✗ invalid planId or taskId');

      emit(
        state.copyWith(
          changeStatus: ChangeStudyTaskStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة أو المهمة غير صالح',
        ),
      );

      debugPrint(
        '===============================================================',
      );

      return;
    }

    if (currentStatus == StudyTaskStatus.missed) {
      debugPrint('✗ missed task status cannot be changed');

      emit(
        state.copyWith(
          changeStatus: ChangeStudyTaskStatus.failure,
          errorTitle: 'عملية غير متاحة',
          errorMessage: 'لا يمكن تغيير حالة المهمة الفائتة',
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
      final params = ChangeStudyTaskStatusParams(
        planId: planId,
        taskId: taskId,
        targetStatus: targetStatus,
      );

      debugPrint('→ params: $params');

      final result = await changeStudyTaskStatusUseCase(params);

      result.fold(
        (failure) {
          debugPrint(
            '✗ StudyTaskDetailsCubit.'
            'changeTaskStatus failure',
          );

          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              changeStatus: ChangeStudyTaskStatus.failure,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint(
            '✓ StudyTaskDetailsCubit.'
            'changeTaskStatus success',
          );

          debugPrint('→ success: ${response.success}');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');
          debugPrint('→ statusCode: ${response.statusCode}');

          final latestTask = state.taskDetails;

          if (latestTask == null) {
            emit(
              state.copyWith(
                changeStatus: ChangeStudyTaskStatus.failure,
                errorTitle: 'تعذر تحديث الواجهة',
                errorMessage: 'تفاصيل المهمة لم تعد متاحة',
              ),
            );

            return;
          }

          final updatedBasicInfo = latestTask.data.basicInfo.copyWith(
            status: targetStatus,
          );

          final updatedData = latestTask.data.copyWith(
            basicInfo: updatedBasicInfo,
          );

          final updatedTask = StudyTaskDetailsEntity(
            success: latestTask.success,
            title: latestTask.title,
            data: updatedData,
            statusCode: latestTask.statusCode,
          );

          markDataChanged();

          emit(
            state.copyWith(
              taskDetails: updatedTask,
              changeStatus: ChangeStudyTaskStatus.success,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskDetailsCubit.'
        'changeTaskStatus unexpected error',
      );

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
  // TOGGLE SUBTASK STATUS
  // =========================================================

  // =========================================================
  // TOGGLE SUBTASK STATUS
  // =========================================================

  Future<void> toggleSubTaskStatus({
    required int planId,
    required int subTaskId,
  }) async {
    debugPrint(
      '============ StudyTaskDetailsCubit.toggleSubTaskStatus ============',
    );

    debugPrint('→ planId: $planId');
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

    final subTask = currentTask.data.subtasks.firstWhere(
      (item) => item.id == subTaskId,
      orElse: () => throw Exception('SubTask not found'),
    );

    debugPrint('→ current subtask completed: ${subTask.isCompleted}');

    if (planId <= 0 || currentTask.data.basicInfo.id <= 0 || subTaskId <= 0) {
      debugPrint('✗ invalid ids');

      emit(
        state.copyWith(
          toggleSubTaskStatus: ToggleStudySubTaskStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّفات المهمة غير صالحة',
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
      final params = ToggleStudySubTaskStatusParams(
        planId: planId,

        taskId: currentTask.data.basicInfo.id,

        subTaskId: subTaskId,

        complete: !subTask.isCompleted,
      );

      debugPrint('→ params: $params');

      final result = await toggleStudySubTaskStatusUseCase(params);

      result.fold(
        (failure) {
          debugPrint('✗ StudyTaskDetailsCubit.toggleSubTaskStatus failure');

          debugPrint('→ title: ${failure.title}');

          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              toggleSubTaskStatus: ToggleStudySubTaskStatus.failure,

              clearUpdatingSubTaskId: true,

              errorTitle: failure.title,

              errorMessage: failure.message,
            ),
          );
        },

        (response) {
          debugPrint('✓ StudyTaskDetailsCubit.toggleSubTaskStatus success');

          debugPrint('→ message: ${response.message}');

          final updatedSubTasks = currentTask.data.subtasks.map((item) {
            if (item.id != subTaskId) {
              return item;
            }

            return item.copyWith(isCompleted: !item.isCompleted);
          }).toList();

          final completedCount = updatedSubTasks
              .where((item) => item.isCompleted)
              .length;

          final totalCount = updatedSubTasks.length;

          final updatedSubtasksCount = currentTask.data.basicInfo.subtasksCount
              .copyWith(
                completed: completedCount,

                total: totalCount,

                label: '$completedCount من $totalCount',
              );

          final updatedBasicInfo = currentTask.data.basicInfo.copyWith(
            subtasksCount: updatedSubtasksCount,
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

          markDataChanged();

          emit(
            state.copyWith(
              taskDetails: updatedTask,

              toggleSubTaskStatus: ToggleStudySubTaskStatus.success,

              clearUpdatingSubTaskId: true,

              actionMessage: response.message,

              clearError: true,
            ),
          );

          debugPrint('→ completed: $completedCount');

          debugPrint('→ total: $totalCount');
        },
      );
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
  // DELETE TASK
  // =========================================================

  Future<void> deleteTask({required int planId}) async {
    debugPrint(
      '============ '
      'StudyTaskDetailsCubit.deleteTask '
      '============',
    );

    debugPrint('→ planId: $planId');

    if (state.isDeleteLoading) {
      debugPrint(
        '✗ deleteTask ignored: '
        'operation already loading',
      );
      debugPrint('=========================================================');
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

      debugPrint('=========================================================');
      return;
    }

    final taskId = currentTask.data.basicInfo.id;

    if (planId <= 0 || taskId <= 0) {
      debugPrint('✗ invalid planId or taskId');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudyTaskStatus.failure,
          errorTitle: 'بيانات غير صالحة',
          errorMessage: 'معرّف الخطة أو المهمة غير صالح',
        ),
      );

      debugPrint('=========================================================');
      return;
    }

    emit(
      state.copyWith(
        deleteStatus: DeleteStudyTaskStatus.loading,
        clearDeletedTaskId: true,
        clearActionMessage: true,
        clearError: true,
      ),
    );

    try {
      final params = DeleteStudyTaskParams(planId: planId, taskId: taskId);

      debugPrint('→ params: $params');

      final result = await deleteStudyTaskUseCase(params);

      result.fold(
        (failure) {
          debugPrint(
            '✗ StudyTaskDetailsCubit.'
            'deleteTask failure',
          );
          debugPrint('→ title: ${failure.title}');
          debugPrint('→ message: ${failure.message}');

          emit(
            state.copyWith(
              deleteStatus: DeleteStudyTaskStatus.failure,
              clearDeletedTaskId: true,
              errorTitle: failure.title,
              errorMessage: failure.message,
            ),
          );
        },
        (response) {
          debugPrint(
            '✓ StudyTaskDetailsCubit.'
            'deleteTask success',
          );
          debugPrint('→ success: ${response.success}');
          debugPrint('→ title: ${response.title}');
          debugPrint('→ message: ${response.message}');
          debugPrint('→ statusCode: ${response.statusCode}');

          markDataChanged();

          emit(
            state.copyWith(
              deleteStatus: DeleteStudyTaskStatus.success,
              deletedTaskId: taskId,
              clearTaskDetails: true,
              actionMessage: response.message,
              clearError: true,
            ),
          );
        },
      );
    } catch (error, stackTrace) {
      debugPrint(
        '✗ StudyTaskDetailsCubit.'
        'deleteTask unexpected error',
      );
      debugPrint('→ error: $error');
      debugPrint('→ stackTrace: $stackTrace');

      emit(
        state.copyWith(
          deleteStatus: DeleteStudyTaskStatus.failure,
          clearDeletedTaskId: true,
          errorTitle: 'حدث خطأ',
          errorMessage: 'تعذر حذف المهمة',
        ),
      );
    } finally {
      debugPrint('=========================================================');
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
