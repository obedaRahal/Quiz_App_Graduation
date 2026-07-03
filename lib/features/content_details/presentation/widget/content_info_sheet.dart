import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_state.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_details_demo_data.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_interest_chip.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_publisher_section.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_report_sheet.dart';
import 'package:quiz_app_grad/features/content_details/presentation/widget/content_statistics_row.dart';

class ContentInfoSheet extends StatelessWidget {
  final ContentDetailsUiData data;
  final DraggableScrollableController controller;
  final double collapsedSize;
  final double initialSize;
  final double maxSize;

  const ContentInfoSheet({
    super.key,
    required this.data,
    required this.controller,
    required this.collapsedSize,
    required this.initialSize,
    required this.maxSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      controller: controller,
      expand: false,
      initialChildSize: initialSize,
      minChildSize: collapsedSize,
      maxChildSize: maxSize,
      snap: true,
      snapSizes: [collapsedSize, initialSize, maxSize],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101820) : AppPalette.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: AppPalette.black.withOpacity(isDark ? 0.35 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      left: SizeConfig.w(0.045),
                      right: SizeConfig.w(0.045),
                      top: SizeConfig.h(0.010),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: SizeConfig.w(0.13),
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppPalette.greyLightDark
                                : AppPalette.greyLight,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),

                        SizedBox(height: SizeConfig.h(0.016)),

                        if (!data.isOwner) ...[
                          BlocBuilder<
                            OtherContentDetailsCubit,
                            OtherContentDetailsState
                          >(
                            buildWhen: (previous, current) =>
                                previous.viewerHasLiked !=
                                    current.viewerHasLiked ||
                                previous.likeCount != current.likeCount ||
                                previous.isLikeLoading !=
                                    current.isLikeLoading ||
                                previous.viewerHasBookmarked !=
                                    current.viewerHasBookmarked ||
                                previous.bookmarksCount !=
                                    current.bookmarksCount ||
                                previous.isBookmarkLoading !=
                                    current.isBookmarkLoading,
                            builder: (context, state) {
                              return ContentStatisticsRow(
                                publishedAt: data.publishedAt,
                                downloadCount: data.downloadCount,
                                bookmarksCount:
                                    state.bookmarksCount ?? data.bookmarksCount,
                                likeCount: state.likeCount ?? data.likeCount,
                                viewerHasLiked:
                                    state.viewerHasLiked ?? data.viewerHasLiked,
                                viewerHasBookmarked:
                                    state.viewerHasBookmarked ??
                                    data.viewerHasBookmarked,
                                isLikeLoading: state.isLikeLoading,
                                isBookmarkLoading: state.isBookmarkLoading,
                                onLikeTap: () {
                                  context
                                      .read<OtherContentDetailsCubit>()
                                      .toggleLike();
                                },
                                onBookmarkTap: () {
                                  context
                                      .read<OtherContentDetailsCubit>()
                                      .toggleBookmark();
                                },
                              );
                            },
                          ),
                          SizedBox(height: SizeConfig.h(0.018)),
                        ],

                        if (!data.isOwner && data.publisher != null)
                          BlocBuilder<
                            OtherContentDetailsCubit,
                            OtherContentDetailsState
                          >(
                            buildWhen: (previous, current) =>
                                previous.isFollowLoading !=
                                    current.isFollowLoading ||
                                previous.isUnfollowLoading !=
                                    current.isUnfollowLoading ||
                                previous.viewerIsFollowingPublisher !=
                                    current.viewerIsFollowingPublisher,
                            builder: (context, state) {
                              return ContentPublisherSection(
                                publisher: data.publisher!,
                                isFollowing:
                                    state.viewerIsFollowingPublisher ??
                                    data.viewerIsFollowingCreator,
                                isFollowLoading:
                                    state.isFollowLoading ||
                                    state.isUnfollowLoading,
                                onFollowTap: () {
                                  final isFollowing =
                                      state.viewerIsFollowingPublisher ??
                                      data.viewerIsFollowingCreator;

                                  if (isFollowing) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        final isDark =
                                            Theme.of(context).brightness ==
                                            Brightness.dark;

                                        return AlertDialog(
                                          backgroundColor: isDark
                                              ? AppPalette.fieldColorNDark
                                              : AppPalette.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                          ),

                                          title: Text(
                                            'إلغاء المتابعة',
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontFamily: 'elMessiriRegular',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: isDark
                                                  ? AppPalette.textWhiteINDark
                                                  : AppPalette.textColorInHome,
                                            ),
                                          ),

                                          content: Text(
                                            'هل تريد إلغاء متابعة الناشر "${data.publisher!.name}"؟',
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontFamily: 'elMessiriRegular',
                                              fontSize: 15,
                                              color: isDark
                                                  ? AppPalette.grey2Dark
                                                  : AppPalette.greyMedium,
                                            ),
                                          ),

                                          actionsAlignment:
                                              MainAxisAlignment.start,

                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                'إلغاء',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'elMessiriRegular',
                                                  color: AppPalette.red,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),

                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                context
                                                    .read<
                                                      OtherContentDetailsCubit
                                                    >()
                                                    .unfollowPublisher();
                                              },
                                              child: Text(
                                                'نعم',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'elMessiriRegular',
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    context
                                        .read<OtherContentDetailsCubit>()
                                        .followPublisher();
                                  }
                                },
                              );
                            },
                          ),

                        if (!data.isOwner && data.publisher != null)
                          Divider(
                            height: SizeConfig.h(0.028),
                            color: Theme.of(context).dividerColor,
                          ),

                        _ContentTexts(data: data),

                        SizedBox(height: SizeConfig.h(0.014)),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: SizeConfig.w(0.012),
                            runSpacing: SizeConfig.h(0.006),
                            children: data.interests
                                .take(3)
                                .map((e) => ContentInterestChip(title: e))
                                .toList(),
                          ),
                        ),

                        SizedBox(height: SizeConfig.h(0.014)),

                        if (!data.isOwner) ...[
                          Divider(
                            height: SizeConfig.h(0.026),
                            thickness: 1,
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(isDark ? 0.45 : 0.9),
                          ),

                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomTextWidget(
                              'محتويات مشابهة',
                              textAlign: TextAlign.right,
                              color: isDark
                                  ? AppPalette.textWhiteINDark
                                  : AppPalette.textColorInHome,
                              fontSize: SizeConfig.text(
                                0.036,
                              ).clamp(13.0, 16.0).toDouble(),
                              fontWeight: FontWeight.w700,
                              fontFamily: AppFont.elMessiriRegular,
                            ),
                          ),

                          SizedBox(height: SizeConfig.h(0.008)),

                          const _RelatedContentList(),

                          SizedBox(height: SizeConfig.h(0.014)),
                        ],
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.w(0.045),
                    right: SizeConfig.w(0.045),
                    bottom: SizeConfig.h(0.018),
                    top: SizeConfig.h(0.006),
                  ),
                  child: _BottomActions(isOwner: data.isOwner),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ContentTexts extends StatelessWidget {
  final ContentDetailsUiData data;

  const _ContentTexts({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'elMessiriRegular',
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              fontSize: SizeConfig.text(0.043)
                  .clamp(17.0, 21.0)
                  .toDouble(),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: SizeConfig.h(0.008)),

          Text(
            data.description,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'elMessiriRegular',
              color: isDark
                  ? AppPalette.grey2Dark
                  : AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.030)
                  .clamp(11.0, 13.0)
                  .toDouble(),
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedContentItem {
  final String title;
  final String description;
  final String type;
  final int id;
  final String imageUrl;
  final List<String> interests;
  final int likesCount;
  final String publishedAgo;
  final bool isBookmarked;

  const _RelatedContentItem({
    required this.title,
    required this.description,
    required this.type,
    required this.id,
    required this.imageUrl,
    required this.interests,
    required this.likesCount,
    required this.publishedAgo,
    required this.isBookmarked,
  });
}

class _RelatedContentList extends StatelessWidget {
  const _RelatedContentList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherContentDetailsCubit, OtherContentDetailsState>(
      buildWhen: (previous, current) =>
          previous.isSimilarLoading != current.isSimilarLoading ||
          previous.isSimilarLoadingMore != current.isSimilarLoadingMore ||
          previous.similarMaterials != current.similarMaterials ||
          previous.similarBookmarkLoadingIds !=
              current.similarBookmarkLoadingIds,
      builder: (context, state) {
        if (state.isSimilarLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.020)),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.similarMaterials.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.014)),
            child: CustomTextWidget(
              'لا يوجد محتوى مشابه حالياً',
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.030).clamp(11.0, 13.0).toDouble(),
              fontWeight: FontWeight.w600,
              fontFamily: AppFont.elMessiriRegular,
            ),
          );
        }

        return Column(
          children: List.generate(state.similarMaterials.length, (index) {
            context.read<OtherContentDetailsCubit>().loadMoreSimilarWhenNeeded(
              index,
            );

            final item = state.similarMaterials[index];

            return Column(
              children: [
                _RelatedContentCard(
                  item: _RelatedContentItem(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    type: item.type,
                    imageUrl: item.urlContent,
                    interests: item.interests,
                    likesCount: item.likeCount,
                    publishedAgo: item.publishedAt,
                    isBookmarked: item.viewerHasBookmarked,
                  ),
                  isBookmarkLoading: state.similarBookmarkLoadingIds.contains(
                    item.id,
                  ),
                  onBookmarkTap: () {
                    context
                        .read<OtherContentDetailsCubit>()
                        .toggleSimilarBookmark(item.id);
                  },
                ),
                if (index != state.similarMaterials.length - 1)
                  Divider(
                    height: SizeConfig.h(0.020),
                    thickness: 1,
                    color: Theme.of(context).dividerColor.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.45
                          : 0.9,
                    ),
                  ),
                if (index == state.similarMaterials.length - 1 &&
                    state.isSimilarLoadingMore)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.h(0.010),
                    ),
                    child: const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
              ],
            );
          }),
        );
      },
    );
  }
}

