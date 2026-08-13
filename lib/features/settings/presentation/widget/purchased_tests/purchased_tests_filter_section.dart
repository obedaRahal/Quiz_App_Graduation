import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/purchased_tests/purchased_tests_state.dart';

class PurchasedTestsFilterSection extends StatelessWidget {
  final PurchasedTestsTab selectedTab;
  final ValueChanged<PurchasedTestsTab> onTabSelected;

  const PurchasedTestsFilterSection({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  static const filters = [
    OtherProfileFilterOption<PurchasedTestsTab>(
      title: 'اليوم',
      value: PurchasedTestsTab.today,
    ),
    OtherProfileFilterOption<PurchasedTestsTab>(
      title: 'الشهر',
      value: PurchasedTestsTab.month,
    ),
    OtherProfileFilterOption<PurchasedTestsTab>(
      title: 'الأقدم',
      value: PurchasedTestsTab.older,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: OtherProfileHorizontalFilterSection<PurchasedTestsTab>(
        selectedFilter: selectedTab,
        filters: filters,
        onFilterSelected: onTabSelected,
      ),
    );
  }
}
