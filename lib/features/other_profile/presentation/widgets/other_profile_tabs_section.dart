import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/profile_shared/profile_tabs_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileTabsSection extends StatelessWidget {
  final OtherProfileTab selectedTab;
  final ValueChanged<OtherProfileTab> onTabSelected;

  const OtherProfileTabsSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const tabs = [
    ProfileTabItem(title: 'نظرة عامة', tab: OtherProfileTab.overview),
    ProfileTabItem(title: 'الاختبارات', tab: OtherProfileTab.tests),
    ProfileTabItem(title: 'المجلدات', tab: OtherProfileTab.folder),
    ProfileTabItem(title: 'المحتوى', tab: OtherProfileTab.content),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfileTabsSection<OtherProfileTab>(
      selectedTab: selectedTab,
      tabs: tabs,
      onTabSelected: onTabSelected,
    );
  }
}