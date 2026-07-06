import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/top_page_header.dart';
import 'package:quiz_app_grad/features/my_profile/domain/entities/my_profile_bookmarks_entity.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_cubit.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/manager/my_profile_bookmarks/my_profile_bookmarks_state.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/mappers/my_profile_bookmark_item_mapper.dart';
import 'package:quiz_app_grad/features/my_profile/presentation/widgets/bookmarks/my_profile_bookmarks_filter_section.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/test_tab/other_profile_test_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/content_tab/other_profile_content_card.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/widgets/folder_tab/other_profile_folder_card.dart';

class MyProfileBookmarksView extends StatelessWidget {
  const MyProfileBookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocProvider(
      create: (_) => sl<MyProfileBookmarksCubit>()..fetchInitial(),
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
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

            SizedBox(height: SizeConfig.h(0.012)),

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
                  BlocBuilder<MyProfileBookmarksCubit, MyProfileBookmarksState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.hasError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(SizeConfig.w(0.05)),
                            child: CustomTextWidget(
                              state.errorMessage ?? 'تعذر جلب المحفوظات',
                              color: AppPalette.greyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (state.items.isEmpty) {
                        return Center(
                          child: CustomTextWidget(
                            'لا توجد عناصر محفوظة حالياً',
                            color: AppPalette.greyMedium,
                            fontSize: SizeConfig.text(0.035),
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
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.items.length) {
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
        onSaveTap: () {
          context.read<MyProfileBookmarksCubit>().removeMaterialBookmark(
            contentId: material.id,
          );
        },
        onLikeTap: () {},
      );
    }

    if (item is MyProfileBookmarkFolderEntity) {
      final folder = item as MyProfileBookmarkFolderEntity;

      return OtherProfileFolderCard(
        folder: folder.toOtherProfileFolderEntity(),
        onSaveTap: () {
          context.read<MyProfileBookmarksCubit>().removeFolderBookmark(
            folderId: folder.id,
          );
        },
      );
    }

    return const SizedBox.shrink();
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
