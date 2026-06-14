import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_confirmation_dialog.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_details_playmode_section_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_overview_tab_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/views/my_private_test_details_view.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/widgets/my_test_details_tabs_section.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/models/test_play_modes_route_args.dart';
import 'package:share_plus/share_plus.dart';

class MyTestDetailsView extends StatefulWidget {
  final int testId;

  const MyTestDetailsView({super.key, required this.testId});

  @override
  State<MyTestDetailsView> createState() => _MyTestDetailsViewState();
}

class _MyTestDetailsViewState extends State<MyTestDetailsView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyTestDetailsCubit>().getMyPublicTestDetailsOverview(
        testId: widget.testId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocListener<MyTestDetailsCubit, MyTestDetailsState>(
      listenWhen: (previous, current) =>
          previous.downloadStatus != current.downloadStatus ||
          previous.shareLinkStatus != current.shareLinkStatus ||
          previous.deleteMyTestStatus != current.deleteMyTestStatus,
      listener: (context, state) async {
        if (state.isDownloadLoading) {
          showValidationTopSnackBar(
            context,
            title: "تحميل",
            message: "جاري تحميل ملف الاختبار...",
            type: AppValidationSnackBarType.hint,
          );
        }

        if (state.isDownloadSuccess) {
          showValidationTopSnackBar(
            context,
            title: "تم التحميل",
            message: "تم حفظ ملف الاختبار بنجاح",
            type: AppValidationSnackBarType.success,
            actionText: 'عرض الاختبار',
            onActionTap: () async {
              final filePath = state.downloadedFilePath;

              if (filePath == null || filePath.isEmpty) {
                showValidationTopSnackBar(
                  context,
                  title: "خطأ",
                  message: "تعذر العثور على ملف الاختبار",
                  type: AppValidationSnackBarType.error,
                );
                return;
              }

              debugPrint(
                "============ Open My Public Downloaded PDF ============",
              );
              debugPrint("→ filePath: $filePath");

              final result = await OpenFilex.open(filePath);

              debugPrint("→ open result type: ${result.type}");
              debugPrint("→ open result message: ${result.message}");
              debugPrint(
                "=======================================================",
              );
            },
          );

          context.read<MyTestDetailsCubit>().resetDownloadState();
        }

        if (state.isDownloadFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر تحميل ملف الاختبار",
            type: AppValidationSnackBarType.error,
          );

          context.read<MyTestDetailsCubit>().resetDownloadState();
        }

        if (state.isShareLinkSuccess) {
          final shareUrl = state.shareUrl;

          if (shareUrl == null || shareUrl.isEmpty) {
            showValidationTopSnackBar(
              context,
              title: "خطأ",
              message: "تعذر تجهيز رابط المشاركة",
              type: AppValidationSnackBarType.error,
            );

            context.read<MyTestDetailsCubit>().resetShareLinkState();
            return;
          }

          await Share.share(shareUrl, subject: 'مشاركة اختبار من Nerd');

          context.read<MyTestDetailsCubit>().resetShareLinkState();
        }

        if (state.isShareLinkFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر مشاركة الاختبار",
            type: AppValidationSnackBarType.error,
          );

          context.read<MyTestDetailsCubit>().resetShareLinkState();
        }

        if (state.isDeleteMyTestLoading) {
          showValidationTopSnackBar(
            context,
            title: 'حذف الاختبار',
            message: 'جاري حذف الاختبار...',
            type: AppValidationSnackBarType.hint,
          );
        }

        if (state.isDeleteMyTestSuccess) {
          final deleteResponse = state.deleteMyTestDetails;

          showValidationTopSnackBar(
            context,
            title: deleteResponse?.title ?? 'تم الحذف',
            message: deleteResponse?.message ?? 'تم حذف الاختبار بنجاح',
            type: AppValidationSnackBarType.success,
          );

          context.read<MyTestDetailsCubit>().resetDeleteMyTestState();

          safeBackToHome(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
                buildWhen: (previous, current) =>
                    previous.overviewDetails != current.overviewDetails ||
                    previous.overviewStatus != current.overviewStatus,
                builder: (context, state) {
                  return TopPageHeader(
                    title: 'تفاصيل اختباري',
                    onBack: () => safeBackToHome(context),
                    icon: Icons.more_vert_rounded,
                    onIconTap: () {
                      debugPrint(
                        "============ MyPrivateTest More Menu Tap ============",
                      );

                      showMyPrivateTestMoreMenu(
                        context: context,
                        // onEdit: () {
                        //   debugPrint("→ edit my private test");
                        //   // TODO: go to edit test page
                        // },
                        onEdit: () {
                          final overview = context
                              .read<MyTestDetailsCubit>()
                              .state
                              .overviewDetails;
                          if (overview == null) return;

                          final data = overview.data;
                          final basic = data.basicInfo;
                          final extra = data.extraInfo;

                          context.pushNamed(
                            AppRouterName.createTestPage,
                            extra: CreateTestInitialArgs(
                              isEditMode: true,
                              editingTestId: data.id,
                              initialTitle: basic.title,
                              initialDescription: basic.description,
                              initialIsPublished: true,
                              initialPrice: basic.price == 0
                                  ? ''
                                  : basic.price.toString(),
                              initialLevel: basic.difficultyLevel,
                              initialDurationSeconds: extra.durationSeconds,
                              initialSuccessLimit: extra.passMarkPercentage,
                              initialLanguage: _mapBackendLanguageToUi(
                                extra.language,
                              ),
                              initialAcademicLevel: extra.targetLevel,
                              initialScientificInterestIds: extra.interests
                                  .map((e) => e.id)
                                  .toList(),
                              initialScientificCategories: extra.interests
                                  .map((e) => e.name)
                                  .toList(),

                              // الأسئلة الكاملة رح نجيبها لاحقاً من API ثاني
                              initialQuestions: const [],

                              // حالياً overview عنده previewQuestions فقط، بس لاحقاً من API الأسئلة بنثبت IDs الصح
                              
                              initialPreviewQuestionIds: extra.previewQuestions
                                  .map((q) => q.id)
                                  .toList(),
                              shouldFetchEditQuestions: true,
                            ),
                          );
                        },
                        onDelete: () {
                          debugPrint("→ delete my private test");
                          showCustomConfirmationDialog(
                            context: context,
                            title: 'هل تريد حذف هذا الاختبار حقاً ؟',
                            message:
                                'لن تعد قادر الى العودة لهذا الاختبار او التفاعل معه مجددا بعد اتمام عملية الحذف',
                            icon: Icons.delete_forever_outlined,
                            confirmText: 'حذف',
                            cancelText: 'إلغاء',
                            iconColor: AppPalette.red,
                            iconBackgroundColor: AppPalette.red.withOpacity(
                              0.09,
                            ),
                            confirmBackgroundColor: AppPalette.red,
                            onConfirm: () {
                              context.read<MyTestDetailsCubit>().deleteMyTest(
                                testId: widget.testId,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.015)),

              Expanded(
                child: BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
                  buildWhen: (previous, current) =>
                      previous.overviewStatus != current.overviewStatus ||
                      previous.overviewDetails != current.overviewDetails ||
                      previous.errorMessage != current.errorMessage,
                  builder: (context, state) {
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.w(0.06),
                          ),
                          child: CustomTextWidget(
                            state.errorMessage ??
                                'حدث خطأ أثناء جلب تفاصيل الاختبار',
                            color: AppPalette.red,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final overview = state.overviewDetails;

                    if (overview == null) {
                      return const SizedBox.shrink();
                    }

                    final data = overview.data;

                    return NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification.metrics.maxScrollExtent <= 0) {
                          return false;
                        }

                        final cubit = context.read<MyTestDetailsCubit>();
                        final currentState = cubit.state;

                        final isReviewsTab =
                            currentState.selectedTab ==
                            MyTestDetailsTab.reviews;

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
                            "============ My Public Reviews Load More Trigger ============",
                          );
                          debugPrint(
                            "→ current page: ${reviewsDetails?.data.meta.currentPage}",
                          );
                          debugPrint("→ hasMorePages: $hasMorePages");
                          debugPrint(
                            "===================================================",
                          );

                          cubit.getMyPublicTestReviews(
                            testId: data.id,
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
                              title: data.basicInfo.title,
                              description: data.basicInfo.description,
                              difficultyLevel: data.basicInfo.difficultyLevel,
                              price: data.basicInfo.price,
                              likesCount: data.basicInfo.likesCount,
                              reviewsCount: data.basicInfo.reviewsCount,
                              bookmarksCount: data.basicInfo.bookmarksCount,
                              hasLiked: false,
                              hasBookmarked: false,
                              onLikeTap: null,
                              onBookmarkTap: null,
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

                            SizedBox(height: SizeConfig.h(0.03)),

                            MyTestDetailsTabsSection(
                              testId: data.id,
                              overview: overview,
                            ),

                            SizedBox(height: SizeConfig.h(0.02)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const _MyTestDetailsBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyTestDetailsBottomBar extends StatelessWidget {
  const _MyTestDetailsBottomBar();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
      buildWhen: (previous, current) =>
          previous.overviewDetails != current.overviewDetails ||
          previous.overviewStatus != current.overviewStatus ||
          previous.downloadStatus != current.downloadStatus ||
          previous.shareLinkStatus != current.shareLinkStatus,
      builder: (context, state) {
        final overview = state.overviewDetails;

        if (overview == null || state.isOverviewLoading) {
          return const SizedBox.shrink();
        }

        final viewerContext = overview.data.viewerContext;

        final isDownloadLoading = state.isDownloadLoading;
        final isShareLinkLoading = state.isShareLinkLoading;

        return CustomBackgroundWithChild(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.03),
            vertical: SizeConfig.h(0.017),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppPalette.greyMediumDark
                  : AppPalette.greyBorderCart,
              blurRadius: 4,
              offset: const Offset(0, -4),
            ),
          ],
          backgroundColor: appColors.whiteToblack,
          child: Row(
            children: [
              if (viewerContext.canDownload)
                CustomButtonWidget(
                  backgroundColor: appColors.primaryToPrimaryDark,
                  childHorizontalPad: SizeConfig.w(0.04),
                  childVerticalPad: SizeConfig.w(0.013),
                  borderRadius: 20,
                  onTap: isDownloadLoading
                      ? () {}
                      : () {
                          debugPrint(
                            'download my public test => ${overview.data.id}',
                          );

                          context
                              .read<MyTestDetailsCubit>()
                              .downloadMyPublicTestFile(
                                testId: overview.data.id,
                              );
                        },
                  child: Row(
                    children: [
                      CustomTextWidget(
                        isDownloadLoading
                            ? 'جاري التحميل...'
                            : 'تحميل الاختبار',
                        fontSize: SizeConfig.text(0.025),
                        color: AppPalette.white,
                      ),
                      SizedBox(width: SizeConfig.w(0.012)),
                      Icon(
                        Icons.download,
                        size: SizeConfig.h(0.02),
                        color: AppPalette.white,
                      ),
                    ],
                  ),
                ),

              if (viewerContext.canDownload && viewerContext.canShare)
                SizedBox(width: SizeConfig.w(0.02)),

              if (viewerContext.canShare)
                CustomButtonWidget(
                  backgroundColor: appColors.greyToGreyMediumDark,
                  childHorizontalPad: SizeConfig.w(0.04),
                  childVerticalPad: SizeConfig.w(0.013),
                  borderRadius: 20,
                  onTap: isShareLinkLoading
                      ? () {}
                      : () {
                          debugPrint(
                            'share my public test => ${overview.data.id}',
                          );

                          context
                              .read<MyTestDetailsCubit>()
                              .getMyPublicTestShareLink(
                                testId: overview.data.id,
                              );
                        },
                  child: Row(
                    children: [
                      CustomTextWidget(
                        isShareLinkLoading
                            ? 'جاري التجهيز...'
                            : 'مشاركة الاختبار',
                        fontSize: SizeConfig.text(0.025),
                        color: AppPalette.greyMedium,
                      ),
                      SizedBox(width: SizeConfig.w(0.012)),
                      Icon(
                        Icons.share,
                        size: SizeConfig.h(0.02),
                        color: AppPalette.greyMedium,
                      ),
                    ],
                  ),
                ),

              if (!viewerContext.canDownload && !viewerContext.canShare)
                Expanded(
                  child: CustomTextWidget(
                    'لا توجد إجراءات متاحة لهذا الاختبار حاليًا',
                    color: AppPalette.greyMedium,
                    textAlign: TextAlign.center,
                    fontSize: SizeConfig.text(0.03),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

//////////////// carmen editing
String _mapBackendLanguageToUi(String value) {
  switch (value.trim()) {
    case 'العربية':
      return 'عربية';
    case 'الإنكليزية':
      return 'إنكليزية';
    case 'مختلطة':
      return 'مختلطة';
    default:
      return value.trim().isEmpty ? 'عربية' : value.trim();
  }
}
