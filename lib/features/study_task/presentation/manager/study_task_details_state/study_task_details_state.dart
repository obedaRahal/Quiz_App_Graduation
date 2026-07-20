import 'package:quiz_app_grad/features/study_task/domain/entities/study_task_details_entity.dart';

enum StudyTaskDetailsLoadStatus { initial, loading, success, failure }

enum ChangeStudyTaskStatus { initial, loading, success, failure }

enum ToggleStudySubTaskStatus { initial, loading, success, failure }

enum DeleteStudyTaskStatus { initial, loading, success, failure }

class StudyTaskDetailsState {
  final StudyTaskDetailsEntity? taskDetails;

  final StudyTaskDetailsLoadStatus loadStatus;
  final ChangeStudyTaskStatus changeStatus;
  final ToggleStudySubTaskStatus toggleSubTaskStatus;
  final DeleteStudyTaskStatus deleteStatus;

  final int? updatingSubTaskId;
  final int? deletedTaskId;

  final String? actionMessage;
  final String? errorTitle;
  final String? errorMessage;

  const StudyTaskDetailsState({
    this.taskDetails,
    this.loadStatus = StudyTaskDetailsLoadStatus.initial,
    this.changeStatus = ChangeStudyTaskStatus.initial,
    this.toggleSubTaskStatus = ToggleStudySubTaskStatus.initial,
    this.deleteStatus = DeleteStudyTaskStatus.initial,
    this.updatingSubTaskId,
    this.deletedTaskId,
    this.actionMessage,
    this.errorTitle,
    this.errorMessage,
  });

  bool get isInitial {
    return loadStatus == StudyTaskDetailsLoadStatus.initial;
  }

  bool get isLoading {
    return loadStatus == StudyTaskDetailsLoadStatus.loading;
  }

  bool get isLoadSuccess {
    return loadStatus == StudyTaskDetailsLoadStatus.success;
  }

  bool get isLoadFailure {
    return loadStatus == StudyTaskDetailsLoadStatus.failure;
  }

  bool get isChangeStatusLoading {
    return changeStatus == ChangeStudyTaskStatus.loading;
  }

  bool get isChangeStatusSuccess {
    return changeStatus == ChangeStudyTaskStatus.success;
  }

  bool get isChangeStatusFailure {
    return changeStatus == ChangeStudyTaskStatus.failure;
  }

  bool get isToggleSubTaskLoading {
    return toggleSubTaskStatus == ToggleStudySubTaskStatus.loading;
  }

  bool get isToggleSubTaskSuccess {
    return toggleSubTaskStatus == ToggleStudySubTaskStatus.success;
  }

  bool get isToggleSubTaskFailure {
    return toggleSubTaskStatus == ToggleStudySubTaskStatus.failure;
  }

  bool get isDeleteLoading {
    return deleteStatus == DeleteStudyTaskStatus.loading;
  }

  bool get isDeleteSuccess {
    return deleteStatus == DeleteStudyTaskStatus.success;
  }

  bool get isDeleteFailure {
    return deleteStatus == DeleteStudyTaskStatus.failure;
  }

  bool get hasTaskDetails => taskDetails != null;

  bool get hasNoTaskDetails => taskDetails == null;

  bool isUpdatingSubTask(int subTaskId) {
    return isToggleSubTaskLoading && updatingSubTaskId == subTaskId;
  }

  StudyTaskDetailsState copyWith({
    StudyTaskDetailsEntity? taskDetails,
    StudyTaskDetailsLoadStatus? loadStatus,
    ChangeStudyTaskStatus? changeStatus,
    ToggleStudySubTaskStatus? toggleSubTaskStatus,
    DeleteStudyTaskStatus? deleteStatus,
    int? updatingSubTaskId,
    int? deletedTaskId,
    String? actionMessage,
    String? errorTitle,
    String? errorMessage,
    bool clearTaskDetails = false,
    bool clearUpdatingSubTaskId = false,
    bool clearDeletedTaskId = false,
    bool clearActionMessage = false,
    bool clearError = false,
  }) {
    return StudyTaskDetailsState(
      taskDetails: clearTaskDetails ? null : taskDetails ?? this.taskDetails,
      loadStatus: loadStatus ?? this.loadStatus,
      changeStatus: changeStatus ?? this.changeStatus,
      toggleSubTaskStatus: toggleSubTaskStatus ?? this.toggleSubTaskStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      updatingSubTaskId: clearUpdatingSubTaskId
          ? null
          : updatingSubTaskId ?? this.updatingSubTaskId,
      deletedTaskId: clearDeletedTaskId
          ? null
          : deletedTaskId ?? this.deletedTaskId,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
