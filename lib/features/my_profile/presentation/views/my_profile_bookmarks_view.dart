import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/mappers/my_profile_bookmark_item_mapper.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/bookmarks/my_profile_bookmarks_filter_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/my_profile_folder_card_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_content_card_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/shimmer/other_profile_tests_tab_shimmer.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_cubit.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/folder_tab/other_profile_folder_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/folder_tab/other_profile_folder_details_bottom_sheet.dart';

class MyProfileBookmarksView extends StatelessWidget {
  const MyProfileBookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MyProfileBookmarksCubit>()..fetchInitial(),
        ),
        BlocProvider(create: (_) => sl<OtherProfileCubit>()),
      ],
      child: const _MyProfileBookmarksBody(),
    );
  }
}

class _MyProfileBookmarksBody extends StatefulWidget {
  const _MyProfileBookmarksBody();

  @override
  State<_MyProfileBookmarksBody> createState() =>
      _MyProfileBookmarksBodyState();
}

class _MyProfileBookmarksBodyState extends State<_MyProfileBookmarksBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final position = _scrollController.position;

      if (position.pixels >= position.maxScrollExtent * 0.8) {
        context.read<MyProfileBookmarksCubit>().fetchMoreIfNeeded();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyProfileBookmarksCubit, MyProfileBookmarksState>(
      listenWhen: (previous, current) =>
          previous.actionError != current.actionError &&
          current.actionError != null,
      listener: (context, state) {
        final error = state.actionError;
        if (error == null) return;

        showValidationTopSnackBar(
          context,
          title: error.title,
          message: error.message,
          type: AppValidationSnackBarType.error,
        );
        context.read<MyProfileBookmarksCubit>().clearActionError();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.w(0.03),
                  right: SizeConfig.w(0.03),
                  top: SizeConfig.h(0.03),
                  bottom: SizeConfig.h(0.01),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HeaderActionButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    CustomTextWidget(
                      'قائمة المحفوظات',
                      color: context.appColors.blackTogreyMedium,
                      fontFamily: AppFont.elMessiriBold,
                    ),
                  ],
                ),
              ),

              BlocBuilder<MyProfileBookmarksCubit, MyProfileBookmarksState>(
                buildWhen: (p, c) => p.selectedTab != c.selectedTab,
                builder: (context, state) {
                  return MyProfileBookmarksFilterSection(
                    selectedTab: state.selectedTab,
                    onTabSelected: (tab) {
                      context.read<MyProfileBookmarksCubit>().changeTab(tab);
                    },
                  );
                },
              ),

              SizedBox(height: SizeConfig.h(0.02)),

              Expanded(
                child:
                    BlocBuilder<
                      MyProfileBookmarksCubit,
                      MyProfileBookmarksState
                    >(
                      builder: (context, state) {
                        if (state.isLoading) {
                          if (state.selectedTab ==
                              MyProfileBookmarksTab.folders) {
                            return MyProfileFoldersShimmerList(
                              horizonalPadding: SizeConfig.w(0.03),
                              itemCount: 8,
                            );
                          } else if (state.selectedTab ==
                              MyProfileBookmarksTab.materials) {
                            return ContentCardsShimmerList(
                              itemCount: 8,
                              horizonalPadding: SizeConfig.w(0.03),
                            );
                          } else if (state.selectedTab ==
                              MyProfileBookmarksTab.tests) {
                            return OtherProfileTestsTabShimmer(
                              count: 5,
                              horizonalPadding: SizeConfig.w(0.03),
                            );
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.hasFetchError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(SizeConfig.w(0.05)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextWidget(
                                    state.fetchError?.message ??
                                        'تعذر جلب المحفوظات',
                                    color: AppPalette.greyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: SizeConfig.h(0.014)),
                                  ElevatedButton(
                                    onPressed: context
                                        .read<MyProfileBookmarksCubit>()
                                        .fetchInitial,
                                    child: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state.items.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: EmptyActionBox(
                                icon: Icons.bookmark_border_rounded,
                                title: 'لا توجد عناصر محفوظة',
                                description:
                                    'ستظهر هنا الاختبارات والمحتويات والمجلدات التي تحفظها',
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () {
                            return context
                                .read<MyProfileBookmarksCubit>()
                                .refresh();
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.w(0.03),
                              vertical: SizeConfig.h(0.01),
                            ),
                            itemCount:
                                state.items.length +
                                (state.isLoadingMore ||
                                        state.loadMoreError != null
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.items.length) {
                                if (state.loadMoreError != null) {
                                  return _LoadMoreError(
                                    message: state.loadMoreError!.message,
                                    onRetry: context
                                        .read<MyProfileBookmarksCubit>()
                                        .fetchMoreIfNeeded,
                                  );
                                }

                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.h(0.018),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final item = state.items[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: SizeConfig.h(0.014),
                                ),
                                child: _BookmarkItemBuilder(item: item),
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

class _BookmarkItemBuilder extends StatelessWidget {
  final MyProfileBookmarkItemEntity item;

  const _BookmarkItemBuilder({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item is MyProfileBookmarkTestEntity) {
      final test = item as MyProfileBookmarkTestEntity;

      return OtherProfileTestCard(
        item: test.toOtherProfileTestItemEntity(),
        showSaveButton: true,
        isSaved: true,
        onTestTap: () {
          context.pushNamed(
            AppRouterName.detailsOfTest,
            extra: DetailsOfTestRouteArgs(testId: test.id),
          );
        },
        onSaveTap: () {
          context.read<MyProfileBookmarksCubit>().removeTestBookmark(
            testId: test.id,
          );
        },
      );
    }

    if (item is MyProfileBookmarkMaterialEntity) {
      final material = item as MyProfileBookmarkMaterialEntity;

      return OtherProfileContentCard(
        content: material.toOtherProfileContentEntity(),
        onContentTap: () {
          context.pushNamed(
            AppRouterName.otherContentDetails,
            extra: ContentDetailsRouteArgs(
              contentId: material.id,
              isMyContent: false,
            ),
          );
        },
        onSaveTap: () {
          context.read<MyProfileBookmarksCubit>().removeMaterialBookmark(
            contentId: material.id,
          );
        },
        onLikeTap: () {},
        showLikeButton: false,
      );
    }

    if (item is MyProfileBookmarkFolderEntity) {
      final folder = item as MyProfileBookmarkFolderEntity;

      return InkWell(
        onTap: () {
          showOtherProfileFolderDetailsBottomSheet(
            context: context,
            folderId: folder.id,
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: OtherProfileFolderCard(
          folder: folder.toOtherProfileFolderEntity(),
          onSaveTap: () {
            context.read<MyProfileBookmarksCubit>().removeFolderBookmark(
              folderId: folder.id,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _LoadMoreError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LoadMoreError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.018)),
      child: Column(
        children: [
          CustomTextWidget(
            message,
            color: AppPalette.red,
            textAlign: TextAlign.center,
          ),
          TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomButtonWidget(
      childHorizontalPad: SizeConfig.w(0.02),
      childVerticalPad: SizeConfig.w(0.02),
      borderRadius: 20,
      boxShadow: [
        BoxShadow(
          color: appColors.greyMediumTogrey,
          blurRadius: 2,
          offset: Offset(0, 0),
        ),
      ],
      backgroundColor: appColors.whiteToblack,
      onTap: onTap,
      child: Icon(
        icon,
        color: appColors.blackTogreyMedium,
        size: SizeConfig.h(0.03),
      ),
    );
  }
}
