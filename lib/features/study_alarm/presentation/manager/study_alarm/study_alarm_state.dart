import 'package:quiz_app_grad/features/study_alarm/domain/entities/study_alarm_task_entity.dart';

class StudyAlarmState {
  final bool isLoading;
  final StudyAlarmScheduleEntity? schedule;
  final String? errorTitle;
  final String? errorMessage;

  const StudyAlarmState({
    this.isLoading = false,
    this.schedule,
    this.errorTitle,
    this.errorMessage,
  });

  bool get hasError {
    return errorMessage != null && errorMessage!.trim().isNotEmpty;
  }

  bool get hasSchedule {
    return schedule != null;
  }

  bool get taskRemindersEnabled {
    return schedule?.taskRemindersEnabled ?? false;
  }

  bool get shouldCancelExistingAlarms {
    return schedule?.shouldCancelExistingAlarms ?? false;
  }

  List get alarms {
    return schedule?.alarms ?? const [];
  }

  StudyAlarmState copyWith({
    bool? isLoading,
    StudyAlarmScheduleEntity? schedule,
    String? errorTitle,
    String? errorMessage,
    bool clearSchedule = false,
    bool clearError = false,
  }) {
    return StudyAlarmState(
      isLoading: isLoading ?? this.isLoading,
      schedule: clearSchedule ? null : schedule ?? this.schedule,
      errorTitle: clearError ? null : errorTitle ?? this.errorTitle,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}