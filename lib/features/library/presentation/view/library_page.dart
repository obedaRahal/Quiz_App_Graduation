import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/empty_action_box.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/route_args/content_details_route_args.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_featured_entity.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_material_entity.dart';
import 'package:quiz_app_grad/features/library/presentation/manager/library_cubit/library_cubit.dart';
import 'package:quiz_app_grad/features/library/presentation/manager/library_cubit/library_state.dart';
import 'package:quiz_app_grad/features/library/presentation/shimmers/library_page_shimmer.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/libaray_tabs_section.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_content_list.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_header.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_media_carousel.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_search_field.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    debugPrint('============ LibraryPage.initState ============');

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    debugPrint('============ LibraryPage.dispose ============');

    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        debugPrint('============ LibraryPage.createLibraryCubit ============');

        return sl<LibraryCubit>()..getInitialLibraryContent();
      },
      child: BlocBuilder<LibraryCubit, LibraryState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.materials != current.materials,
        builder: (context, state) {
          if ((state.status == LibraryStatus.initial ||
                  state.status == LibraryStatus.loading) &&
              state.materials.isEmpty) {
            return const LibraryPageShimmer();
          }

          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.h(0.008)),
                    child: const LibraryHeader(),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.w(0.045),
                      right: SizeConfig.w(0.045),
                      bottom: SizeConfig.h(0.012),
                    ),
                    child: Builder(
                      builder: (context) {
                        return LibrarySearchField(
                          controller: _searchController,
                          onChanged: (value) {
                            debugPrint(
                              '============ LibraryPage.onSearchChanged ============',
                            );
                            debugPrint('→ query: ${value.trim()}');

                            context.read<LibraryCubit>().onSearchChanged(value);
                          },
                          onClear: () {
                            debugPrint(
                              '============ LibraryPage.onSearchClear ============',
                            );

                            _searchController.clear();

                            context.read<LibraryCubit>().clearSearch();

                            FocusScope.of(context).unfocus();
                          },

                          onTap: () {
                            debugPrint(
                              '============ LibraryPage.onSearchTap ============',
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Builder(
                    builder: (context) {
                      return BlocBuilder<LibraryCubit, LibraryState>(
                        buildWhen: (previous, current) {
                          return previous.selectedTab != current.selectedTab ||
                              previous.selectedTabIndex !=
                                  current.selectedTabIndex;
                        },
                        builder: (context, state) {
                          return LibraryTabsSection(
                            selectedIndex: state.selectedTabIndex,
                            onChanged: (index) {
                              debugPrint(
                                '============ LibraryPage.onTabChanged ============',
                              );
                              debugPrint('→ index: $index');

                              _searchController.clear();
                              FocusScope.of(context).unfocus();

                              context.read<LibraryCubit>().changeTabByIndex(
                                index,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  SizedBox(height: SizeConfig.h(0.014)),

                  const Expanded(child: _LibraryContentBody()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LibraryContentBody extends StatelessWidget {
  const _LibraryContentBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final messageColor = isDark
            ? AppPalette.titleWhiteINDark
            : AppPalette.textColorInHome;

        if (state.status == LibraryStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LibraryStatus.failure) {
          return _LibraryMessageState(
            message: state.errorMessage ?? 'حدث خطأ ما',
            color: messageColor,
          );
        }

        if (state.isSearching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isSearchMode && state.searchMaterials.isEmpty) {
          return Column(
            children: [
              CustomBackgroundWithChild(
                width: double.infinity,
                childHorizontalPad: SizeConfig.w(0.04) ,
                backgroundColor: Colors.transparent,
                child: const EmptyActionBox(
                  icon: Icons.search_off_rounded,
                  title: 'لا توجد نتائج',
                  description: 'لم نعثر على محتوى مطابق لبحثك',
                ),
              ),
            ],
          );
        }

        if (!state.isSearchMode &&
            state.featured.isEmpty &&
            state.displayedMaterials.isEmpty) {
          return const EmptyActionBox(
            icon: Icons.local_library_outlined,
            title: 'لا يوجد محتوى',
            description: 'لا يوجد محتوى متاح ضمن هذا التصنيف حالياً',
          );
        }


        return LibraryContentList(
          items: state.displayedMaterials.map(_mapMaterial).toList(),

          header: !state.isSearchMode && state.featured.isNotEmpty
              ? LibraryMediaCarousel(
                  items: state.featured.map(_mapFeatured).toList(),
                  onItemTap: (item) {
                    _openContentDetails(context, contentId: item.id);
                  },
                )
              : null,

          onItemBuild: (index) {
            context.read<LibraryCubit>().loadMoreWhenNeeded(index);
          },

          onItemTap: (item) {
            _openContentDetails(context, contentId: item.id);
          },
        );
      },
    );
  }

  static void _openContentDetails(
    BuildContext context, {
    required int contentId,
  }) {
    debugPrint(
      '============ LibraryContentBody.openContentDetails ============',
    );
    debugPrint('→ contentId: $contentId');

    context.pushNamed(
      AppRouterName.otherContentDetails,
      extra: ContentDetailsRouteArgs(contentId: contentId, isMyContent: false),
    );
  }

  static LibraryMediaItem _mapFeatured(LibraryFeaturedEntity item) {
    return LibraryMediaItem(
      id: item.id,

      title: '',

      scientificSpecialties: item.interests,
      imageUrl: item.urlContent,

      imageAsset: AppImage.defaultImageFoeError,

      likesCount: item.likeCount,
      savesCount: item.bookmarksCount,
      downloadsCount: item.downloadCount,

      editsCount: 0,

      publishedAgo: item.publishedAt,
    );
  }

  static LibraryContentItem _mapMaterial(LibraryMaterialEntity item) {
    return LibraryContentItem(
      id: item.id,
      title: item.title,
      description: item.description,
      type: item.type,
      imageUrl: item.urlContent,
      imageAsset: AppImage.defaultImageFoeError,
      specialties: item.interests,
      likesCount: item.likeCount,

      savesCount: 0,

      publishedAgo: item.publishedAt,
      isBookmarked: item.viewerHasBookmarked,
    );
  }
}

class _LibraryMessageState extends StatelessWidget {
  final String message;
  final Color color;

  const _LibraryMessageState({required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.08),
          vertical: SizeConfig.h(0.02),
        ),
        child: CustomTextWidget(
          message,
          textAlign: TextAlign.center,
          color: color,
          fontSize: SizeConfig.text(0.036).clamp(13.0, 16.0).toDouble(),
          fontWeight: FontWeight.w600,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
