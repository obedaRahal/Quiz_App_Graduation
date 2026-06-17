import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/compact_count_formatter.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_content_entity.dart';

class OtherProfileContentCard extends StatelessWidget {
  final OtherProfileContentItemEntity content;
  final VoidCallback onSaveTap;
  final VoidCallback onLikeTap;

  const OtherProfileContentCard({
    super.key,
    required this.content,
    required this.onSaveTap,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(0),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.012)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContentThumbnail(imageUrl: content.urlContent, type: content.type),

            SizedBox(width: SizeConfig.w(0.025)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ContentHeaderRow(
                    title: content.title,
                    type: content.type,
                    isSaved: content.viewerHasBookmarked,
                    onSaveTap: onSaveTap,
                  ),

                  //SizedBox(height: SizeConfig.h(0.004)),
                  CustomTextWidget(
                    content.description,
                    color: AppPalette.greyMedium,
                    fontSize: SizeConfig.text(0.025),
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: SizeConfig.h(0.008)),

                  _ContentFooterRow(
                    tags: content.interests,
                    likesCount: content.likeCount,
                    isLiked: false,
                    publishedAt: content.publishedAt,
                    onLikeTap: onLikeTap,
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

class _ContentThumbnail extends StatelessWidget {
  final String imageUrl;
  final String type;

  const _ContentThumbnail({required this.imageUrl, required this.type});

  bool get isImage => type.trim() == 'صورة';

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      width: SizeConfig.w(0.17),
      height: SizeConfig.w(0.17),
      backgroundColor: AppPalette.greyLight,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppPalette.greyBorderCart, width: 2),
      child: imageUrl.trim().isEmpty
          ? Center(
              child: Icon(
                isImage ? Icons.image_rounded : Icons.insert_drive_file_rounded,
                color: AppPalette.greyMedium,
                size: SizeConfig.w(0.06),
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomAppImage(path: imageUrl, fit: BoxFit.cover),
            ),
    );
  }
}

class _ContentHeaderRow extends StatelessWidget {
  final String title;
  final String type;
  final bool isSaved;
  final VoidCallback onSaveTap;

  const _ContentHeaderRow({
    required this.title,
    required this.type,
    required this.isSaved,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: CustomTextWidget(
            title,
            color: appColors.blackToGrey2Dark,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.04),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: SizeConfig.w(0.015)),

        _ContentTypeBadge(type: type),

        SizedBox(width: SizeConfig.w(0.02)),

        _SaveButton(isSaved: isSaved, onTap: onSaveTap),
      ],
    );
  }
}

class _ContentTypeBadge extends StatelessWidget {
  final String type;

  const _ContentTypeBadge({required this.type});

  bool get isImage => type.trim() == 'صورة';

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWithChild(
      backgroundColor: isImage ? AppPalette.violetMedium : AppPalette.blueDark,
      borderRadius: BorderRadius.circular(4),
      childHorizontalPad: SizeConfig.w(0.018),
      childVerticalPad: SizeConfig.h(0.002),
      child: CustomTextWidget(
        isImage ? 'صورة' : 'ملف',
        color: AppPalette.white,
        fontFamily: AppFont.elMessiriSemiBold,
        fontSize: SizeConfig.text(0.023),
        maxLines: 1,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;

  const _SaveButton({required this.isSaved, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(SizeConfig.w(0.007)),
        decoration: BoxDecoration(
          color: isSaved
              ? AppPalette.red.withOpacity(0.7)
              : AppPalette.greyLight,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.bookmark_border_rounded,
          color: isSaved ? AppPalette.white : AppPalette.greyMedium,
          size: SizeConfig.h(0.027),
        ),
      ),
    );
  }
}

class _ContentFooterRow extends StatelessWidget {
  final List<String> tags;
  final int likesCount;
  final bool isLiked;
  final String publishedAt;
  final VoidCallback onLikeTap;

  const _ContentFooterRow({
    required this.tags,
    required this.likesCount,
    required this.isLiked,
    required this.publishedAt,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              height: SizeConfig.h(0.028),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: tags.map((tag) {
                    return Padding(
                      padding: EdgeInsets.only(left: SizeConfig.w(0.01)),
                      child: _TagChip(title: tag),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: SizeConfig.w(0.012)),

        _LikeIconText(
          isLiked: isLiked,
          text: formatCompactCount(likesCount),
          onTap: onLikeTap,
        ),

        SizedBox(width: SizeConfig.w(0.018)),

        _SmallIconText(icon: Icons.access_time_rounded, text: publishedAt),
      ],
    );
  }
}

class _LikeIconText extends StatelessWidget {
  final bool isLiked;
  final String text;
  final VoidCallback onTap;

  const _LikeIconText({
    required this.isLiked,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.006),
          vertical: SizeConfig.h(0.002),
        ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isLiked ? AppPalette.red : AppPalette.greyMedium,
              size: SizeConfig.h(0.02),
            ),

            SizedBox(width: SizeConfig.w(0.006)),

            CustomTextWidget(
              text,
              color: isLiked ? AppPalette.red : AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.026),
              maxLines: 1,
              fontFamily: AppFont.elMessiriBold,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String title;

  const _TagChip({required this.title});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return CustomBackgroundWithChild(
      backgroundColor: AppPalette.primarySoft,
      borderRadius: BorderRadius.circular(5),
      childHorizontalPad: SizeConfig.w(0.018),
      childVerticalPad: SizeConfig.h(0.002),
      child: CustomTextWidget(
        '# $title',
        color: appColors.primaryToPrimaryDark,
        fontSize: SizeConfig.text(0.022),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}

class _SmallIconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SmallIconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        Icon(icon, color: AppPalette.greyMedium, size: SizeConfig.h(0.017)),

        SizedBox(width: SizeConfig.w(0.006)),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: SizeConfig.w(0.16)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: CustomTextWidget(
              text,
              color: AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.026),
              maxLines: 1,
              overflow: TextOverflow.visible,
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ],
    );
  }
}
