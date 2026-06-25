import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_connections_type.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_connections/other_profile_connections_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_body_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_connections_bottom_sheet.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_header_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_selected_tab_content.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_tabs_section.dart';

class OtherProfileBody extends StatefulWidget {
  final int userId;

  const OtherProfileBody({super.key, required this.userId});

  @override
  State<OtherProfileBody> createState() => _OtherProfileBodyState();
}

class _OtherProfileBodyState extends State<OtherProfileBody> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OtherProfileCubit>().getOtherProfileOverview(
        userId: widget.userId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtherProfileCubit, OtherProfileState>(
      listenWhen: (previous, current) =>
          previous.followActionStatus != current.followActionStatus ||
          previous.folderBookmarkActionStatus !=
              current.folderBookmarkActionStatus ||
          previous.contentBookmarkActionStatus !=
              current.contentBookmarkActionStatus,
      listener: (context, state) {
        if (state.isFollowActionFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر تنفيذ عملية المتابعة",
            type: AppValidationSnackBarType.error,
          );

          context.read<OtherProfileCubit>().resetFollowActionState();
        }

        if (state.isFolderBookmarkFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر تنفيذ عملية حفظ القائمة",
            type: AppValidationSnackBarType.error,
          );

          context.read<OtherProfileCubit>().resetFolderBookmarkActionState();
        }

        if (state.isContentBookmarkFailure) {
          showValidationTopSnackBar(
            context,
            title: state.errorTitle ?? "خطأ",
            message: state.errorMessage ?? "تعذر تنفيذ عملية حفظ المحتوى",
            type: AppValidationSnackBarType.error,
          );

          context.read<OtherProfileCubit>().resetContentBookmarkActionState();
        }
      },

      buildWhen: (previous, current) =>
          previous.selectedTab != current.selectedTab ||
          previous.overview != current.overview ||
          previous.errorMessage != current.errorMessage ||
          previous.fetchOverviewStatus != current.fetchOverviewStatus ||
          previous.testsMeta != current.testsMeta ||
          previous.getMoreTestsStatus != current.getMoreTestsStatus ||
          previous.getTestsStatus != current.getTestsStatus ||
          previous.foldersResponse != current.foldersResponse ||
          previous.getFoldersStatus != current.getFoldersStatus ||
          previous.getMoreFoldersStatus != current.getMoreFoldersStatus ||
          previous.contentResponse != current.contentResponse ||
          previous.getContentStatus != current.getContentStatus ||
          previous.getMoreContentStatus != current.getMoreContentStatus,

      builder: (context, state) {
        if (state.isFetchOverviewLoading) {
          return const OtherProfileBodyShimmer();
        }

        // 2. حالة الفشل (Failure)
        if (state.isFetchOverviewFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.w(0.05)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: SizeConfig.w(0.12),
                  ),
                  SizedBox(height: SizeConfig.h(0.02)),
                  CustomTextWidget(
                    state.errorTitle ?? 'حدث خطأ غير متوقع',
                    fontFamily: AppFont.elMessiriBold,
                    fontSize: SizeConfig.text(0.045),
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),
                  CustomTextWidget(
                    state.errorMessage ??
                        'يرجى التحقق من الاتصال والمحاولة مرة أخرى',
                    color: Colors.grey,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final overviewEntity = state.overview;
        if (overviewEntity == null) {
          return const SizedBox.shrink();
        }

        final data = overviewEntity.data;

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;

            if (metrics.maxScrollExtent <= 0) {
              return false;
            }

            final scrollRatio = metrics.pixels / metrics.maxScrollExtent;

            if (scrollRatio < 0.8) {
              return false;
            }

            final cubit = context.read<OtherProfileCubit>();

            if (state.selectedTab == OtherProfileTab.tests &&
                state.hasMoreTestsPages &&
                !state.isGetMoreTestsLoading &&
                !state.isGetTestsLoading) {
              cubit.loadMoreOtherProfileTests(userId: widget.userId);
            }

            if (state.selectedTab == OtherProfileTab.folder &&
                state.hasMoreFoldersPages &&
                !state.isGetMoreFoldersLoading &&
                !state.isGetFoldersLoading) {
              cubit.loadMoreOtherProfileFolders(userId: widget.userId);
            }

            if (state.selectedTab == OtherProfileTab.content &&
                state.hasMoreContentPages &&
                !state.isGetMoreContentLoading &&
                !state.isGetContentLoading) {
              cubit.loadMoreOtherProfileContent(userId: widget.userId);
            }

            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.h(0.012)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                  child: OtherProfileHeaderCard(
                    profile: data.header,
                    onFollowTap: () {
                      context
                          .read<OtherProfileCubit>()
                          .toggleOtherProfileFollow();
                    },

                    onFollowersTap: () {
                      showOtherProfileConnectionsBottomSheet(
                        context: context,
                        userId: widget.userId,
                        type: OtherProfileConnectionsType.followers,
                        cubit: sl<OtherProfileConnectionsCubit>(),
                        title: 'المتابعون',
                        searchHint: 'ابحث عن متابع',
                      );
                    },

                    onFollowingTap: () {
                      showOtherProfileConnectionsBottomSheet(
                        context: context,
                        userId: widget.userId,
                        type: OtherProfileConnectionsType.following,
                        cubit: sl<OtherProfileConnectionsCubit>(),
                        title: 'يتابع',
                        searchHint: 'ابحث عن مستخدم',
                      );
                    },
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                OtherProfileTabsSection(
                  selectedTab: state.selectedTab,
                  onTabSelected: (tab) {
                    context.read<OtherProfileCubit>().changeSelectedTab(tab);
                  },
                ),

                SizedBox(height: SizeConfig.h(0.018)),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
                  child: OtherProfileSelectedTabContent(
                    selectedTab: state.selectedTab,
                    //profile: profile,
                    overviewDataEntity: data,
                    userId: widget.userId,
                  ),
                ),

                SizedBox(height: SizeConfig.h(0.03)),
              ],
            ),
          ),
        );
      },
    );
  }
}