class _RelatedContentCard extends StatelessWidget {
  final _RelatedContentItem item;
  final VoidCallback onBookmarkTap;
  final bool isBookmarkLoading;

  const _RelatedContentCard({
    required this.item,
    required this.onBookmarkTap,
    required this.isBookmarkLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.004)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RelatedImage(imageUrl: item.imageUrl),

            SizedBox(width: SizeConfig.w(0.025)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: CustomTextWidget(
                          item.title,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: isDark
                              ? AppPalette.titleWhiteINDark
                              : AppPalette.textColorInHome,
                          fontSize: SizeConfig.text(
                            0.038,
                          ).clamp(14.0, 18.0).toDouble(),
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFont.elMessiriRegular,
                        ),
                      ),

                      SizedBox(width: SizeConfig.w(0.012)),

                      _RelatedTypeBadge(title: item.type),

                      SizedBox(width: SizeConfig.w(0.010)),

                      _RelatedBookmarkButton(
                        isDark: isDark,
                        isBookmarked: item.isBookmarked,
                        isLoading: isBookmarkLoading,
                        onTap: onBookmarkTap,
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.h(0.004)),

                  CustomTextWidget(
                    item.description,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    color: isDark
                        ? AppPalette.grey2Dark
                        : AppPalette.greyMedium,
                    fontSize: SizeConfig.text(
                      0.027,
                    ).clamp(10.0, 12.0).toDouble(),
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFont.elMessiriRegular,
                  ),

                  SizedBox(height: SizeConfig.h(0.008)),

                  _RelatedBottomRow(
                    interests: item.interests,
                    likesCount: item.likesCount,
                    publishedAgo: item.publishedAgo,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedImage extends StatelessWidget {
  final String imageUrl;

  const _RelatedImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final path = imageUrl.trim().isNotEmpty ? imageUrl : AppImage.carmen;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: SizeConfig.w(0.190).clamp(66.0, 82.0).toDouble(),
        height: SizeConfig.h(0.085).clamp(66.0, 82.0).toDouble(),
        child: CustomAppImage(path: path, fit: BoxFit.cover),
      ),
    );
  }
}

