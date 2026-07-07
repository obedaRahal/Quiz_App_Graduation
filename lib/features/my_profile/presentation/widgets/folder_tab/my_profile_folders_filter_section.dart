import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class MyProfileFoldersFilterSection extends StatelessWidget {
  final MyProfileFoldersTabEnum selectedFilter;
  final ValueChanged<MyProfileFoldersTabEnum> onFilterSelected;

  const MyProfileFoldersFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'الأحدث',
      value: MyProfileFoldersTabEnum.latest,
    ),
    OtherProfileFilterOption(title: 'عامة', value: MyProfileFoldersTabEnum.public),
    OtherProfileFilterOption(title: 'خاصة', value: MyProfileFoldersTabEnum.private),
  ];

  @override
  Widget build(BuildContext context) {
    return OtherProfileHorizontalFilterSection<MyProfileFoldersTabEnum>(
      selectedFilter: selectedFilter,
      filters: filters,
      onFilterSelected: onFilterSelected,
    );
  }
}
