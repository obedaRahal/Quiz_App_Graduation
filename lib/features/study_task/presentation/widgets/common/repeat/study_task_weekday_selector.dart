import 'package:flutter/material.dart';

const Map<int, String> studyTaskWeekdays = {
  0: 'الأحد',
  1: 'الإثنين',
  2: 'الثلاثاء',
  3: 'الأربعاء',
  4: 'الخميس',
  5: 'الجمعة',
  6: 'السبت',
};

class StudyTaskWeekdaySelector extends StatelessWidget {
  final int? selectedWeekday;
  final ValueChanged<int> onChanged;

  const StudyTaskWeekdaySelector({
    super.key,
    required this.selectedWeekday,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      runSpacing: 8,
      children: studyTaskWeekdays.entries.map((entry) {
        final weekday = entry.key;
        final label = entry.value;
        final isSelected = weekday == selectedWeekday;

        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) {
            onChanged(weekday);
          },
        );
      }).toList(),
    );
  }
}
