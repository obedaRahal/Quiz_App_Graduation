import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/managet/tests_by_interest_cubit/tests_by_interest_cubit.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/managet/tests_by_interest_cubit/tests_by_interest_state.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/widgets/tests_by_interest_header.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/widgets/tests_by_interest_search_field.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/widgets/tests_by_interest_section_title.dart';
import 'package:quiz_app_grad/features/tests_by_interest/presentation/widgets/tests_by_interest_ticket_card.dart';

class TestsByInterestPage extends StatelessWidget {
  final int interestId;
  final String interestName;

  const TestsByInterestPage({
    super.key,
    required this.interestId,
    required this.interestName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<TestsByInterestCubit>()
            ..getTestsByInterest(interestId: interestId),
      child: _TestsByInterestView(
        interestId: interestId,
        interestName: interestName,
      ),
    );
  }
}

class _TestsByInterestView extends StatefulWidget {
  final int interestId;
  final String interestName;

  const _TestsByInterestView({
    required this.interestId,
    required this.interestName,
  });

  @override
  State<_TestsByInterestView> createState() => _TestsByInterestViewState();
}

class _TestsByInterestViewState extends State<_TestsByInterestView> {
  final ScrollController _scrollController = ScrollController();

  bool _didRequestNextPageForCurrentScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _onRefresh() async {
    _didRequestNextPageForCurrentScroll = false;

    await context.read<TestsByInterestCubit>().refreshTests(
      interestId: widget.interestId,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.maxScrollExtent <= 0) return;

    final triggerOffset = position.maxScrollExtent * 0.50;

    if (position.pixels >= triggerOffset) {
      if (_didRequestNextPageForCurrentScroll) return;

      _didRequestNextPageForCurrentScroll = true;

      context.read<TestsByInterestCubit>().loadMoreTests(
        interestId: widget.interestId,
      );
    }

    if (position.pixels < triggerOffset) {
      _didRequestNextPageForCurrentScroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const TestsByInterestHeader(),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(0.045),
                  vertical: SizeConfig.h(0.012),
                ),
                child: TestsByInterestSearchField(
                  onChanged: (value) {
                    context.read<TestsByInterestCubit>().searchTests(
                      interestId: widget.interestId,
                      query: value,
                    );
                  },
                  onClear: () {
                    context.read<TestsByInterestCubit>().clearSearch();
                  },
                ),
              ),

              TestsByInterestSectionTitle(title: widget.interestName),

              // Expanded(
              //   child: BlocBuilder<TestsByInterestCubit, TestsByInterestState>(
              //     builder: (context, state) {
              //       if (state.isInitialLoading) {
              //         return const Center(child: CircularProgressIndicator());
              //       }

              //       if (state.errorMessage != null && state.tests.isEmpty) {
              //         return Center(
              //           child: CustomTextWidget(
              //             'حدث خطأ أثناء جلب الاختبارات',
              //             color: AppPalette.greyMedium,
              //             fontSize: SizeConfig.text(0.038),
              //           ),
              //         );
              //       }

              //       if (state.tests.isEmpty) {
              //         return Center(
              //           child: CustomTextWidget(
              //             'لا توجد اختبارات ضمن هذا التصنيف حالياً',
              //             color: AppPalette.greyMedium,
              //             fontSize: SizeConfig.text(0.038),
              //           ),
              //         );
              //       }

              //       return RefreshIndicator(
              //         onRefresh: _onRefresh,
              //         child: ListView.separated(
              //           controller: _scrollController,
              //           physics: const AlwaysScrollableScrollPhysics(),
              //           padding: EdgeInsets.only(
              //             top: SizeConfig.h(0.014),
              //             bottom: SizeConfig.h(0.03),
              //           ),
              //           itemCount: state.tests.length,
              //           separatorBuilder: (_, __) =>
              //               SizedBox(height: SizeConfig.h(0.018)),
              //           itemBuilder: (context, index) {
              //             return TestsByInterestTicketCard(
              //               item: state.tests[index],
              //             );
              //           },
              //         ),
              //       );
              //     },
              //   ),
              // ),
              Expanded(
                child: BlocBuilder<TestsByInterestCubit, TestsByInterestState>(
                  builder: (context, state) {
                    final visibleTests = state.isSearchMode
                        ? state.searchResults
                        : state.tests;

                    final isLoading = state.isSearchMode
                        ? state.isSearchLoading
                        : state.isInitialLoading;

                    final errorMessage = state.isSearchMode
                        ? state.searchErrorMessage
                        : state.errorMessage;

                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (errorMessage != null && visibleTests.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          state.isSearchMode
                              ? 'حدث خطأ أثناء البحث عن الاختبارات'
                              : 'حدث خطأ أثناء جلب الاختبارات',
                          color: AppPalette.greyMedium,
                          fontSize: SizeConfig.text(0.038),
                        ),
                      );
                    }

                    if (visibleTests.isEmpty) {
                      return Center(
                        child: CustomTextWidget(
                          state.isSearchMode
                              ? 'لا توجد نتائج مطابقة'
                              : 'لا توجد اختبارات ضمن هذا التصنيف حالياً',
                          color: AppPalette.greyMedium,
                          fontSize: SizeConfig.text(0.038),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: SizeConfig.h(0.014),
                          bottom: SizeConfig.h(0.03),
                        ),
                        itemCount: visibleTests.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: SizeConfig.h(0.018)),
                        itemBuilder: (context, index) {
                          return TestsByInterestTicketCard(
                            item: visibleTests[index],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
