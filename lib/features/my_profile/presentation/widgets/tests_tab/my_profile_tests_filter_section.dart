import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class MyProfileTestsFilterSection extends StatelessWidget {
  final MyProfilePickerTestsTab selectedTab;
  final ValueChanged<MyProfilePickerTestsTab> onTabSelected;

  const MyProfileTestsFilterSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'عامة',
      value: MyProfilePickerTestsTab.public,
    ),
    OtherProfileFilterOption(
      title: 'خاصة',
      value: MyProfilePickerTestsTab.private,
    ),
    OtherProfileFilterOption(
      title: 'مدفوعة',
      value: MyProfilePickerTestsTab.paid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OtherProfileHorizontalFilterSection<
        MyProfilePickerTestsTab>(
      selectedFilter: selectedTab,
      filters: filters,
      onFilterSelected: onTabSelected,
    );
  }
}