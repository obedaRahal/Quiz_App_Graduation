import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/profile_shared/profile_tabs_section.dart';
import 'package:quiz_app_grad/features/study_plan/presentation/manager/study_plan_details/study_plan_details_state.dart';

class StudyPlanDetailsTabsSection extends StatelessWidget {
  final StudyPlanDetailsTab selectedTab;
  final ValueChanged<StudyPlanDetailsTab> onTabSelected;

  const StudyPlanDetailsTabsSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const tabs = [
    ProfileTabItem<StudyPlanDetailsTab>(
      title: 'نظرة عامة',
      tab: StudyPlanDetailsTab.overview,
    ),
    ProfileTabItem<StudyPlanDetailsTab>(
      title: 'قائمة المهام',
      tab: StudyPlanDetailsTab.tasks,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.65,
        child: ProfileTabsSection<StudyPlanDetailsTab>(
          selectedTab: selectedTab,
          tabs: tabs,
          onTabSelected: onTabSelected,
        ),
      ),
    );
  }
}
