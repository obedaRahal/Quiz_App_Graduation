import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class OtherProfileTestsFilterSection extends StatelessWidget {
  final OtherProfileTestsFilter selectedFilter;
  final ValueChanged<OtherProfileTestsFilter> onFilterSelected;

  const OtherProfileTestsFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'مدفوعة',
      value: OtherProfileTestsFilter.paid,
    ),
    OtherProfileFilterOption(
      title: 'مجانية',
      value: OtherProfileTestsFilter.free,
    ),
    OtherProfileFilterOption(
      title: 'الأحدث',
      value: OtherProfileTestsFilter.latest,
    ),
    OtherProfileFilterOption(
      title: 'الأكثر تقدمًا',
      value: OtherProfileTestsFilter.popular,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OtherProfileHorizontalFilterSection<OtherProfileTestsFilter>(
      selectedFilter: selectedFilter,
      filters: filters,
      onFilterSelected: onFilterSelected,
    );
  }
}
