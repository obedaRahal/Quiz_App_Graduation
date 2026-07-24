import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/app_theme_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/entities/home/study_plan_day_entity.dart';

class StudyPlanWeekDayItem extends StatelessWidget {
  final StudyPlanDayEntity day;
  final bool isSelected;
  final double diameter; 
  final VoidCallback? onTap;

  const StudyPlanWeekDayItem({
    super.key,
    required this.day,
    required this.isSelected,
    required this.diameter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final colors = _resolveColors(
      state: day.parsedDisplayState,
      appColors: appColors,
    );
    final fontSize = math.min(SizeConfig.text(0.038), diameter * 0.4);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${day.dayName} ${day.dayNumber}',
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: diameter,
            height: diameter,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.backgroundColor,
              border: Border.all(
                color: isSelected
                    ? appColors.primaryToPrimaryDark
                    : colors.borderColor,
                width: isSelected ? 2.5 : colors.borderWidth,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: appColors.primaryToPrimaryDark.withValues(
                          alpha: 0.18,
                        ),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: CustomTextWidget(
              day.dayNumber.toString(),
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: colors.textColor,
            ),
          ),
        ),
      ),
    );
  }

  _StudyDayVisualColors _resolveColors({
    required StudyPlanDayDisplayState state,
    required AppThemeColors appColors,
  }) {
    switch (state) {
      case StudyPlanDayDisplayState.completed:
        return _StudyDayVisualColors(
          backgroundColor: AppPalette.green,
          borderColor: AppPalette.green,
          textColor: appColors.whiteToblack,
          borderWidth: 1,
        );

      case StudyPlanDayDisplayState.incompleted:
        return _StudyDayVisualColors(
          backgroundColor: AppPalette.red,
          borderColor: AppPalette.red,
          textColor: appColors.whiteToblack,
          borderWidth: 1,
        );

      case StudyPlanDayDisplayState.scheduled:
        return _StudyDayVisualColors(
          backgroundColor: appColors.greyToGreyMediumDark,
          borderColor: AppPalette.greyLightDark,
          textColor: AppPalette.greyLightDark,
          borderWidth: 1,
        );

      case StudyPlanDayDisplayState.today:
        return _StudyDayVisualColors(
          backgroundColor: appColors.primarySoftTogreyLightDark,
          borderColor: appColors.primaryToPrimaryDark,
          textColor: appColors.primaryToPrimaryDark,
          borderWidth: 1.5,
        );

      case StudyPlanDayDisplayState.empty:
        return _StudyDayVisualColors(
          backgroundColor: appColors.greyToGreyMediumDark,
          borderColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
          textColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
          borderWidth: 1.5,
        );

      case StudyPlanDayDisplayState.unknown:
        return _StudyDayVisualColors(
          backgroundColor: appColors.greyToGreyMediumDark,
          borderColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
          textColor: AppPalette.greyMedium,
          borderWidth: 1.5,
        );
    }
  }
}

class _StudyDayVisualColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double borderWidth;

  const _StudyDayVisualColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.borderWidth,
  });
}
