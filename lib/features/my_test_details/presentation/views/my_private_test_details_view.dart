import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/core/utils/safe_back_to_home.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_details_playmode_section_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_overview_tab_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_info_details_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';

class MyPrivateTestDetailsView extends StatefulWidget {
  final int testId;

  const MyPrivateTestDetailsView({super.key, required this.testId});

  @override
  State<MyPrivateTestDetailsView> createState() =>
      _MyPrivateTestDetailsViewState();
}

class _MyPrivateTestDetailsViewState extends State<MyPrivateTestDetailsView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MyTestDetailsCubit>().getMyPrivateTestOverview(
        testId: widget.testId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocListener<MyTestDetailsCubit, MyTestDetailsState>(
      listenWhen: (previous, current) =>
          previous.downloadStatus != current.downloadStatus,
      listener: (context, state) async {
        if (state.isDownloadLoading) {
          showValidationTopSnackBar(
            context,
            title: 'تحميل',
            message: 'جاري تحميل ملف الاختبار...',
            type: AppValidationSnackBarType.hint,
          );
        }

        if (state.isDownloadSuccess) {
          showValidationTopSnackBar(
            context,
            title: 'تم التحميل',
            message: 'تم حفظ ملف الاختبار بنجاح',
            type: AppValidationSnackBarType.success,
            actionText: 'عرض الاختبار',
            onActionTap: () async {
              final filePath = state.downloadedFilePath;

              if (filePath == null || filePath.isEmpty) {
                showValidationTopSnackBar(
                  context,
                  title: 'خطأ',
                  message: 'تعذر العثور على ملف الاختبار',
                  type: AppValidationSnackBarType.error,
                );
                return;
              }

              debugPrint(
                "============ Open My Private Downloaded PDF ============",
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
            title: state.errorTitle ?? 'خطأ',
            message: state.errorMessage ?? 'تعذر تحميل ملف الاختبار',
            type: AppValidationSnackBarType.error,
          );

          context.read<MyTestDetailsCubit>().resetDownloadState();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
                buildWhen: (previous, current) =>
                    previous.overviewPrivateDetails !=
                        current.overviewPrivateDetails ||
                    previous.overviewPrivateStatus !=
                        current.overviewPrivateStatus,
                builder: (context, state) {
                  final title =
                      state.overviewPrivateDetails?.data.basicInfo.title ??
                      'تفاصيل اختباري';

                  return TopPageHeader(
                    title: title,
                    onBack: () => safeBackToHome(context),
                    icon: Icons.info_outline_rounded,
                    onIconTap: () {
                      showValidationTopSnackBar(
                        context,
                        title: 'تفاصيل الاختبار الخاص',
                        message:
                            'هذه الصفحة تعرض تفاصيل اختبارك الخاص غير المنشور للعامة',
                        type: AppValidationSnackBarType.hint,
                      );
                    },
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.015)),

              Expanded(
                child: BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
                  buildWhen: (previous, current) =>
                      previous.overviewPrivateStatus !=
                          current.overviewPrivateStatus ||
                      previous.overviewPrivateDetails !=
                          current.overviewPrivateDetails ||
                      previous.errorMessage != current.errorMessage,
                  builder: (context, state) {
                    if (state.isOverviewPrivateLoading) {
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

                    if (state.isOverviewPrivateFailure) {
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

                    final overview = state.overviewPrivateDetails;

                    if (overview == null) {
                      return const SizedBox.shrink();
                    }

                    final data = overview.data;
                    final basicInfo = data.basicInfo;
                    final extraInfo = data.extraInfo;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.h(0.015)),

                          TestDetailsWithPlayModesSection(
                            title: basicInfo.title,
                            description: basicInfo.description,
                            difficultyLevel: basicInfo.difficultyLevel,

                            // الـ private response لا يحتوي هذه القيم.
                            price: 0,
                            likesCount: 0,
                            reviewsCount: 0,
                            bookmarksCount: 0,
                            hasLiked: false,
                            hasBookmarked: false,

                            onLikeTap: () {
                              showValidationTopSnackBar(
                                context,
                                title: 'تنبيه',
                                message:
                                    'لا يمكن تسجيل إعجاب على اختبار خاص تملكه',
                                type: AppValidationSnackBarType.hint,
                              );
                            },
                            onBookmarkTap: () {
                              showValidationTopSnackBar(
                                context,
                                title: 'تنبيه',
                                message: 'لا يمكن حفظ اختبار خاص تملكه',
                                type: AppValidationSnackBarType.hint,
                              );
                            },
                            onMcqModeTap: () {
                              debugPrint(
                                'go to MCQ MODE from MyPrivateTestDetails',
                              );
                            },
                            onChallengeModeTap: () {
                              debugPrint(
                                'go to Challenge MODE from MyPrivateTestDetails',
                              );
                            },
                            onFlashCardModeTap: () {
                              debugPrint(
                                'go to Flashcard MODE from MyPrivateTestDetails',
                              );
                            },
                          ),

                          SizedBox(height: SizeConfig.h(0.03)),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.03),
                            ),
                            child: TestInfoDetailsSection(
                              questionCount: extraInfo.questionCount,
                              durationSeconds: extraInfo.durationSeconds,
                              passMarkPercentage: extraInfo.passMarkPercentage,
                              publishedAt: extraInfo.publishedAt,
                              lastContentUpdatedAt:
                                  extraInfo.lastContentUpdatedAt,
                              targetLevel: extraInfo.targetLevel,
                              language: extraInfo.language,

                              // private response لا يحتوي participants_count
                              participantsCount: 0,

                              interests: extraInfo.interests
                                  .map((item) => item.name)
                                  .toList(),
                            ),
                          ),

                          SizedBox(height: SizeConfig.h(0.03)),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const _MyPrivateTestDetailsBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPrivateTestDetailsBottomBar extends StatelessWidget {
  const _MyPrivateTestDetailsBottomBar();

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<MyTestDetailsCubit, MyTestDetailsState>(
      buildWhen: (previous, current) =>
          previous.overviewPrivateDetails != current.overviewPrivateDetails ||
          previous.overviewPrivateStatus != current.overviewPrivateStatus ||
          previous.downloadStatus != current.downloadStatus,
      builder: (context, state) {
        final overview = state.overviewPrivateDetails;

        if (overview == null || state.isOverviewPrivateLoading) {
          return const SizedBox.shrink();
        }

        final viewerContext = overview.data.viewerContext;

        if (!viewerContext.canDownload) {
          return const SizedBox.shrink();
        }

        final isDownloadLoading = state.isDownloadLoading;

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
          child: CustomButtonWidget(
            width: double.infinity,
            backgroundColor: appColors.primaryToPrimaryDark,
            childHorizontalPad: SizeConfig.w(0.04),
            childVerticalPad: SizeConfig.w(0.013),
            borderRadius: 6,
            onTap: isDownloadLoading
                ? () {}
                : () {
                    debugPrint(
                      'download my private test => ${overview.data.id}',
                    );

                    context.read<MyTestDetailsCubit>().downloadMyPublicTestFile(
                      testId: overview.data.id,
                    );
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget(
                  isDownloadLoading ? 'جاري التحميل...' : 'تحميل الاختبار',
                  fontSize: SizeConfig.text(0.03),
                  color: AppPalette.white,
                ),
                SizedBox(width: SizeConfig.w(0.012)),
                Icon(
                  Icons.download,
                  size: SizeConfig.h(0.022),
                  color: AppPalette.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
