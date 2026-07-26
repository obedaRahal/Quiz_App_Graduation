import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_folder_editor/my_profile_folder_editor_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/tests_tab/filter/my_profile_tests_header_section.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/tests_tab/my_profile_tests_search_field.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_tests_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_tests_tab_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';

class MyProfileTestsTab extends StatelessWidget {
  const MyProfileTestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      buildWhen: (previous, current) =>
          previous.selectedTestsTab != current.selectedTestsTab ||
          previous.testsStatus != current.testsStatus ||
          previous.testsLoadMoreStatus != current.testsLoadMoreStatus ||
          previous.testsResponse != current.testsResponse ||
          previous.testsSearchQuery != current.testsSearchQuery ||
          previous.testsSearchStatus != current.testsSearchStatus ||
          previous.testsSearchLoadMoreStatus !=
              current.testsSearchLoadMoreStatus ||
          previous.testsSearchResponse != current.testsSearchResponse ||
          previous.isTestsFilterMode != current.isTestsFilterMode ||
          previous.testsFilterStatus != current.testsFilterStatus ||
          previous.testsFilterLoadMoreStatus !=
              current.testsFilterLoadMoreStatus ||
          previous.filteredTestsResponse != current.filteredTestsResponse ||
          previous.activeTestsFilterParams != current.activeTestsFilterParams,
      builder: (context, state) {
        final isFilterMode = state.isTestsFilterMode;

        final normalTests = state.visibleTests;
        final filteredTests = state.filteredTestsResponse?.data ?? const [];

        final isLoading = isFilterMode
            ? state.isTestsFilterLoading
            : state.isVisibleTestsLoading;

        final isFailure = isFilterMode
            ? state.isTestsFilterFailure
            : state.isVisibleTestsFailure;

        final isLoadingMore = isFilterMode
            ? state.isTestsFilterLoadingMore
            : state.isVisibleTestsLoadingMore;

        final isEmpty = isFilterMode
            ? filteredTests.isEmpty
            : normalTests.isEmpty;
        final visibleError = isFilterMode
            ? state.testsFilterError
            : state.hasTestsSearchQuery
            ? state.testsSearchError
            : state.testsError;
        final shouldShowEmptyState =
            isEmpty &&
            (!isFailure || _isEmptyFilterFailure(state, visibleError));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyProfileTestsSearchField(
              value: state.testsSearchQuery,
              onChanged: context
                  .read<MyProfileCubit>()
                  .changeMyProfileTestsSearchQuery,
              onClear: context.read<MyProfileCubit>().clearMyProfileTestsSearch,
            ),

            SizedBox(height: SizeConfig.h(0.014)),

            const MyProfileTestsHeaderSection(),

            SizedBox(height: SizeConfig.h(0.018)),

            if (isLoading)
              OtherProfileTestsTabShimmer()
            else if (shouldShowEmptyState)
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.06)),
                child: Center(
                  child: CustomTextWidget(
                    _emptyMessage(state),
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.034),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (isFailure)
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.06)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        visibleError?.message ?? 'حدث خطأ أثناء جلب الاختبارات',
                        color: AppPalette.red,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.h(0.014)),
                      ElevatedButton.icon(
                        onPressed: () => _retryInitial(context, state),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              )
            else if (isFilterMode)
              _FilteredTestsList(
                tests: filteredTests,
                isLoadingMore: isLoadingMore,
                selectedTab: state.selectedTestsTab,
                loadMoreErrorMessage:
                    state.testsFilterLoadMoreStatus ==
                        MyProfileTestsFilterLoadMoreStatus.failure
                    ? state.testsFilterError?.message
                    : null,
                onRetryLoadMore: context
                    .read<MyProfileCubit>()
                    .fetchMoreMyProfileFilteredTestsIfNeeded,
              )
            else
              _NormalTestsList(
                tests: normalTests,
                isLoadingMore: isLoadingMore,
                selectedTab: state.selectedTestsTab,
                loadMoreErrorMessage: state.hasTestsSearchQuery
                    ? state.testsSearchLoadMoreStatus ==
                              MyProfileTestsSearchLoadMoreStatus.failure
                          ? state.testsSearchError?.message
                          : null
                    : state.testsLoadMoreStatus ==
                          MyProfileTestsLoadMoreStatus.failure
                    ? state.testsError?.message
                    : null,
                onRetryLoadMore: () {
                  final cubit = context.read<MyProfileCubit>();
                  if (state.hasTestsSearchQuery) {
                    cubit.fetchMoreMyProfileTestsSearchIfNeeded();
                  } else {
                    cubit.fetchMoreMyProfileTestsIfNeeded();
                  }
                },
              ),
          ],
        );
      },
    );
  }

  String _emptyMessage(MyProfileState state) {
    if (state.isTestsFilterMode) {
      return 'لا توجد اختبارات مطابقة للفلاتر المحددة';
    }

    if (state.hasTestsSearchQuery) {
      return 'لا توجد نتائج مطابقة لبحثك';
    }

    return 'لا توجد اختبارات ضمن هذا التصنيف';
  }

  bool _isEmptyFilterFailure(
    MyProfileState state,
    MyProfileOperationError? error,
  ) {
    if (!state.isTestsFilterMode || !state.isTestsFilterFailure) {
      return false;
    }

    final message = '${error?.title ?? ''} ${error?.message ?? ''}'
        .trim()
        .toLowerCase();

    return message.contains('لا توجد اختبارات') ||
        message.contains('لا يوجد اختبارات') ||
        message.contains('لا توجد نتائج') ||
        message.contains('لا يوجد نتائج') ||
        message.contains('لم يتم العثور على اختبارات') ||
        message.contains('no tests') ||
        message.contains('no results');
  }

  void _retryInitial(BuildContext context, MyProfileState state) {
    final cubit = context.read<MyProfileCubit>();
    if (state.isTestsFilterMode) {
      final params = state.activeTestsFilterParams;
      if (params != null) {
        cubit.applyMyProfileTestsFilter(params);
      }
      return;
    }

    if (state.hasTestsSearchQuery) {
      cubit.searchMyProfileTestsInitial(query: state.testsSearchQuery);
      return;
    }

    cubit.fetchMyProfileTestsInitial();
  }
}

