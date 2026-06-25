import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_tests_tab_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_tests_filter_section.dart';

class OtherProfileTestsTab extends StatelessWidget {
  final OtherProfileTestsFilter selectedFilter;
  final ValueChanged<OtherProfileTestsFilter> onFilterSelected;
  final List<OtherProfileTestItemEntity> tests;
  final bool isLoading;
  final Widget? shimmerLoader;

  final bool isLoadingMore;

  const OtherProfileTestsTab({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.tests,
    required this.isLoading,
    this.shimmerLoader,

    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        OtherProfileTestsFilterSection(
          selectedFilter: selectedFilter,
          onFilterSelected: onFilterSelected,
        ),
        SizedBox(height: SizeConfig.h(0.018)),

        if (isLoading)
          shimmerLoader ?? const OtherProfileTestsTabShimmer()
        else if (tests.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.05)),
              child: const Text(
                'لا توجد اختبارات متاحة ضمن هذا التصنيف الحالي',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
        //OtherProfileTestsTabShimmer(),
          Column(
            children: [
              ...tests.map((test) {
                return Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
                  child: OtherProfileTestCard(item: test),
                );
              }),

              if (isLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
      ],
    );
  }
}
