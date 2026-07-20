import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_form_section_header.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/create/study_plan_selection_box.dart';

class StudyTaskDateSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;

  /// أول تاريخ يمكن اختياره كبداية.
  ///
  /// في الإنشاء يكون غالبًا اليوم.
  /// وفي التعديل يكون اليوم أيضًا، مع السماح بعرض
  /// التاريخ القديم الموجود مسبقًا.
  final DateTime firstSelectableStartDate;

  /// آخر تاريخ يمكن اختياره كبداية.
  final DateTime lastSelectableStartDate;

  /// أقصى عدد أيام للمهمة، شامل يوم البداية.
  ///
  /// مثلًا:
  /// maxRangeDays = 7
  ///
  /// يعني:
  /// البداية 1 أغسطس
  /// النهاية القصوى 7 أغسطس
  final int maxRangeDays;

  final String sectionTitle;
  final String sectionDescription;

  final String startLabel;
  final String endLabel;

  const StudyTaskDateSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.firstSelectableStartDate,
    required this.lastSelectableStartDate,
    this.maxRangeDays = 7,
    this.sectionTitle = 'تاريخ ومدة المهمة',
    this.sectionDescription =
        'حدد تاريخ بداية ونهاية المهمة، على ألا تتجاوز مدتها 7 أيام.',
    this.startLabel = 'من',
    this.endLabel = 'إلى',
  }) : assert(maxRangeDays > 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StudyPlanFormSectionHeader(
          title: sectionTitle,
          description: sectionDescription,
          image: AppImage.stopwatch,
        ),

        SizedBox(height: SizeConfig.h(0.016)),

        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: StudyPlanSelectionBox(
                title: startLabel,
                value: startDate == null ? null : _formatDate(startDate!),
                icon: Icons.calendar_month_outlined,
                onTap: () {
                  _selectStartDate(context);
                },
              ),
            ),

            SizedBox(width: SizeConfig.w(0.025)),

            const Icon(Icons.arrow_back_rounded),

            SizedBox(width: SizeConfig.w(0.025)),

            Expanded(
              child: StudyPlanSelectionBox(
                title: endLabel,
                value: endDate == null ? null : _formatDate(endDate!),
                icon: Icons.calendar_month_outlined,
                onTap: () {
                  _selectEndDate(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final normalizedFirstDate = _normalizeDate(firstSelectableStartDate);

    final normalizedLastDate = _normalizeDate(lastSelectableStartDate);

    /*
     * قد يكون تاريخ المهمة الحالي أقدم من firstDate
     * في شاشة التعديل.
     *
     * لذلك لا نستخدم startDate مباشرة بوصفه
     * initialDate إلا بعد وضعه ضمن المجال المسموح.
     */
    final pickerInitialDate = _clampDate(
      date: _normalizeDate(startDate ?? normalizedFirstDate),
      firstDate: normalizedFirstDate,
      lastDate: normalizedLastDate,
    );

    debugPrint('============ Study Task Start Date Picker ============');
    debugPrint('→ current start date: $startDate');
    debugPrint('→ current end date: $endDate');
    debugPrint('→ picker initial date: $pickerInitialDate');
    debugPrint('→ picker first date: $normalizedFirstDate');
    debugPrint('→ picker last date: $normalizedLastDate');

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: pickerInitialDate,
      firstDate: normalizedFirstDate,
      lastDate: normalizedLastDate,
      helpText: 'اختر تاريخ بداية المهمة',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (selectedDate == null || !context.mounted) {
      debugPrint('→ start date selection cancelled');
      return;
    }

    final normalizedSelectedDate = _normalizeDate(selectedDate);

    debugPrint('→ selected start date: $normalizedSelectedDate');
    debugPrint('=====================================================');

    onStartDateChanged(normalizedSelectedDate);

    _adjustEndDateAfterStartChange(normalizedSelectedDate);
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final currentStartDate = startDate;

    if (currentStartDate == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'يرجى اختيار تاريخ بداية المهمة أولًا',
              textAlign: TextAlign.right,
            ),
          ),
        );

      return;
    }

    final normalizedStartDate = _normalizeDate(currentStartDate);

    final lastAllowedEndDate = normalizedStartDate.add(
      Duration(days: maxRangeDays - 1),
    );

    final pickerInitialDate = _clampDate(
      date: _normalizeDate(endDate ?? normalizedStartDate),
      firstDate: normalizedStartDate,
      lastDate: lastAllowedEndDate,
    );

    debugPrint('============ Study Task End Date Picker ============');
    debugPrint('→ current start date: $normalizedStartDate');
    debugPrint('→ current end date: $endDate');
    debugPrint('→ picker initial date: $pickerInitialDate');
    debugPrint('→ picker first date: $normalizedStartDate');
    debugPrint('→ picker last date: $lastAllowedEndDate');

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: pickerInitialDate,
      firstDate: normalizedStartDate,
      lastDate: lastAllowedEndDate,
      helpText: 'اختر تاريخ نهاية المهمة',
      cancelText: 'إلغاء',
      confirmText: 'اختيار',
    );

    if (selectedDate == null || !context.mounted) {
      debugPrint('→ end date selection cancelled');
      return;
    }

    final normalizedSelectedDate = _normalizeDate(selectedDate);

    debugPrint('→ selected end date: $normalizedSelectedDate');
    debugPrint('===================================================');

    onEndDateChanged(normalizedSelectedDate);
  }

  void _adjustEndDateAfterStartChange(DateTime newStartDate) {
    final currentEndDate = endDate;

    if (currentEndDate == null) {
      /*
       * إن لم يكن هناك تاريخ نهاية،
       * نجعله مساويًا للبداية الجديدة.
       */
      onEndDateChanged(newStartDate);
      return;
    }

    final normalizedEndDate = _normalizeDate(currentEndDate);

    /*
     * إذا أصبحت النهاية قبل البداية الجديدة،
     * نجعلها مساوية للبداية.
     */
    if (normalizedEndDate.isBefore(newStartDate)) {
      onEndDateChanged(newStartDate);
      return;
    }

    final lastAllowedEndDate = newStartDate.add(
      Duration(days: maxRangeDays - 1),
    );

    /*
     * إذا تجاوزت النهاية الحد الأقصى بعد
     * تغيير البداية، نضبطها تلقائيًا.
     */
    if (normalizedEndDate.isAfter(lastAllowedEndDate)) {
      onEndDateChanged(lastAllowedEndDate);
    }
  }

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime _clampDate({
    required DateTime date,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    if (date.isBefore(firstDate)) {
      return firstDate;
    }

    if (date.isAfter(lastDate)) {
      return lastDate;
    }

    return date;
  }

  static String _formatDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);

    final day = normalizedDate.day.toString().padLeft(2, '0');

    final month = normalizedDate.month.toString().padLeft(2, '0');

    return '$day/$month/${normalizedDate.year}';
  }
}
