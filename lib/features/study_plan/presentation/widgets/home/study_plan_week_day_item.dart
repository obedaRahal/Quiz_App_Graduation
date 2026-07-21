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
  final VoidCallback? onTap;

  const StudyPlanWeekDayItem({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final colors = _resolveColors(
      state: day.parsedDisplayState,
      isSelected: isSelected,
      appColors: appColors,
    );

    final size = SizeConfig.h(0.057);

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
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.backgroundColor,
              border: Border.all(
                color: colors.borderColor,
                width: colors.borderWidth,
              ),
            ),
            child: CustomTextWidget(
              day.dayNumber.toString(),
              fontSize: SizeConfig.text(0.038),
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
    required bool isSelected,
    required AppThemeColors appColors,
  }) {
    // اليوم المختار دائمًا أزرق، مهما كانت حالته الأصلية.
    if (isSelected) {
      return _StudyDayVisualColors(
        backgroundColor: appColors.primarySoftTogreyLightDark,
        borderColor: appColors.primaryToPrimaryDark,
        textColor: appColors.primaryToPrimaryDark,
        borderWidth: 2,
      );
    }

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
      case StudyPlanDayDisplayState.empty:
        return _StudyDayVisualColors(
          backgroundColor: appColors.greyToGreyMediumDark,
          borderColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
          textColor: appColors.borderFieldColorNLightToborderFieldColorNDark,
          borderWidth: 1.5,
        );

      case StudyPlanDayDisplayState.unknown:
        return const _StudyDayVisualColors(
          backgroundColor: Color(0xffFAFAFB),
          borderColor: Color(0xffE2E2E5),
          textColor: Color(0xffB9BAC0),
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
