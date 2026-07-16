import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/create_edit_folder/my_profile_picker_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_filtered_tests_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile/my_profile_state.dart';
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
          // حالات الفلترة الجديدة
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

            if (isFilterMode) ...[
              SizedBox(height: SizeConfig.h(0.008)),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: context
                      .read<MyProfileCubit>()
                      .clearMyProfileTestsFilter,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('إلغاء الفلتر'),
                ),
              ),
            ],

            SizedBox(height: SizeConfig.h(0.018)),

            if (isLoading)
              OtherProfileTestsTabShimmer()
            else if (isFailure)
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.06)),
                child: Center(
                  child: CustomTextWidget(
                    state.errorMessage ?? 'حدث خطأ أثناء جلب الاختبارات',
                    color: AppPalette.red,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (isEmpty)
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
            else if (isFilterMode)
              _FilteredTestsList(
                tests: filteredTests,
                isLoadingMore: isLoadingMore,
              )
            else
              _NormalTestsList(
                tests: normalTests,
                isLoadingMore: isLoadingMore,
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
}

class _NormalTestsList extends StatelessWidget {
  final List<MyProfilePickerTestItemEntity> tests;
  final bool isLoadingMore;

  const _NormalTestsList({required this.tests, required this.isLoadingMore});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tests.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.014)),
      itemBuilder: (context, index) {
        if (index >= tests.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final test = tests[index];

        return OtherProfileTestCard(item: _mapNormalTest(test));
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

  const _FilteredTestsList({required this.tests, required this.isLoadingMore});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tests.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: SizeConfig.h(0.014)),
      itemBuilder: (context, index) {
        if (index >= tests.length) {
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
        );
      },
    );
  }
}
