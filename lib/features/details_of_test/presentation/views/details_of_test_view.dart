import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_themed_app_image.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/details_of_test/domain/use_cases/params/submit_report_params.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/bottom_sheets/test_interaction_users_bottom_sheet.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/test_interaction_users_cubit/cubit/test_interaction_users_state.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_details_playmode_section_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_overview_tab_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/details_of_test_tabs_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/report_reason_bottom_sheet.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_purchase_bottom_bar.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/settings/presentation/manager/theme_cubit/theme_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/models/test_play_modes_route_args.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsOfTestView extends StatefulWidget {
  const DetailsOfTestView({super.key});

  @override
  State<DetailsOfTestView> createState() => _DetailsOfTestViewState();
}

class _DetailsOfTestViewState extends State<DetailsOfTestView>
    with WidgetsBindingObserver {
  bool _waitingPaymentReturn = false;
  int? _paymentTestId;
  bool _showPaymentResultAfterRefresh = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!_waitingPaymentReturn || _paymentTestId == null) return;
    if (!mounted) return;

    debugPrint("============ Payment Return Detected ============");
    debugPrint("→ refreshing overview for testId: $_paymentTestId");
    debugPrint("=================================================");

    _waitingPaymentReturn = false;
    _showPaymentResultAfterRefresh = true;

    showValidationTopSnackBar(
      context,
      title: "التحقق من الدفع",
      message: "جاري التحقق من حالة عملية الدفع...",
      type: AppValidationSnackBarType.hint,
    );

    context.read<DetailsOfTestCubit>().getOtherTestDetailsOverview(
      testId: _paymentTestId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<DetailsOfTestCubit, DetailsOfTestState>(
          listenWhen: (previous, current) =>
              previous.likeActionStatus != current.likeActionStatus ||
              previous.bookmarkActionStatus != current.bookmarkActionStatus ||
              previous.followActionStatus != current.followActionStatus ||
              previous.stripeCheckoutStatus != current.stripeCheckoutStatus ||
              previous.overviewStatus != current.overviewStatus ||
              previous.overviewDetails != current.overviewDetails,
          listener: (context, state) async {
            if (state.isLikeActionFailure) {
              showValidationTopSnackBar(
                context,
                title: state.errorTitle ?? "خطأ",
                message: state.errorMessage ?? "تعذر تنفيذ عملية الإعجاب",
                type: AppValidationSnackBarType.error,
              );

              context
                  .read<DetailsOfTestCubit>()
                  .resetLikeBookmarkFollowActionsState();
              return;
            }

            if (state.isBookmarkActionFailure) {
              showValidationTopSnackBar(
                context,
                title: state.errorTitle ?? "خطأ",
                message: state.errorMessage ?? "تعذر تنفيذ عملية الحفظ",
                type: AppValidationSnackBarType.error,
              );

              context
                  .read<DetailsOfTestCubit>()
                  .resetLikeBookmarkFollowActionsState();
              return;
            }

            if (state.isFollowActionFailure) {
              showValidationTopSnackBar(
                context,
                title: state.errorTitle ?? "خطأ",
                message: state.errorMessage ?? "تعذر تنفيذ عملية المتابعة",
                type: AppValidationSnackBarType.error,
              );

              context
                  .read<DetailsOfTestCubit>()
                  .resetLikeBookmarkFollowActionsState();
              return;
            }

            if (state.isStripeCheckoutSuccess) {
              final checkoutUrl = state.stripeCheckoutUrl;

              if (checkoutUrl == null || checkoutUrl.isEmpty) {
                showValidationTopSnackBar(
                  context,
                  title: "خطأ",
                  message: "تعذر فتح صفحة الدفع",
                  type: AppValidationSnackBarType.error,
                );

                context.read<DetailsOfTestCubit>().resetStripeCheckoutState();
                return;
              }

              _paymentTestId = state.overviewDetails?.data.id;

              final uri = Uri.parse(checkoutUrl);

              final opened = await launchUrl(
                uri,
                mode: LaunchMode.inAppBrowserView,
              );

              if (!opened) {
                showValidationTopSnackBar(
                  context,
                  title: "خطأ",
                  message: "تعذر فتح صفحة الدفع",
                  type: AppValidationSnackBarType.error,
                );
              }

              context.read<DetailsOfTestCubit>().resetStripeCheckoutState();

              if (opened) {
                _waitingPaymentReturn = true;

                showValidationTopSnackBar(
                  context,
                  title: "الدفع",
                  message: "تم فتح صفحة الدفع، أكمل العملية ثم عد إلى التطبيق",
                  type: AppValidationSnackBarType.hint,
                );
              }
            }

            if (state.isStripeCheckoutFailure) {
              showValidationTopSnackBar(
                context,
                title: state.errorTitle ?? "خطأ",
                message: state.errorMessage ?? "تعذر إنشاء جلسة الدفع",
                type: AppValidationSnackBarType.error,
              );

              context.read<DetailsOfTestCubit>().resetStripeCheckoutState();
            }

            if (_showPaymentResultAfterRefresh && state.isOverviewSuccess) {
              _showPaymentResultAfterRefresh = false;

              final hasPurchased =
                  state
                      .overviewDetails
                      ?.data
                      .extraInfo
                      .viewerContext
                      .hasPurchased ??
                  false;

              if (hasPurchased) {
                showValidationTopSnackBar(
                  context,
                  title: "تم الدفع بنجاح",
                  message: "تم تأكيد شراء الاختبار ويمكنك الآن الوصول للمحتوى",
                  type: AppValidationSnackBarType.success,
                );
              } else {
                showValidationTopSnackBar(
                  context,
                  title: "لم يتم تأكيد الدفع بعد",
                  message: "إذا أتممت الدفع انتظر قليلًا ثم حدّث الصفحة",
                  type: AppValidationSnackBarType.hint,
                );
              }

              _paymentTestId = null;
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
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

                          context
                              .read<DetailsOfTestCubit>()
                              .resetShareLinkState();
                          return;
                        }

                        await Share.share(
                          shareUrl,
                          subject: 'مشاركة اختبار من Nerd',
                        );

                        context
                            .read<DetailsOfTestCubit>()
                            .resetShareLinkState();
                      }

                      if (state.isShareLinkFailure) {
                        showValidationTopSnackBar(
                          context,
                          title: state.errorTitle ?? "خطأ",
                          message: state.errorMessage ?? "تعذر مشاركة الاختبار",
                          type: AppValidationSnackBarType.error,
                        );

                        context
                            .read<DetailsOfTestCubit>()
                            .resetShareLinkState();
                      }
                    },
                    builder: (context, state) {
                      final overview = state.overviewDetails;

                      return TopPageHeader(
                        title: 'تفاصيل اختبار',
                        onBack: () => safeBackToHome(context),
                        icon: Icons.ios_share,
                        onIconTap: state.isShareLinkLoading
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

                                context
                                    .read<DetailsOfTestCubit>()
                                    .getTestShareLink(testId: overview.data.id);
                              },
                      );
                    },
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
                              state.errorMessage ??
                                  'حدث خطأ أثناء جلب التفاصيل',
                              color: AppPalette.red,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final overview = state.overviewDetails;

                        if (overview == null) {
                          return const SizedBox.shrink();
                        }

                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.maxScrollExtent <= 0) {
                              return false;
                            }

                            final cubit = context.read<DetailsOfTestCubit>();
                            final currentState = cubit.state;

                            final isReviewsTab =
                                currentState.selectedTab ==
                                DetailsOfTestTab.reviews;

                            final reviewsDetails = currentState.reviewsDetails;

                            final hasMorePages =
                                reviewsDetails?.data.meta.hasMorePages ?? false;

                            final isAfterThreshold =
                                notification.metrics.pixels >=
                                notification.metrics.maxScrollExtent * 0.80;

                            if (isReviewsTab &&
                                isAfterThreshold &&
                                hasMorePages &&
                                !currentState.isReviewsLoadMoreLoading &&
                                !currentState.isFilteringReviewsLoading) {
                              debugPrint(
                                "============ Reviews Load More Trigger ============",
                              );
                              debugPrint(
                                "→ current page: ${reviewsDetails?.data.meta.currentPage}",
                              );
                              debugPrint("→ hasMorePages: $hasMorePages");
                              debugPrint(
                                "===================================================",
                              );

                              cubit.getOtherTestDetailsReviews(
                                testId: overview.data.id,
                                rating: currentState.selectedRatingFilter,
                                loadMore: true,
                              );
                            }

                            return false;
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: SizeConfig.h(0.015)),
                                TestDetailsWithPlayModesSection(
                                  title: overview.data.basicInfo.title,
                                  description:
                                      overview.data.basicInfo.description,
                                  difficultyLevel:
                                      overview.data.basicInfo.difficultyLevel,
                                  price: overview.data.basicInfo.price,
                                  likesCount:
                                      overview.data.basicInfo.likesCount,
                                  reviewsCount:
                                      overview.data.basicInfo.reviewsCount,
                                  bookmarksCount:
                                      overview.data.basicInfo.bookmarksCount,
                                  hasLiked: overview
                                      .data
                                      .extraInfo
                                      .viewerContext
                                      .hasLiked,
                                  hasBookmarked: overview
                                      .data
                                      .extraInfo
                                      .viewerContext
                                      .hasBookmarked,
                                  onLikeTap: () {
                                    debugPrint("toggle like");
                                    context
                                        .read<DetailsOfTestCubit>()
                                        .toggleTestLike(
                                          testId: overview.data.id,
                                        );
                                  },
                                  onLikeValueTap: () {
                                    debugPrint(
                                      "like value is ${overview.data.basicInfo.likesCount}",
                                    );
                                    showTestInteractionUsersBottomSheet(
                                      context: context,
                                      testId: overview.data.id,
                                      type: TestInteractionUsersType.likes,
                                      cubit: sl<TestInteractionUsersCubit>(),
                                      title: 'الإعجابات',
                                      searchHint: 'ابحث عن مستخدم',
                                    );
                                  },
                                  onBookmarkTap: () {
                                    debugPrint("toggle bookmark");
                                    context
                                        .read<DetailsOfTestCubit>()
                                        .toggleTestBookmark(
                                          testId: overview.data.id,
                                        );
                                  },
                                  onBookmarkValueTap: () {
                                    debugPrint(
                                      "bookmark value is ${overview.data.basicInfo.bookmarksCount}",
                                    );
                                    showTestInteractionUsersBottomSheet(
                                      context: context,
                                      testId: overview.data.id,
                                      type: TestInteractionUsersType.bookmarks,
                                      cubit: sl<TestInteractionUsersCubit>(),
                                      title: 'قام بحفظه',
                                      searchHint: 'ابحث عن مستخدم',
                                    );
                                  },
                                  onMcqModeTap: () {
                                    debugPrint("go to MCQ MODE");
                                    context.pushNamed(
                                      AppRouterName.mcqTestSessionView,
                                      extra: TestPlayModesRouteArgs(
                                        testId: overview.data.id,
                                      ),
                                    );
                                  },
                                  onChallengeModeTap: () {
                                    debugPrint("chaleng");
                                    context.pushNamed(
                                      AppRouterName.challengeSetupView,
                                      extra: TestPlayModesRouteArgs(
                                        testId: overview.data.id,
                                      ),
                                    );
                                  },
                                  onFlashCardModeTap: () {
                                    debugPrint("flash");

                                    context.pushNamed(
                                      AppRouterName.flashcardView,
                                      extra: TestPlayModesRouteArgs(
                                        testId: overview.data.id,
                                      ),
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
                          ),
                        );
                      },
                    ),
                  ),

                  BlocConsumer<DetailsOfTestCubit, DetailsOfTestState>(
                    listenWhen: (previous, current) =>
                        previous.downloadStatus != current.downloadStatus,
                    listener: (context, state) {
                      if (state.downloadStatus ==
                          DownloadTestFileStatus.loading) {
                        showValidationTopSnackBar(
                          context,
                          title: "تحميل",
                          message: "جاري تحميل ملف الاختبار...",
                          type: AppValidationSnackBarType.hint,
                        );
                      }

                      if (state.downloadStatus ==
                          DownloadTestFileStatus.success) {
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
                            debugPrint(
                              "→ open result message: ${result.message}",
                            );
                            debugPrint(
                              "=============================================",
                            );
                          },
                        );
                      }

                      if (state.downloadStatus ==
                          DownloadTestFileStatus.failure) {
                        showValidationTopSnackBar(
                          context,
                          title: state.errorTitle ?? "خطأ",
                          message:
                              state.errorMessage ?? "تعذر تحميل ملف الاختبار",
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
                        canReport:
                            overview.data.extraInfo.viewerContext.canReport,
                        onBuyTap: state.isStripeCheckoutLoading
                            ? () {}
                            : () {
                                debugPrint("buy now");

                                context
                                    .read<DetailsOfTestCubit>()
                                    .createStripeCheckoutSession(
                                      testId: overview.data.id,
                                    );
                              },
                        onDownloadTap: state.isDownloadLoading
                            ? () {}
                            : () {
                                debugPrint("download now");
                                context
                                    .read<DetailsOfTestCubit>()
                                    .downloadTestFile(testId: overview.data.id);
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
                                label:
                                    'يوجد خطأ في الاختيارات المطروحة في السؤال',
                              ),
                              ReportReasonUiModel(
                                label:
                                    'الإجابة الصحيحة لا يجب ان تكون هي الإجابة',
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
          ),
        ),
      ),
    );
  }
}
