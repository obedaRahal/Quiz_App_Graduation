import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/details_of_test_tabs_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_purchase_bottom_bar.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';

class DetailsOfTestView extends StatelessWidget {
  const DetailsOfTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageHeader(
              title: 'تفاصيل اختبار',
              onBack: () => context.pop(),
              onShare: () {
                debugPrint('share');
              },
            ),

            SizedBox(height: SizeConfig.h(0.015)),

            Expanded(
              child: BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
                builder: (context, state) {
                  if (state.isOverviewLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.isOverviewFailure) {
                    return Center(
                      child: CustomTextWidget(
                        state.errorMessage ?? 'حدث خطأ أثناء جلب التفاصيل',
                        color: AppPalette.red,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final overview = state.overviewDetails;

                  if (overview == null) {
                    return const SizedBox.shrink();
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        TestDetailsWithPlayModesSection(
                          title: overview.data.basicInfo.title,
                          description: overview.data.basicInfo.description,
                          difficultyLevel:
                              overview.data.basicInfo.difficultyLevel,
                          price: overview.data.basicInfo.price,
                          likesCount: overview.data.basicInfo.likesCount,
                          reviewsCount: overview.data.basicInfo.reviewsCount,
                          bookmarksCount:
                              overview.data.basicInfo.bookmarksCount,
                          hasLiked:
                              overview.data.extraInfo.viewerContext.hasLiked,
                          hasBookmarked: overview
                              .data
                              .extraInfo
                              .viewerContext
                              .hasBookmarked,
                          onLikeTap: () {
                            debugPrint("toggle like");
                            context.read<DetailsOfTestCubit>().toggleTestLike(
                              testId: overview.data.id,
                            );
                          },
                          onBookmarkTap: () {
                            debugPrint("toggle bookmark");
                            context
                                .read<DetailsOfTestCubit>()
                                .toggleTestBookmark(testId: overview.data.id);
                          },
                        ),

                        SizedBox(height: SizeConfig.h(0.035)),

                        DetailsOfTestTabsSection(
                          overview: overview,
                          testId: overview.data.id,
                        ),

                        SizedBox(height: SizeConfig.h(0.02)),
                      ],
                    ),
                  );
                },
              ),
            ),

            BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
              builder: (context, state) {
                final overview = state.overviewDetails;

                if (overview == null) {
                  return const SizedBox.shrink();
                }

                return TestPurchaseBottomBar(
                  reviewStatus: overview.data.extraInfo.reviewStatus,
                  isFree: overview.data.extraInfo.viewerContext.isFree,
                  hasPurchased:
                      overview.data.extraInfo.viewerContext.hasPurchased,
                  canPurchase:
                      overview.data.extraInfo.viewerContext.canPurchase,
                  canDownload:
                      overview.data.extraInfo.viewerContext.canDownload,
                  canReport: overview.data.extraInfo.viewerContext.canReport,

                  onBuyTap: () {
                    debugPrint("buy now");
                  },
                  onDownloadTap: () => debugPrint("download test"),
                  onReportTap: () => debugPrint("report test"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
