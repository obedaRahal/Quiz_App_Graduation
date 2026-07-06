import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class MyProfileBookmarksFilterSection extends StatelessWidget {
  final MyProfileBookmarksTab selectedTab;
  final ValueChanged<MyProfileBookmarksTab> onTabSelected;

  const MyProfileBookmarksFilterSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'اختبارات',
      value: MyProfileBookmarksTab.tests,
    ),
    OtherProfileFilterOption(
      title: 'محتوى',
      value: MyProfileBookmarksTab.materials,
    ),
    OtherProfileFilterOption(
      title: 'قوائم',
      value: MyProfileBookmarksTab.folders,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: OtherProfileHorizontalFilterSection<MyProfileBookmarksTab>(
        selectedFilter: selectedTab,
        filters: filters,
        onFilterSelected: onTabSelected,
      ),
    );
  }
}
