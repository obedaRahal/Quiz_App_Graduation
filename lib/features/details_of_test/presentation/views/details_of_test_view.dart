import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/submit_report_params.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_details_playmode_section_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_overview_tab_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/details_of_test_tabs_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/report_reason_bottom_sheet.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_purchase_bottom_bar.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/settimgs/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:share_plus/share_plus.dart';

class DetailsOfTestView extends StatelessWidget {
  const DetailsOfTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TopPageHeader(
            //   title: 'تفاصيل اختبار',
            //   onBack: () => context.pop(),
            //   onShare: () {
            //     debugPrint('share');
            //   },
            // ),
            BlocConsumer<DetailsOfTestCubit, DetailsOfTestState>(
              listenWhen: (previous, current) =>
                  previous.shareLinkStatus != current.shareLinkStatus,
              listener: (context, state) async {
                if (state.isShareLinkSuccess) {
                  final shareUrl = state.shareUrl;

                  if (shareUrl == null || shareUrl.isEmpty) {
                    showValidationTopSnackBar(
                      context,
                      title: "خطأ",
                      message: "تعذر تجهيز رابط المشاركة",
                      type: AppValidationSnackBarType.error,
                    );

                    context.read<DetailsOfTestCubit>().resetShareLinkState();
                    return;
                  }

                  await Share.share(shareUrl, subject: 'مشاركة اختبار من Nerd');

                  context.read<DetailsOfTestCubit>().resetShareLinkState();
                }

                if (state.isShareLinkFailure) {
                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? "خطأ",
                    message: state.errorMessage ?? "تعذر مشاركة الاختبار",
                    type: AppValidationSnackBarType.error,
                  );

                  context.read<DetailsOfTestCubit>().resetShareLinkState();
                }
              },
              builder: (context, state) {
                final overview = state.overviewDetails;

                return TopPageHeader(
                  title: 'تفاصيل اختبار',
                  onBack: () => context.pop(),
                  onShare: state.isShareLinkLoading
                      ? () {}
                      : () {
                          debugPrint('share');

                          if (overview == null) {
                            showValidationTopSnackBar(
                              context,
                              title: "تنبيه",
                              message: "لم يتم تحميل بيانات الاختبار بعد",
                              type: AppValidationSnackBarType.hint,
                            );
                            return;
                          }

                          context.read<DetailsOfTestCubit>().getTestShareLink(
                            testId: overview.data.id,
                          );
                        },
                );
              },
            ),

            SizedBox(height: SizeConfig.h(0.015)),
            CustomButtonWidget(
              onTap: () {
                debugPrint("change mode ");
                context.read<ThemeCubit>().toggleTheme();
              },
              child: ThemedAppImage(
                darkPath: AppImage.logoDark,
                lightPath: AppImage.logoLight,
              ),
            ),
            SizedBox(height: SizeConfig.h(0.015)),

            Expanded(
              child: BlocBuilder<DetailsOfTestCubit, DetailsOfTestState>(
                builder: (context, state) {
                  // if (state.isOverviewLoading) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                  if (state.isOverviewLoading) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const TestDetailsWithPlayModesSectionShimmer(),
                          SizedBox(height: SizeConfig.h(0.02)),
                          const TestOverviewTabShimmer(),
                        ],
                      ),
                    );
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
                        SizedBox(height: SizeConfig.h(0.015)),
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
                          onLikeValueTap: () {
                            debugPrint(
                              "like value is ${overview.data.basicInfo.likesCount}",
                            );
                          },
                          onBookmarkTap: () {
                            debugPrint("toggle bookmark");
                            context
                                .read<DetailsOfTestCubit>()
                                .toggleTestBookmark(testId: overview.data.id);
                          },
                          onBookmarkValueTap: () {
                            debugPrint(
                              "bookmark value is ${overview.data.basicInfo.bookmarksCount}",
                            );
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

            BlocConsumer<DetailsOfTestCubit, DetailsOfTestState>(
              listenWhen: (previous, current) =>
                  previous.downloadStatus != current.downloadStatus,
              listener: (context, state) {
                if (state.downloadStatus == DownloadTestFileStatus.loading) {
                  showValidationTopSnackBar(
                    context,
                    title: "تحميل",
                    message: "جاري تحميل ملف الاختبار...",
                    type: AppValidationSnackBarType.hint,
                  );
                }

                if (state.downloadStatus == DownloadTestFileStatus.success) {
                  showValidationTopSnackBar(
                    context,
                    title: "تم تحميل",
                    message: "تم حفظ ملف الاختبار بنجاح",
                    type: AppValidationSnackBarType.success,
                    actionText: 'عرض الاختبار',
                    onActionTap: () async {
                      debugPrint('show pdf');
                      final filePath = state.downloadedFilePath;

                      if (filePath == null || filePath.isEmpty) {
                        debugPrint('✗ downloadedFilePath is null');

                        showValidationTopSnackBar(
                          context,
                          title: "خطأ",
                          message: "تعذر العثور على ملف الاختبار",
                          type: AppValidationSnackBarType.error,
                        );

                        return;
                      }

                      debugPrint(
                        "============ Open Downloaded PDF ============",
                      );
                      debugPrint("→ filePath: $filePath");

                      final result = await OpenFilex.open(filePath);

                      debugPrint("→ open result type: ${result.type}");
                      debugPrint("→ open result message: ${result.message}");
                      debugPrint(
                        "=============================================",
                      );
                    },
                  );
                }

                if (state.downloadStatus == DownloadTestFileStatus.failure) {
                  showValidationTopSnackBar(
                    context,
                    title: state.errorTitle ?? "خطأ",
                    message: state.errorMessage ?? "تعذر تحميل ملف الاختبار",
                    type: AppValidationSnackBarType.error,
                  );
                }
              },
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
                  onDownloadTap: state.isDownloadLoading
                      ? () {}
                      : () {
                          debugPrint("download now");
                          context.read<DetailsOfTestCubit>().downloadTestFile(
                            testId: overview.data.id,
                          );
                        },
                  onReportTap: () {
                    debugPrint("report test");
                    debugPrint(
                      'report test and test id is  => ${overview.data.id}',
                    );
                    showReportReasonDialog(
                      context: context,
                      cubit: context.read<DetailsOfTestCubit>(),
                      title: 'الإبلاغ عن اختبار',
                      reasons: const [
                        ReportReasonUiModel(
                          label:
                              'اختبار محتواه مسيء (أخلاقيا - دينيا - اجتماعيا)',
                        ),
                        ReportReasonUiModel(
                          label: 'يوجد أخطاء في طريقة صياغة السؤال',
                        ),
                        ReportReasonUiModel(
                          label: 'يوجد خطأ في الاختيارات المطروحة في السؤال',
                        ),
                        ReportReasonUiModel(
                          label: 'الإجابة الصحيحة لا يجب ان تكون هي الإجابة',
                        ),
                        ReportReasonUiModel(label: 'يوجد خطأ في الشرح'),
                      ],
                      descriptionHint:
                          'صف لنا المشكلة التي تواجه هذا الاختبار بطريقة مختصرة وواضحة',
                      onSubmit: (reason, description) {
                        context
                            .read<DetailsOfTestCubit>()
                            .submitReportCommentAndTest(
                              targetType: ReportTargetType.test,
                              targetId: overview.data.id,
                              reason: reason.label,
                              description: description,
                            );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