class _RelatedBottomRow extends StatelessWidget {
  final List<String> interests;
  final int likesCount;
  final String publishedAgo;

  const _RelatedBottomRow({
    required this.interests,
    required this.likesCount,
    required this.publishedAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(child: _RelatedResponsiveInterests(interests: interests)),
        SizedBox(width: SizeConfig.w(0.012)),
        _RelatedInfoIcon(
          icon: Icons.favorite_border_rounded,
          value: likesCount.toString(),
        ),
        SizedBox(width: SizeConfig.w(0.020)),
        _RelatedInfoIcon(icon: Icons.access_time_rounded, value: publishedAgo),
      ],
    );
  }
}

class _RelatedResponsiveInterests extends StatelessWidget {
  final List<String> interests;

  const _RelatedResponsiveInterests({required this.interests});

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSecond = interests.length > 1 && constraints.maxWidth >= 125;

        return Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: _RelatedInterestChip(title: interests.first)),
            if (interests.length > 1) ...[
              SizedBox(width: SizeConfig.w(0.010)),
              _RelatedInterestChip(
                title: showSecond ? interests[1] : '...',
                isDots: !showSecond,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RelatedBookmarkButton extends StatelessWidget {
  final bool isDark;
  final bool isBookmarked;
  final bool isLoading;
  final VoidCallback onTap;

  const _RelatedBookmarkButton({
    required this.isDark,
    required this.isBookmarked,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        width: SizeConfig.w(0.058).clamp(22.0, 30.0).toDouble(),
        height: SizeConfig.w(0.058).clamp(22.0, 30.0).toDouble(),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.fieldColorNDark : AppPalette.whiteToGrey,
          borderRadius: BorderRadius.circular(7),
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(6),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                color: isBookmarked
                    ? Theme.of(context).colorScheme.primary
                    : (isDark ? AppPalette.grey2Dark : AppPalette.greyMedium),
                size: SizeConfig.text(0.046).clamp(16.0, 22.0).toDouble(),
              ),
      ),
    );
  }
}

