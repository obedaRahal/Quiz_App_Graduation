import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_editable_field.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/personal_info_tab/my_profile_personal_info_tab.dart';

class MyProfileBirthDateField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const MyProfileBirthDateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MyProfileEditableField(
      title: "تاريخ الميلاد",
      value: value,
      hintText: 'تاريخ الميلاد',
      icon: Icons.calendar_today_outlined,
      readOnly: true,
      onTap: () async {
        final initialDate = _parseDate(value) ?? DateTime(2000, 1, 1);

        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          helpText: 'اختر تاريخ الميلاد',
          cancelText: 'إلغاء',
          confirmText: 'اختيار',
          fieldLabelText: 'تاريخ الميلاد',
          fieldHintText: 'yyyy-mm-dd',
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? const SizedBox.shrink(),
            );
          },
        );

        if (pickedDate == null) return;

        onChanged(_formatDate(pickedDate));
      },
      onChanged: (_) {},
    );
  }

  DateTime? _parseDate(String value) {
    final clean = value.trim();

    if (clean.isEmpty) return null;

    try {
      return DateTime.parse(clean);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}
