import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/utils/study_plan_date_utils.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/widgets/home/study_plan_week_day_item.dart';

class StudyPlanWeekSelector extends StatelessWidget {
  final List<StudyPlanDayEntity> days;
  final String selectedDate;
  final String rangeStart;
  final String rangeEnd;
  final String weekStartsOn;
  final String serverToday;
  final bool isLoading;

  final ValueChanged<StudyPlanDayEntity> onDayTap;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const StudyPlanWeekSelector({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.rangeStart,
    required this.rangeEnd,
    required this.weekStartsOn,
    required this.serverToday,
    required this.isLoading,
    required this.onDayTap,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final displayDays = _resolveDisplayDays();
    final selectorHeight = SizeConfig.h(0.06).clamp(44.0, 56.0);

    return SizedBox(
      width: double.infinity,
      height: selectorHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final navigationWidth = (constraints.maxWidth * 0.05).clamp(
            24.0,
            36.0,
          );
          final horizontalGap = (constraints.maxWidth * 0.003).clamp(2.0, 6.0);
          final daysWidth = math.max(
            0.0,
            constraints.maxWidth - (navigationWidth * 2) - (horizontalGap * 2),
          );
          final daySlotWidth = displayDays.isEmpty
              ? 0.0
              : daysWidth / displayDays.length;
          final preferredDiameter = math.min(
            SizeConfig.h(0.055),
            selectorHeight * 0.9,
          );
          final dayDiameter = math.max(
            0.0,
            math.min(preferredDiameter, daySlotWidth * 0.9),
          );

          return Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _WeekNavigationButton(
                icon: Icons.arrow_forward_ios_rounded,
                onTap: isLoading ? null : onPreviousWeek,
                tooltip: 'الأسبوع السابق',
                width: navigationWidth,
                height: selectorHeight,
              ),
              SizedBox(width: horizontalGap),
              Expanded(
                child: Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: displayDays.map((day) {
                    return Expanded(
                      child: Center(
                        child: StudyPlanWeekDayItem(
                          day: day,
                          isSelected: day.date == selectedDate,
                          diameter: dayDiameter,
                          onTap: isLoading ? null : () => onDayTap(day),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: horizontalGap),
              _WeekNavigationButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: isLoading ? null : onNextWeek,
                tooltip: 'الأسبوع التالي',
                width: navigationWidth,
                height: selectorHeight,
              ),
            ],
          );
        },
      ),
    );
  }

  List<StudyPlanDayEntity> _resolveDisplayDays() {
    final rangeDays = _buildDaysFromRange();

    if (days.isEmpty) {
      return rangeDays;
    }

    if (rangeDays.isEmpty) {
      return days.take(7).toList(growable: false);
    }

    final serverDaysByDate = <String, StudyPlanDayEntity>{
      for (final day in days) day.date: day,
    };

    return rangeDays
        .map((fallbackDay) => serverDaysByDate[fallbackDay.date] ?? fallbackDay)
        .toList(growable: false);
  }

  List<StudyPlanDayEntity> _buildDaysFromRange() {
    final start = StudyPlanDateUtils.tryParseApiDate(rangeStart);

    final today = StudyPlanDateUtils.tryParseApiDate(serverToday);

    if (start == null) {
      return const [];
    }

    return List.generate(7, (index) {
      final date = start.add(Duration(days: index));

      final dateText = StudyPlanDateUtils.formatApiDate(date);

      final isToday =
          today != null &&
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;

      return StudyPlanDayEntity(
        date: dateText,
        dayNumber: date.day,
        dayName: StudyPlanDateUtils.arabicDayName(date),
        isToday: isToday,
        hasTasks: false,
        totalTasks: 0,
        completedTasks: 0,
        completionState: 'empty',
        displayState: isToday ? 'today' : 'empty',
      );
    });
  }
}

class _WeekNavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final double width;
  final double height;

  const _WeekNavigationButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = math.min(SizeConfig.h(0.027), width * 0.58);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: Icon(
                icon,
                size: iconSize,
                color: onTap == null
                    ? const Color(0xffE1E1E4)
                    : const Color(0xffC5C5C9),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
