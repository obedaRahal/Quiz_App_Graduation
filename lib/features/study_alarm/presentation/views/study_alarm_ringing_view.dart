import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/features/study_alarm/presentation/models/study_alarm_payload.dart';
import 'package:quiz_app_grad/features/study_alarm/services/study_alarm_scheduler_service.dart';
import 'package:quiz_app_grad/features/study_task/data/models/study_task_details_args.dart';

class StudyAlarmRingingView extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const StudyAlarmRingingView({super.key, required this.alarmSettings});

  @override
  State<StudyAlarmRingingView> createState() => _StudyAlarmRingingViewState();
}

class _StudyAlarmRingingViewState extends State<StudyAlarmRingingView> {
  late final StudyAlarmPayload _payload;
  StreamSubscription<dynamic>? _ringingSubscription;
  bool _isBusy = false;
  bool _handledLocally = false;

  @override
  void initState() {
    super.initState();
    _payload = StudyAlarmPayload.fromSettings(widget.alarmSettings);

    _ringingSubscription = Alarm.ringing.listen((alarmSet) {
      final isStillRinging = alarmSet.alarms.any(
        (alarm) => alarm.id == widget.alarmSettings.id,
      );

      if (!isStillRinging && !_handledLocally && mounted) {
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    _ringingSubscription?.cancel();
    super.dispose();
  }

  Future<void> _stopAlarm() async {
    await _runAlarmAction(() async {
      await sl<StudyAlarmSchedulerService>().stopStudyAlarm(
        alarmId: widget.alarmSettings.id,
      );

      if (mounted) {
        context.pop();
      }
    });
  }

  Future<void> _snoozeAlarm() async {
    await _runAlarmAction(() async {
      await sl<StudyAlarmSchedulerService>().snoozeStudyAlarm(
        alarmId: widget.alarmSettings.id,
      );

      if (mounted) {
        context.pop();
      }
    });
  }

  Future<void> _openTask() async {
    if (!_payload.canOpenTask) {
      return;
    }

    await _runAlarmAction(() async {
      await sl<StudyAlarmSchedulerService>().stopStudyAlarm(
        alarmId: widget.alarmSettings.id,
      );

      if (!mounted) return;

      context.pushReplacementNamed(
        AppRouterName.studyTaskDetails,
        extra: StudyTaskDetailsArgs(
          planId: _payload.studyPlanId,
          taskId: _payload.taskId,
        ),
      );
    });
  }

  Future<void> _runAlarmAction(Future<void> Function() action) async {
    if (_isBusy) return;

    setState(() {
      _isBusy = true;
      _handledLocally = true;
    });

    try {
      await action();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isBusy = false;
        _handledLocally = false;
      });

      showValidationTopSnackBar(
        context,
        title: 'تعذر تنفيذ الإجراء',
        message: error.toString(),
        type: AppValidationSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notification = widget.alarmSettings.notificationSettings;
    final alarmTime = TimeOfDay.fromDateTime(
      widget.alarmSettings.dateTime,
    ).format(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.alarm_rounded,
                      size: 58,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    alarmTime,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notification.body,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  if (_payload.canOpenTask) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isBusy ? null : _openTask,
                        icon: const Icon(Icons.task_alt_rounded),
                        label: const Text('فتح المهمة'),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isBusy ? null : _snoozeAlarm,
                          icon: const Icon(Icons.snooze_rounded),
                          label: const Text('غفوة 10 دقائق'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: _isBusy ? null : _stopAlarm,
                          icon: const Icon(Icons.stop_rounded),
                          label: const Text('إيقاف'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
