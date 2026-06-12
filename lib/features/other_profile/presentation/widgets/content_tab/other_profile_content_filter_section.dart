import 'package:flutter/material.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_horizontal_filter_section.dart';

class OtherProfileContentFilterSection extends StatelessWidget {
  final OtherProfileContentFilter selectedFilter;
  final ValueChanged<OtherProfileContentFilter> onFilterSelected;

  const OtherProfileContentFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  static const filters = [
    OtherProfileFilterOption(
      title: 'الأحدث',
      value: OtherProfileContentFilter.latest,
    ),
    OtherProfileFilterOption(
      title: 'الأشهر',
      value: OtherProfileContentFilter.popular,
    ),
    OtherProfileFilterOption(
      title: 'ملفات',
      value: OtherProfileContentFilter.files,
    ),
    OtherProfileFilterOption(
      title: 'صور',
      value: OtherProfileContentFilter.images,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OtherProfileHorizontalFilterSection<OtherProfileContentFilter>(
      selectedFilter: selectedFilter,
      filters: filters,
      onFilterSelected: onFilterSelected,
    );
  }
}
