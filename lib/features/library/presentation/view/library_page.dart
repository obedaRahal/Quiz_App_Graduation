// import 'package:flutter/material.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/library/presentation/widget/libaray_tabs_section.dart';
// import 'package:quiz_app_grad/features/library/presentation/widget/library_content_list.dart';
// import 'package:quiz_app_grad/features/library/presentation/widget/library_header.dart';
// import 'package:quiz_app_grad/features/library/presentation/widget/library_media_carousel.dart';
// import 'package:quiz_app_grad/features/library/presentation/widget/library_search_field.dart';

// class LibraryPage extends StatelessWidget {
//   const LibraryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final searchController = TextEditingController();

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(top: 8),
//               child: LibraryHeader(),
//             ),

//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: SizeConfig.w(0.045),
//                 vertical: SizeConfig.h(0.012),
//               ),
//               child: LibrarySearchField(
//                 controller: searchController,
//                 onChanged: (value) {
//                   // لاحقاً:
//                   // context.read<LibraryCubit>().onSearchChanged(value);
//                 },
//                 onClear: () {
//                   searchController.clear();

//                   // لاحقاً:
//                   // context.read<LibraryCubit>().clearSearch();
//                 },
//                 onTap: () {
//                   // لاحقاً:
//                   // context.read<LibraryCubit>().enterSearchMode();
//                 },
//               ),
//             ),

//             LibraryTabsSection(
//               selectedIndex: 0,
//               onChanged: (index) {
//                 // لاحقاً:
//                 // context.read<LibraryCubit>().changeSelectedTab(index);
//               },
//             ),

//             SizedBox(height: SizeConfig.h(0.014)),

//             const LibraryMediaCarousel(),
//             Expanded(child: LibraryContentList()),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_featured_entity.dart';
import 'package:quiz_app_grad/features/library/domain/entities/library_material_entity.dart';
import 'package:quiz_app_grad/features/library/presentation/manager/library_cubit/library_cubit.dart';
import 'package:quiz_app_grad/features/library/presentation/manager/library_cubit/library_state.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/libaray_tabs_section.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_content_list.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_header.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_media_carousel.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_search_field.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return BlocProvider(
      create: (_) => sl<LibraryCubit>()..getInitialLibraryContent(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: LibraryHeader(),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(0.045),
                      vertical: SizeConfig.h(0.012),
                    ),
                    child: LibrarySearchField(
                      controller: searchController,
                      onChanged: (value) {
                        context.read<LibraryCubit>().onSearchChanged(value);
                      },
                      onClear: () {
                        searchController.clear();
                        context.read<LibraryCubit>().clearSearch();
                      },
                      onTap: () {},
                    ),
                  ),

                  BlocBuilder<LibraryCubit, LibraryState>(
                    buildWhen: (previous, current) =>
                        previous.selectedTab != current.selectedTab,
                    builder: (context, state) {
                      return LibraryTabsSection(
                        selectedIndex: state.selectedTabIndex,
                        onChanged: (index) {
                          context.read<LibraryCubit>().changeTabByIndex(index);
                        },
                      );
                    },
                  ),

                  SizedBox(height: SizeConfig.h(0.014)),

                  Expanded(
                    child: BlocBuilder<LibraryCubit, LibraryState>(
                      builder: (context, state) {
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark;
                        final messageColor = isDark
                            ? AppPalette.titleWhiteINDark
                            : AppPalette.textColorInHome;

                        if (state.status == LibraryStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.status == LibraryStatus.failure) {
                          return Center(
                            child: CustomTextWidget(
                              state.errorMessage ?? 'حدث خطأ ما',
                              textAlign: TextAlign.center,
                              color: messageColor,
                              fontSize: SizeConfig.text(
                                0.036,
                              ).clamp(13.0, 16.0).toDouble(),
                              fontWeight: FontWeight.w600,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }

                        if (state.isSearching &&
                            state.searchMaterials.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.isSearchMode &&
                            !state.isSearching &&
                            state.searchMaterials.isEmpty) {
                          return Center(
                            child: CustomTextWidget(
                              state.errorMessage ?? 'لا توجد نتائج مطابقة',
                              textAlign: TextAlign.center,
                              color: messageColor,
                              fontSize: SizeConfig.text(
                                0.036,
                              ).clamp(13.0, 16.0).toDouble(),
                              fontWeight: FontWeight.w600,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }

                        return Column(
                          children: [
                            if (!state.isSearchMode)
                              LibraryMediaCarousel(
                                items: state.featured
                                    .map(_mapFeatured)
                                    .toList(),
                              ),

                            Expanded(
                              child: LibraryContentList(
                                items: state.displayedMaterials
                                    .map(_mapMaterial)
                                    .toList(),
                                onItemBuild: (index) {
                                  context
                                      .read<LibraryCubit>()
                                      .loadMoreWhenNeeded(index);
                                },
                              ),
                            ),
                          ],
                        );
                        // return Column(
                        //   children: [
                        //     LibraryMediaCarousel(
                        //       items: state.featured.map(_mapFeatured).toList(),
                        //     ),

                        //     Expanded(
                        //       child: LibraryContentList(
                        //         items: state.materials
                        //             .map(_mapMaterial)
                        //             .toList(),
                        //         onItemBuild: (index) {
                        //           context
                        //               .read<LibraryCubit>()
                        //               .loadMoreWhenNeeded(index);
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  LibraryMediaItem _mapFeatured(LibraryFeaturedEntity item) {
    return LibraryMediaItem(
      id: item.id,
      title: '',
      scientificSpecialties: item.interests,
      imageUrl: item.urlContent,
      likesCount: item.likeCount,
      savesCount: item.bookmarksCount,
      downloadsCount: item.downloadCount,
      editsCount: 0,
      publishedAgo: item.publishedAt,
    );
  }

  LibraryContentItem _mapMaterial(LibraryMaterialEntity item) {
    return LibraryContentItem(
      title: item.title,
      description: item.description,
      type: item.type,
      imageUrl: item.urlContent,
      imageAsset: AppImage.carmen,
      specialties: item.interests,
      likesCount: item.likeCount,
      savesCount: 0,
      publishedAgo: item.publishedAt,
      isBookmarked: item.viewerHasBookmarked,
    );
  }
}
