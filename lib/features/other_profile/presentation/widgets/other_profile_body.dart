import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_overview_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/list_tab/other_profile_folders_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_header_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/overview_tab/other_profile_overview_tab.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/other_profile_tabs_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_tests_tab.dart';

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
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
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
          return const Center(child: CircularProgressIndicator());
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
                      //context.read<OtherProfileCubit>().toggleFollowLocally();
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
                  child: _OtherProfileSelectedTabContent(
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

class _OtherProfileSelectedTabContent extends StatelessWidget {
  final OtherProfileTab selectedTab;
  final OtherProfileOverviewDataEntity overviewDataEntity;
  final int userId;

  const _OtherProfileSelectedTabContent({
    required this.selectedTab,
    required this.overviewDataEntity,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case OtherProfileTab.overview:
        return OtherProfileOverviewTab(dataEntity: overviewDataEntity);

      case OtherProfileTab.tests:
        return _TestsTabBlocContent(userId: userId);

      case OtherProfileTab.folder:
        return _FoldersTabBlocContent(userId: userId);

      case OtherProfileTab.content:
        return _ContentTabBlocContent(userId: userId);
    }
  }
}

class _TestsTabBlocContent extends StatefulWidget {
  final int userId;

  const _TestsTabBlocContent({required this.userId});

  @override
  State<_TestsTabBlocContent> createState() => _TestsTabBlocContentState();
}

class _TestsTabBlocContentState extends State<_TestsTabBlocContent> {
  @override
  void initState() {
    super.initState();

    // جلب البيانات ذكياً عند بناء الـ Content لأول مرة فقط (Lazy Loading)
    final cubit = context.read<OtherProfileCubit>();
    if (cubit.state.isGetTestsInitial) {
      Future.microtask(() {
        cubit.getOtherProfileTests(userId: widget.userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.getTestsStatus != current.getTestsStatus ||
          previous.getMoreTestsStatus != current.getMoreTestsStatus ||
          previous.selectedTestsFilter != current.selectedTestsFilter ||
          previous.tests != current.tests ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        // 1. تمرير حالة التحميل (Loading) للتاب لعرض المؤشر أو الـ Shimmer الخاص به
        final bool isLoading = state.isGetTestsLoading;

        if (state.isGetTestsFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
              child: Column(
                children: [
                  CustomTextWidget(
                    state.errorMessage ?? 'حدث خطأ أثناء جلب قائمة الاختبارات',
                    color: AppPalette.red,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OtherProfileCubit>().getOtherProfileTests(
                        userId: widget.userId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        return OtherProfileTestsTab(
          selectedFilter: state.selectedTestsFilter,
          isLoading: state.isGetTestsLoading,
          isLoadingMore: state.isGetMoreTestsLoading,
          tests: state.tests,
          onFilterSelected: (filter) {
            context.read<OtherProfileCubit>().changeSelectedTestsFilter(
              filter,
              userId: widget.userId,
            );
          },
        );
      },
    );
  }
}

class _FoldersTabBlocContent extends StatefulWidget {
  final int userId;

  const _FoldersTabBlocContent({required this.userId});

  @override
  State<_FoldersTabBlocContent> createState() => _FoldersTabBlocContentState();
}

class _FoldersTabBlocContentState extends State<_FoldersTabBlocContent> {
  @override
  void initState() {
    super.initState();

    final cubit = context.read<OtherProfileCubit>();

    if (cubit.state.isGetFoldersInitial) {
      Future.microtask(() {
        cubit.getOtherProfileFolders(userId: widget.userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.getFoldersStatus != current.getFoldersStatus ||
          previous.getMoreFoldersStatus != current.getMoreFoldersStatus ||
          previous.foldersResponse != current.foldersResponse ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        final isLoading = state.isGetFoldersLoading;

        if (state.isGetFoldersFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
              child: Column(
                children: [
                  CustomTextWidget(
                    state.errorMessage ?? 'حدث خطأ أثناء جلب القوائم',
                    color: AppPalette.red,
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OtherProfileCubit>().getOtherProfileFolders(
                        userId: widget.userId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        return OtherProfileFoldersTab(
          folders: state.profileFolders,
          isLoading: state.isGetFoldersLoading,
          isLoadingMore: state.isGetMoreFoldersLoading,
          shimmerLoader: const Center(child: CircularProgressIndicator()),
          onSaveTap: (id) {
            // context.read<OtherProfileCubit>().toggleFolderSaveLocally(
            //   folderId: id,
            // );
          },
          onLoadMore: () {
            context.read<OtherProfileCubit>().loadMoreOtherProfileFolders(
              userId: widget.userId,
            );
          },
        );
      },
    );
  }
}

class _ContentTabBlocContent extends StatefulWidget {
  final int userId;

  const _ContentTabBlocContent({required this.userId});

  @override
  State<_ContentTabBlocContent> createState() => _ContentTabBlocContentState();
}

class _ContentTabBlocContentState extends State<_ContentTabBlocContent> {
  @override
  void initState() {
    super.initState();

    final cubit = context.read<OtherProfileCubit>();

    if (cubit.state.isGetContentInitial) {
      Future.microtask(() {
        cubit.getOtherProfileContent(userId: widget.userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherProfileCubit, OtherProfileState>(
      buildWhen: (previous, current) =>
          previous.getContentStatus != current.getContentStatus ||
          previous.getMoreContentStatus != current.getMoreContentStatus ||
          previous.selectedContentFilter != current.selectedContentFilter ||
          previous.contentResponse != current.contentResponse ||
          previous.errorMessage != current.errorMessage,
      builder: (context, state) {
        if (state.isGetContentFailure) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.04)),
              child: Column(
                children: [
                  CustomTextWidget(
                    state.errorMessage ?? 'حدث خطأ أثناء جلب المحتوى',
                    color: AppPalette.red,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.h(0.01)),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OtherProfileCubit>().getOtherProfileContent(
                        userId: widget.userId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        return OtherProfileContentTab(
          selectedFilter: state.selectedContentFilter,
          contents: state.profileContents,
          isLoading: state.isGetContentLoading,
          isLoadingMore: state.isGetMoreContentLoading,
          onFilterSelected: (filter) {
            context.read<OtherProfileCubit>().changeSelectedContentFilter(
              filter,
              userId: widget.userId,
            );
          },
          onSaveTap: (contentId) {},
          onLikeTap: (contentId) {},
        );
      },
    );
  }
}
