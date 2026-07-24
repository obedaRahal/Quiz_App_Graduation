import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/sold_tests/sold_tests_state.dart';

class SoldTestsFilterSection extends StatelessWidget {
  final SoldTestsTab selectedTab;
  final ValueChanged<SoldTestsTab> onTabSelected;

  const SoldTestsFilterSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const filters = [
    OtherProfileFilterOption<SoldTestsTab>(
      title: 'الكل',
      value: SoldTestsTab.all,
    ),
    OtherProfileFilterOption<SoldTestsTab>(
      title: 'اليوم',
      value: SoldTestsTab.today,
    ),
    OtherProfileFilterOption<SoldTestsTab>(
      title: 'أسبوع',
      value: SoldTestsTab.week,
    ),
    OtherProfileFilterOption<SoldTestsTab>(
      title: 'شهر',
      value: SoldTestsTab.month,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: OtherProfileHorizontalFilterSection<SoldTestsTab>(
        selectedFilter: selectedTab,
        filters: filters,
        onFilterSelected: onTabSelected,
      ),
    );
  }
}
