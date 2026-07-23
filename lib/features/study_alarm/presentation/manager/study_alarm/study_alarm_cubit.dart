import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/features/study_alarm/domain/use_cases/get_study_alarm_schedule_use_case.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/manager/study_alarm/study_alarm_state.dart';
import 'package:quiz_app_grad/features/study_alarm/services/study_alarm_scheduler_service.dart';

class StudyAlarmCubit extends Cubit<StudyAlarmState> {
  final GetStudyAlarmScheduleUseCase getStudyAlarmScheduleUseCase;

  final StudyAlarmSchedulerService schedulerService;

  StudyAlarmCubit({
    required this.getStudyAlarmScheduleUseCase,
    required this.schedulerService,
  }) : super(const StudyAlarmState()) {
    debugPrint('============ StudyAlarmCubit INIT ============');
  }

  Future<void> fetchStudyAlarmSchedule() async {
    debugPrint(
      '============ StudyAlarmCubit.fetchStudyAlarmSchedule ============',
    );

    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await getStudyAlarmScheduleUseCase();

    await result.fold<Future<void>>(
      (failure) async {
        debugPrint('✗ fetchStudyAlarmSchedule failed');
        debugPrint('→ title: ${failure.title}');
        debugPrint('→ message: ${failure.message}');
        debugPrint(
          '================================================================',
        );

        emit(
          state.copyWith(
            isLoading: false,
            errorTitle: failure.title,
            errorMessage: failure.message,
          ),
        );
      },
      (schedule) async {
        debugPrint('✓ fetchStudyAlarmSchedule success');
        debugPrint('→ timezone: ${schedule.timezone}');
        debugPrint(
          '→ taskRemindersEnabled: '
          '${schedule.taskRemindersEnabled}',
        );
        debugPrint(
          '→ shouldCancelExistingAlarms: '
          '${schedule.shouldCancelExistingAlarms}',
        );
        debugPrint('→ days: ${schedule.days}');
        debugPrint('→ generatedAt: ${schedule.generatedAt}');
        debugPrint('→ alarmsCount: ${schedule.alarms.length}');
        debugPrint(
          '→ schedulableAlarmsCount: '
          '${schedule.schedulableAlarms.length}',
        );

        try {
          debugPrint(
            '============ StudyAlarmCubit.syncStudyAlarms START ============',
          );

          await schedulerService.syncStudyAlarms(schedule: schedule);

          debugPrint('✓ study alarms synchronized successfully');
          debugPrint(
            '===============================================================',
          );

          emit(
            state.copyWith(
              isLoading: false,
              schedule: schedule,
              clearError: true,
            ),
          );
        } catch (error, stackTrace) {
          debugPrint('✗ study alarms synchronization failed');
          debugPrint('→ error: $error');
          debugPrint('→ stackTrace: $stackTrace');
          debugPrint(
            '===============================================================',
          );

          emit(
            state.copyWith(
              isLoading: false,
              schedule: schedule,
              errorTitle: 'تعذر مزامنة منبهات الدراسة',
              errorMessage:
                  'تم تحميل جدول الدراسة، ولكن تعذر إعداد المنبهات على الجهاز.',
            ),
          );
        }

        debugPrint(
          '================================================================',
        );
      },
    );
  }

  Future<void> refresh() async {
    debugPrint('============ StudyAlarmCubit.refresh ============');

    await fetchStudyAlarmSchedule();
  }

  void clearSchedule() {
    if (state.schedule == null) {
      return;
    }

    debugPrint('============ StudyAlarmCubit.clearSchedule ============');

    emit(state.copyWith(clearSchedule: true, clearError: true));

    debugPrint('✓ study alarm schedule cleared');
    debugPrint('=======================================================');
  }

  void clearError() {
    if (!state.hasError) {
      return;
    }

    debugPrint('============ StudyAlarmCubit.clearError ============');

    emit(state.copyWith(clearError: true));

    debugPrint('✓ study alarm error cleared');
    debugPrint('====================================================');
  }
}
