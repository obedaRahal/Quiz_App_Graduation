import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_daily_hours_dialog.dart';

Future<int?> showStudyPlanDailyHoursDialog(
  BuildContext context, {
  required int initialHours,
  int minHours = 1,
  int maxHours = 10,
}) async {
  debugPrint('============ showStudyPlanDailyHoursDialog ============');
  debugPrint('→ initialHours: $initialHours');
  debugPrint('→ minHours: $minHours');
  debugPrint('→ maxHours: $maxHours');

  final result = await showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return StudyPlanDailyHoursDialog(
        initialHours: initialHours,
        minHours: minHours,
        maxHours: maxHours,
      );
    },
  );

  debugPrint('→ selected hours: $result');
  debugPrint('=======================================================');

  return result;
}
