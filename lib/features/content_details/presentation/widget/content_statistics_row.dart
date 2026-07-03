import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ContentStatisticsRow extends StatelessWidget {
  final String publishedAt;
  final int downloadCount;
  final int bookmarksCount;
  final int likeCount;
  final bool viewerHasLiked;
  final VoidCallback? onLikeTap;
  final bool isLikeLoading;
  final bool viewerHasBookmarked;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarkLoading;
  const ContentStatisticsRow({
    super.key,
    required this.publishedAt,
    required this.downloadCount,
    required this.bookmarksCount,
    required this.likeCount,
    required this.viewerHasLiked,
    this.onLikeTap,
    this.isLikeLoading = false,
    required this.viewerHasBookmarked,
    this.onBookmarkTap,
    this.isBookmarkLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        InkWell(
          onTap: isLikeLoading ? null : onLikeTap,
          borderRadius: BorderRadius.circular(20),
          child: _StatItem(
            icon: viewerHasLiked
                ? Icons.favorite_rounded
                : Icons.favorite_border,
            value: likeCount.toString(),
            color: viewerHasLiked ? AppPalette.red : null,
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
          child: InkWell(
            onTap: isBookmarkLoading ? null : onBookmarkTap,
            borderRadius: BorderRadius.circular(20),
            child: _StatItem(
              icon: viewerHasBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              value: bookmarksCount.toString(),
              color: viewerHasBookmarked
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
          ),
        ),
        _StatItem(
          icon: Icons.download_rounded,
          value: downloadCount.toString(),
        ),
        const Spacer(),
        _StatItem(
          icon: Icons.access_time_rounded,
          value: publishedAt.isEmpty ? '-' : publishedAt,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? color;

  const _StatItem({required this.icon, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppPalette.greyMedium;

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        Icon(
          icon,
          color: effectiveColor,
          size: SizeConfig.text(0.044).clamp(16.0, 21.0).toDouble(),
        ),
        SizedBox(width: SizeConfig.w(0.008)),
        CustomTextWidget(
          value,
          color: effectiveColor,
          fontSize: SizeConfig.text(0.030).clamp(11.0, 13.0).toDouble(),
          fontWeight: FontWeight.w600,
          fontFamily: AppFont.elMessiriRegular,
        ),
      ],
    );
  }
}
