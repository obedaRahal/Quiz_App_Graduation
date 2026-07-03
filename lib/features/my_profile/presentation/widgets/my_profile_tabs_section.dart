import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/profile_shared/profile_tabs_section.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/cubit/my_profile_state.dart';

class MyProfileTabsSection extends StatelessWidget {
  final MyProfileTab selectedTab;
  final ValueChanged<MyProfileTab> onTabSelected;

  const MyProfileTabsSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const tabs = [
    ProfileTabItem(title: 'معلومات شخصية', tab: MyProfileTab.personalInfo),
    ProfileTabItem(title: 'الاختبارات', tab: MyProfileTab.tests),
    ProfileTabItem(title: 'المجلدات', tab: MyProfileTab.folders),
    ProfileTabItem(title: 'المحتوى', tab: MyProfileTab.content),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfileTabsSection<MyProfileTab>(
      selectedTab: selectedTab,
      tabs: tabs,
      onTabSelected: onTabSelected,
    );
  }
}