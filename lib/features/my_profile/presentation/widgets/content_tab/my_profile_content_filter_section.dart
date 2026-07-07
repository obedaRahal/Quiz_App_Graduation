// lib/features/my_profile/presentation/widgets/content_tab/my_profile_content_filter_section.dart

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class MyProfileContentFilterSection extends StatelessWidget {
  final MyProfileLibraryTab selectedTab;
  final ValueChanged<MyProfileLibraryTab> onTabSelected;

  const MyProfileContentFilterSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'الأحدث',
      value: MyProfileLibraryTab.latest,
    ),
    OtherProfileFilterOption(title: 'عامة', value: MyProfileLibraryTab.public),
    OtherProfileFilterOption(title: 'خاصة', value: MyProfileLibraryTab.private),
  ];

  @override
  Widget build(BuildContext context) {
    return OtherProfileHorizontalFilterSection<MyProfileLibraryTab>(
      selectedFilter: selectedTab,
      filters: filters,
      onFilterSelected: onTabSelected,
    );
  }
}