class _NormalTestsList extends StatelessWidget {
  final List<MyProfilePickerTestItemEntity> tests;
  final bool isLoadingMore;
  final MyProfilePickerTestsTab selectedTab;
  final String? loadMoreErrorMessage;
  final VoidCallback onRetryLoadMore;

  const _NormalTestsList({
    required this.tests,
    required this.isLoadingMore,
    required this.selectedTab,
    required this.loadMoreErrorMessage,
    required this.onRetryLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          tests.length +
          (isLoadingMore || loadMoreErrorMessage != null ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.014)),
      itemBuilder: (context, index) {
        if (index >= tests.length) {
          if (loadMoreErrorMessage != null) {
            return _LoadMoreError(
              message: loadMoreErrorMessage!,
              onRetry: onRetryLoadMore,
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final test = tests[index];

        return OtherProfileTestCard(
          item: _mapNormalTest(test),
          onTestTap: () {
            debugPrint("my test and test id is ${test.id}  ");
            final routeName = selectedTab == MyProfilePickerTestsTab.private
                ? AppRouterName.myPrivateTestDetails
                : AppRouterName.myTestDetails;

            debugPrint(
              'Opening test: ${test.id}, '
              'tab: ${selectedTab.apiValue}, '
              'route: $routeName',
            );

            context.pushNamed(
              routeName,
              extra: DetailsOfTestRouteArgs(testId: test.id),
            );
          },
        );
      },
    );
  }

  OtherProfileTestItemEntity _mapNormalTest(
    MyProfilePickerTestItemEntity test,
  ) {
    return OtherProfileTestItemEntity(
      id: test.id,
      title: test.title,
      description: test.description,
      interests: test.interestNames,
      difficultyLevel: test.targetLevel,
      targetLevel: test.targetLevel,
      averageRating: test.averageRating,
      price: _formatPrice(test.price),
      publishedAt: test.publishedAt,
      questionCount: test.questionCount,
    );
  }

  String _formatPrice(num price) {
    if (price == 0) return '0';

    final value = price.toDouble();

    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}

OtherProfileTestItemEntity _mapToOtherProfileTest(
  MyProfilePickerTestItemEntity test,
) {
  return OtherProfileTestItemEntity(
    id: test.id,
    title: test.title,
    description: test.description,
    interests: test.interestNames,

    // الـ API الحالي يعيد target_level بدل difficulty_level.
    // لذلك نعرض المستوى في مكان الشارة.
    difficultyLevel: test.targetLevel,

    targetLevel: test.targetLevel,
    averageRating: test.averageRating,
    price: _formatPrice(test.price),
    publishedAt: test.publishedAt,
    questionCount: test.questionCount,
  );
}

String _formatPrice(num price) {
  if (price == 0) return '0';

  final value = price.toDouble();

  if (value == value.truncateToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
}

class _FilteredTestsList extends StatelessWidget {
  final List<MyProfileFilteredTestItemEntity> tests;
  final bool isLoadingMore;
  final MyProfilePickerTestsTab selectedTab;
  final String? loadMoreErrorMessage;
  final VoidCallback onRetryLoadMore;

  const _FilteredTestsList({
    required this.tests,
    required this.isLoadingMore,
    required this.selectedTab,
    required this.loadMoreErrorMessage,
    required this.onRetryLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          tests.length +
          (isLoadingMore || loadMoreErrorMessage != null ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.014)),
      itemBuilder: (context, index) {
        if (index >= tests.length) {
          if (loadMoreErrorMessage != null) {
            return _LoadMoreError(
              message: loadMoreErrorMessage!,
              onRetry: onRetryLoadMore,
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final test = tests[index];

        return OtherProfileTestCard(
          item: OtherProfileTestItemEntity(
            id: test.id,
            title: test.title,
            description: test.description,
            interests: test.interests,
            difficultyLevel: test.difficultyLevel,
            targetLevel: '',
            averageRating: test.averageRating,
            price: test.price,
            publishedAt: test.publishedAt,
            questionCount: test.questionCount,
          ),
          onTestTap: () {
            final routeName = selectedTab == MyProfilePickerTestsTab.private
                ? AppRouterName.myPrivateTestDetails
                : AppRouterName.myTestDetails;
            context.pushNamed(
              routeName,
              extra: DetailsOfTestRouteArgs(testId: test.id),
            );
          },
        );
      },
    );
  }
}

class _LoadMoreError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LoadMoreError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.014)),
      child: Column(
        children: [
          CustomTextWidget(
            message,
            color: AppPalette.red,
            textAlign: TextAlign.center,
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
