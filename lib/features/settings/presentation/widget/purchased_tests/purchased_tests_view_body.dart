import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_tests_tab_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';
import 'package:quiz_app_grad/features/settings/domain/entity/purchased_tests_entity.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/purchased_tests/purchased_tests_cubit.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/purchased_tests/purchased_tests_state.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/purchased_tests/purchased_tests_filter_section.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/widget/sold_tests/sold_tests_search_field.dart';

class PurchasedTestsViewBody extends StatefulWidget {
  const PurchasedTestsViewBody({super.key});

  @override
  State<PurchasedTestsViewBody> createState() => _PurchasedTestsViewBodyState();
}

class _PurchasedTestsViewBodyState extends State<PurchasedTestsViewBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    context.read<PurchasedTestsCubit>().search(value);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
    context.read<PurchasedTestsCubit>().clearSearch();
  }

  void _changeTab(PurchasedTestsTab tab) {
    _searchController.clear();
    setState(() {});
    context.read<PurchasedTestsCubit>().changeTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SoldTestsHeader(title: 'الاختبارات المشتراة'),
        SizedBox(height: SizeConfig.h(0.012)),
        BlocBuilder<PurchasedTestsCubit, PurchasedTestsState>(
          buildWhen: (previous, current) =>
              previous.selectedTab != current.selectedTab,
          builder: (context, state) {
            return PurchasedTestsFilterSection(
              selectedTab: state.selectedTab,
              onTabSelected: _changeTab,
            );
          },
        ),
        SizedBox(height: SizeConfig.h(0.015)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
          child: SoldTestsSearchField(
            controller: _searchController,
            hintText: 'ابحث في الاختبارات المشتراة',
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),
        ),
        SizedBox(height: SizeConfig.h(0.015)),
        Expanded(
          child: BlocBuilder<PurchasedTestsCubit, PurchasedTestsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return OtherProfileTestsTabShimmer(
                  horizonalPadding: SizeConfig.w(0.03),
                );
              }

              if (state.hasError) {
                return _PurchasedTestsFailure(
                  message: state.errorMessage!,
                  onRetry: context.read<PurchasedTestsCubit>().fetchInitial,
                );
              }

              return RefreshIndicator(
                onRefresh: context.read<PurchasedTestsCubit>().refresh,
                child: state.filteredTests.isEmpty
                    ? _PurchasedTestsEmpty(isSearching: state.isSearching)
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: SizeConfig.w(0.03),
                          right: SizeConfig.w(0.03),
                          bottom: SizeConfig.h(0.02),
                        ),
                        itemCount: state.filteredTests.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: SizeConfig.h(0.014)),
                        itemBuilder: (context, index) {
                          final test = state.filteredTests[index];
                          return OtherProfileTestCard(
                            item: _toOtherProfileTest(test),
                            onTestTap: () {
                              context.pushNamed(
                                AppRouterName.detailsOfTest,
                                extra: DetailsOfTestRouteArgs(testId: test.id),
                              );
                            },
                          );
                        },
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}

OtherProfileTestItemEntity _toOtherProfileTest(PurchasedTestEntity test) {
  return OtherProfileTestItemEntity(
    id: test.id,
    title: test.title,
    description: test.description,
    interests: test.interests,
    targetLevel: '',
    difficultyLevel: test.difficultyLevel,
    averageRating: test.averageRating,
    price: test.price,
    publishedAt: test.publishedAt,
    questionCount: test.questionCount,
  );
}

class _PurchasedTestsFailure extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PurchasedTestsFailure({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(0.05)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red),
            SizedBox(height: SizeConfig.h(0.012)),
            CustomTextWidget(
              message,
              color: Colors.red,
              textAlign: TextAlign.center,
              fontSize: SizeConfig.text(0.034),
            ),
            SizedBox(height: SizeConfig.h(0.018)),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchasedTestsEmpty extends StatelessWidget {
  final bool isSearching;

  const _PurchasedTestsEmpty({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: SizeConfig.h(0.03)),
        EmptyActionBox(
          icon: isSearching
              ? Icons.search_off_rounded
              : Icons.shopping_bag_outlined,
          title: isSearching ? 'لا توجد نتائج' : 'لا توجد اختبارات مشتراة',
          description: isSearching
              ? 'لم نعثر على اختبارات مشتراة مطابقة لبحثك.'
              : 'ستظهر هنا الاختبارات التي اشتريتها.',
        ),
      ],
    );
  }
}
