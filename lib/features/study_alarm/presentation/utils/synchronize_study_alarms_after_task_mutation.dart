import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/manager/study_alarm/study_alarm_cubit.dart';

Future<bool> synchronizeStudyAlarmsAfterTaskMutation(
  BuildContext context,
) async {
  final cubit = sl<StudyAlarmCubit>();

  try {
    await cubit.fetchStudyAlarmSchedule();
    final state = cubit.state;

    if (!state.hasError) {
      return true;
    }

    if (context.mounted) {
      showValidationTopSnackBar(
        context,
        title: state.errorTitle ?? 'تعذر تحديث منبهات الدراسة',
        message:
            state.errorMessage ??
            'تم حفظ المهمة، لكن تعذر تحديث منبهاتها على هذا الجهاز.',
        type: AppValidationSnackBarType.error,
      );
    }

    return false;
  } finally {
    await cubit.close();
  }
}