class _RelatedTypeBadge extends StatelessWidget {
  final String title;

  const _RelatedTypeBadge({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.026),
        vertical: SizeConfig.h(0.002),
      ),
      decoration: BoxDecoration(
        color: AppPalette.purple,
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomTextWidget(
        title,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppPalette.black
            : AppPalette.white,
        fontSize: SizeConfig.text(0.025).clamp(9.0, 11.0).toDouble(),
        fontWeight: FontWeight.w700,
        fontFamily: AppFont.elMessiriRegular,
      ),
    );
  }
}

class _RelatedInterestChip extends StatelessWidget {
  final String title;
  final bool isDots;

  const _RelatedInterestChip({required this.title, this.isDots = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isDots
            ? SizeConfig.w(0.080).clamp(26.0, 34.0).toDouble()
            : SizeConfig.w(0.175).clamp(54.0, 82.0).toDouble(),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.018),
        vertical: SizeConfig.h(0.003),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppPalette.greyLightDark
            : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomTextWidget(
        isDots ? '...' : '# $title',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        color: Theme.of(context).colorScheme.primary,
        fontSize: SizeConfig.text(0.024).clamp(8.5, 10.5).toDouble(),
        fontWeight: FontWeight.w600,
        fontFamily: AppFont.elMessiriRegular,
      ),
    );
  }
}

class _RelatedInfoIcon extends StatelessWidget {
  final IconData icon;
  final String value;

  const _RelatedInfoIcon({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            icon,
            color: AppPalette.greyMedium,
            size: SizeConfig.text(0.038).clamp(14.0, 20.0).toDouble(),
          ),
          SizedBox(width: SizeConfig.w(0.006)),
          CustomTextWidget(
            value,
            color: AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.024).clamp(8.5, 11.0).toDouble(),
            fontWeight: FontWeight.w500,
            fontFamily: AppFont.elMessiriRegular,
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final bool isOwner;
  const _BottomActions({required this.isOwner});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtherContentDetailsCubit, OtherContentDetailsState>(
      buildWhen: (previous, current) =>
          previous.isReportLoading != current.isReportLoading ||
          previous.hasReported != current.hasReported ||
          previous.isDownloadLoading != current.isDownloadLoading,
      builder: (context, state) {
        return Row(
          textDirection: TextDirection.rtl,
          children: [
            if (!isOwner) ...[
              Expanded(
                child: _ActionButton(
                  title: state.hasReported ? 'تم الإبلاغ' : 'تقديم بلاغ',
                  icon: state.hasReported ? Icons.flag : Icons.flag_outlined,
                  isPrimary: false,
                  onTap: state.isReportLoading || state.hasReported
                      ? () {}
                      : () {
                          ContentReportSheet.show(
                            context,
                            onSubmit: ({required reason, description}) {
                              context
                                  .read<OtherContentDetailsCubit>()
                                  .reportContent(
                                    reason: reason,
                                    description: description,
                                  );
                            },
                          );
                        },
                ),
              ),

              SizedBox(width: SizeConfig.w(0.025)),
            ],

            Expanded(
              child: _ActionButton(
                title: state.isDownloadLoading
                    ? 'جار التحميل...'
                    : 'تحميل المحتوى',
                icon: Icons.download_rounded,
                isPrimary: true,
                onTap: state.isDownloadLoading
                    ? () {}
                    : () {
                        context
                            .read<OtherContentDetailsCubit>()
                            .downloadContent();
                      },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final redColor = AppPalette.red;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: SizeConfig.h(0.050),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isPrimary ? primaryColor : redColor,
            width: 1.1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'elMessiriRegular',
                color: isPrimary ? AppPalette.white : redColor,
                fontSize: SizeConfig.text(0.032).clamp(12.0, 14.0).toDouble(),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: SizeConfig.w(0.014)),
            Icon(
              icon,
              color: isPrimary ? AppPalette.white : redColor,
              size: SizeConfig.text(0.045),
            ),
          ],
        ),
      ),
    );
  }
}
