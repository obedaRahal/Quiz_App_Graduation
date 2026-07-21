import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/study_plan/domain/use_cases/params/get_study_plans_params.dart';

class StudyPlansFilterSection extends StatelessWidget {
  final StudyPlansTab selectedTab;
  final ValueChanged<StudyPlansTab> onTabSelected;
  final bool isLoading;

  const StudyPlansFilterSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    this.isLoading = false,
  });

  static const List<StudyPlansTab> tabs = [
    StudyPlansTab.current,
    StudyPlansTab.expired,
    StudyPlansTab.future,
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          textDirection: TextDirection.rtl,
          children: tabs.map((tab) {
            final isSelected = selectedTab == tab;

            return Padding(
              padding: EdgeInsets.only(left: SizeConfig.w(0.02)),
              child: _StudyPlansFilterChip(
                title: tab.title,
                isSelected: isSelected,
                isLoading: isLoading && isSelected,
                onTap: () {
                  if (!isLoading) {
                    onTabSelected(tab);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StudyPlansFilterChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _StudyPlansFilterChip({
    required this.title,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final selectedColor = appColors.primaryToPrimaryDark;

    final unselectedColor = isDark
        ? AppPalette.greyMediumDark
        : AppPalette.whiteToGrey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          constraints: BoxConstraints(minWidth: SizeConfig.w(0.22)),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.035),
            vertical: SizeConfig.h(0.006),
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isLoading
              ? SizedBox(
                  width: SizeConfig.w(0.04),
                  height: SizeConfig.w(0.04),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : CustomTextWidget(
                  title,
                  fontSize: SizeConfig.text(0.031),
                  color: isSelected ? appColors.whiteToblack : AppPalette.greyMedium,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ),
    );
  }
}
