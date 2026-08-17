import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
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
  final bool hasLoadMoreError;
  final String? loadMoreErrorMessage;
  final VoidCallback onRetryLoadMore;

  const OtherProfileTestsTab({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.tests,
    required this.isLoading,
    this.shimmerLoader,

    required this.isLoadingMore,
    required this.hasLoadMoreError,
    required this.loadMoreErrorMessage,
    required this.onRetryLoadMore,
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
          const EmptyActionBox(
            icon: Icons.quiz_outlined,
            title: 'لا توجد اختبارات',
            description: 'لا توجد اختبارات متاحة ضمن هذا التصنيف حالياً',
          )
        else
          Column(
            children: [
              ...tests.map((test) {
                return Padding(
                  padding: EdgeInsets.only(bottom: SizeConfig.h(0.014)),
                  child: OtherProfileTestCard(
                    item: test,
                    onTestTap: () {
                      debugPrint("test id is ${test.id}");
                      context.pushNamed(
                        AppRouterName.detailsOfTest,
                        extra: DetailsOfTestRouteArgs(testId: test.id),
                      );
                    },
                  ),
                );
              }),

              if (isLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
                  child: const Center(child: CircularProgressIndicator()),
                )
              else if (hasLoadMoreError)
                _LoadMoreError(
                  message: loadMoreErrorMessage,
                  onRetry: onRetryLoadMore,
                ),
            ],
          ),
      ],
    );
  }
}

class _LoadMoreError extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _LoadMoreError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
      child: Column(
        children: [
          Text(
            message ?? 'تعذر تحميل المزيد من الاختبارات',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
