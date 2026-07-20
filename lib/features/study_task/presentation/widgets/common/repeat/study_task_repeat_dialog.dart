import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/study_task/domain/enums/study_task_repeat_pattern.dart';
import 'package:quiz_app_grad/features/study_task/presentation/widgets/common/repeat/study_task_weekday_selector.dart';

class StudyTaskRepeatDialogResult {
  final StudyTaskRepeatPattern pattern;
  final int? weekday;

  const StudyTaskRepeatDialogResult({
    required this.pattern,
    required this.weekday,
  });
}

Future<StudyTaskRepeatDialogResult?> showStudyTaskRepeatDialog({
  required BuildContext context,
  required StudyTaskRepeatPattern initialPattern,
  required int? initialWeekday,
}) {
  return showDialog<StudyTaskRepeatDialogResult>(
    context: context,
    builder: (_) {
      return _StudyTaskRepeatDialog(
        initialPattern: initialPattern,
        initialWeekday: initialWeekday,
      );
    },
  );
}

class _StudyTaskRepeatDialog extends StatefulWidget {
  final StudyTaskRepeatPattern initialPattern;
  final int? initialWeekday;

  const _StudyTaskRepeatDialog({
    required this.initialPattern,
    required this.initialWeekday,
  });

  @override
  State<_StudyTaskRepeatDialog> createState() {
    return _StudyTaskRepeatDialogState();
  }
}

class _StudyTaskRepeatDialogState extends State<_StudyTaskRepeatDialog> {
  late StudyTaskRepeatPattern _selectedPattern;
  int? _selectedWeekday;

  @override
  void initState() {
    super.initState();

    _selectedPattern = widget.initialPattern;
    _selectedWeekday = widget.initialWeekday;
  }

  bool get _requiresWeekday {
    return _selectedPattern != StudyTaskRepeatPattern.none;
  }

  bool get _canConfirm {
    if (!_requiresWeekday) {
      return true;
    }

    return _selectedWeekday != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تكرار المهمة', textAlign: TextAlign.right),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'اختر نمط تكرار المهمة',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 12),

            ...StudyTaskRepeatPattern.values.map((pattern) {
              return RadioListTile<StudyTaskRepeatPattern>(
                value: pattern,
                groupValue: _selectedPattern,
                contentPadding: EdgeInsets.zero,
                title: Text(pattern.apiValue, textAlign: TextAlign.right),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedPattern = value;

                    if (value == StudyTaskRepeatPattern.none) {
                      _selectedWeekday = null;
                    }
                  });
                },
              );
            }),

            if (_requiresWeekday) ...[
              const SizedBox(height: 16),

              Text(
                'اختر يوم التكرار',
                textAlign: TextAlign.right,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 12),

              StudyTaskWeekdaySelector(
                selectedWeekday: _selectedWeekday,
                onChanged: (weekday) {
                  setState(() {
                    _selectedWeekday = weekday;
                  });
                },
              ),

              if (_selectedWeekday == null) ...[
                const SizedBox(height: 10),

                Text(
                  'يجب اختيار يوم التكرار.',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('إلغاء'),
        ),

        FilledButton(
          onPressed: !_canConfirm
              ? null
              : () {
                  Navigator.of(context).pop(
                    StudyTaskRepeatDialogResult(
                      pattern: _selectedPattern,
                      weekday: _selectedPattern == StudyTaskRepeatPattern.none
                          ? null
                          : _selectedWeekday,
                    ),
                  );
                },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
