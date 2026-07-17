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
    final displayDays = days.isNotEmpty
        ? days
        : _buildDaysFromRange();

    return SizedBox(
      width: double.infinity,
      height: SizeConfig.h(0.06),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _WeekNavigationButton(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: isLoading ? null : onPreviousWeek,
            tooltip: 'الأسبوع السابق',
          ),

          SizedBox(width: SizeConfig.w(0.012)),

          Expanded(
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: displayDays.map((day) {
                return StudyPlanWeekDayItem(
                  day: day,
                  isSelected:
                      day.date == selectedDate,
                  onTap: isLoading
                      ? null
                      : () => onDayTap(day),
                );
              }).toList(),
            ),
          ),

          SizedBox(width: SizeConfig.w(0.012)),

          _WeekNavigationButton(
            icon: Icons.arrow_back_ios_rounded,
            onTap: isLoading ? null : onNextWeek,
            tooltip: 'الأسبوع التالي',
          ),
        ],
      ),
    );
  }

  List<StudyPlanDayEntity>
      _buildDaysFromRange() {
    final start =
        StudyPlanDateUtils.tryParseApiDate(
      rangeStart,
    );

    final today =
        StudyPlanDateUtils.tryParseApiDate(
      serverToday,
    );

    if (start == null) {
      return const [];
    }

    return List.generate(
      7,
      (index) {
        final date = start.add(
          Duration(days: index),
        );

        final dateText =
            StudyPlanDateUtils.formatApiDate(
          date,
        );

        final isToday = today != null &&
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        return StudyPlanDayEntity(
          date: dateText,
          dayNumber: date.day,
          dayName:
              StudyPlanDateUtils.arabicDayName(
            date,
          ),
          isToday: isToday,
          hasTasks: false,
          totalTasks: 0,
          completedTasks: 0,
          completionState: 'empty',
          displayState:
              isToday ? 'today' : 'empty',
        );
      },
    );
  }
}

class _WeekNavigationButton
    extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  const _WeekNavigationButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = SizeConfig.h(0.027);

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: SizeConfig.w(0.055),
            height: SizeConfig.h(0.05),
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