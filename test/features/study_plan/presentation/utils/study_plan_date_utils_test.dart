import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/utils/study_plan_date_utils.dart';

void main() {
  group('StudyPlanDateUtils', () {
    test('builds a Tuesday to Monday week around the selected date', () {
      final weekStart = StudyPlanDateUtils.calculateWeekStart(
        date: DateTime(2026, 7, 26),
        weekStartsOn: 'الثلاثاء',
      );
      final weekEnd = StudyPlanDateUtils.calculateWeekEnd(weekStart: weekStart);

      expect(StudyPlanDateUtils.formatApiDate(weekStart), '2026-07-21');
      expect(StudyPlanDateUtils.formatApiDate(weekEnd), '2026-07-27');
    });

    test('accepts both supported Arabic spellings for Monday', () {
      final date = DateTime(2026, 7, 26);

      final firstSpelling = StudyPlanDateUtils.calculateWeekStart(
        date: date,
        weekStartsOn: 'الإتنين',
      );
      final secondSpelling = StudyPlanDateUtils.calculateWeekStart(
        date: date,
        weekStartsOn: 'الاثنين',
      );

      expect(firstSpelling, DateTime(2026, 7, 20));
      expect(secondSpelling, firstSpelling);
    });
  });
}
