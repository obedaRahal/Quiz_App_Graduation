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
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart'
    show CreateTestInitialArgs;
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_details_playmode_section_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/shimmers/test_overview_tab_shimmer.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/overview_tab/test_info_details_section.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_with_play_modes_session.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_state.dart';
import 'package:quiz_app_grad/features/test_play_modes/data/models/test_play_modes_route_args.dart';

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
          previous.downloadStatus != current.downloadStatus ||
          previous.deleteMyTestStatus != current.deleteMyTestStatus,
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
                    previous.overviewPrivateDetails !=
                        current.overviewPrivateDetails ||
                    previous.overviewPrivateStatus !=
                        current.overviewPrivateStatus,
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
                              .overviewPrivateDetails;
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
                              initialIsPublished: false,
                              initialPrice: '',
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

                              initialPreviewQuestionIds: const [],
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

enum MyPrivateTestAction { edit, delete }

Future<void> showMyPrivateTestMoreMenu({
  required BuildContext context,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) async {
  final appColors = context.appColors;
  //final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

  final selectedAction = await showMenu<MyPrivateTestAction>(
    context: context,
    color: appColors.whiteToblack,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: AppPalette.black, width: 1),
    ),

    position: RelativeRect.fromLTRB(
      SizeConfig.w(0.9),
      SizeConfig.h(0.05),
      SizeConfig.w(0.06),
      0,
    ),
    items: [
      PopupMenuItem<MyPrivateTestAction>(
        value: MyPrivateTestAction.edit,
        height: SizeConfig.h(0.036),
        padding: EdgeInsets.zero,
        child: _MyPrivateTestMenuItem(
          title: 'تعديل الاختبار',
          color: AppPalette.greyMedium,
        ),
      ),

      PopupMenuItem<MyPrivateTestAction>(
        enabled: false,
        height: 2,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.009)),
        child: Container(height: 2, color: AppPalette.greyBorderCart),
      ),

      PopupMenuItem<MyPrivateTestAction>(
        value: MyPrivateTestAction.delete,
        height: SizeConfig.h(0.036),
        padding: EdgeInsets.zero,
        child: _MyPrivateTestMenuItem(
          title: 'حذف الاختبار',
          color: AppPalette.greyMedium,
        ),
      ),
    ],
  );

  if (selectedAction == null) {
    debugPrint("→ my private test menu dismissed");
    return;
  }

  switch (selectedAction) {
    case MyPrivateTestAction.edit:
      onEdit();
      break;

    case MyPrivateTestAction.delete:
      onDelete();
      break;
  }
}

class _MyPrivateTestMenuItem extends StatelessWidget {
  final String title;
  final Color color;

  const _MyPrivateTestMenuItem({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.w(0.3),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.025),
          vertical: SizeConfig.h(0.004),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: CustomTextWidget(
            title,
            color: color,
            fontSize: SizeConfig.text(0.03),
            textAlign: TextAlign.right,
          ),
        ),
      ),
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
