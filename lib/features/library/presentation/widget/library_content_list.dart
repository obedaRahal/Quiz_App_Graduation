import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LibraryContentItem {
  final String title;
  final String description;
  final String type;
  final String? imageUrl;
  final String? imageAsset;
  final List<String> specialties;
  final int likesCount;
  final int savesCount;
  final String publishedAgo;
  final bool isBookmarked;

  const LibraryContentItem({
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    this.imageAsset,
    required this.specialties,
    required this.likesCount,
    required this.savesCount,
    required this.publishedAgo,
    required this.isBookmarked,
  });
}

class LibraryContentList extends StatelessWidget {
  final List<LibraryContentItem> items;
  final ValueChanged<int>? onItemBuild;

  const LibraryContentList({
    super.key,
    required this.items,
    this.onItemBuild,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.045),
        vertical: SizeConfig.h(0.012),
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.006)),
        child: Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.45 : 0.9,
              ),
        ),
      ),
      itemBuilder: (context, index) {
        onItemBuild?.call(index);
        return _LibraryContentCard(item: items[index]);
      },
    );
  }
}

class _LibraryContentCard extends StatelessWidget {
  final LibraryContentItem item;

  const _LibraryContentCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: SizeConfig.h(0.112).clamp(94.0, 112.0).toDouble(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(0.0028)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ContentImage(
                imageUrl: item.imageUrl,
                imageAsset: item.imageAsset,
              ),
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
                            fontSize: SizeConfig.text(0.043)
                                .clamp(16.0, 21.0)
                                .toDouble(),
                            fontWeight: FontWeight.w700,
                            fontFamily: AppFont.elMessiriRegular,
                          ),
                        ),
                        SizedBox(width: SizeConfig.w(0.018)),
                        _TypeBadge(title: item.type),
                        SizedBox(width: SizeConfig.w(0.014)),
                        _BookmarkButton(
                          isDark: isDark,
                          isBookmarked: item.isBookmarked,
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.h(0.004)),
                    CustomTextWidget(
                      item.description,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                      fontSize: SizeConfig.text(0.029)
                          .clamp(10.5, 13.0)
                          .toDouble(),
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFont.elMessiriRegular,
                    ),
                    SizedBox(height: SizeConfig.h(0.01)),
                    _BottomOneLineRow(
                      specialties: item.specialties,
                      likesCount: item.likesCount,
                      publishedAgo: item.publishedAgo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentImage extends StatelessWidget {
  final String? imageUrl;
  final String? imageAsset;

  const _ContentImage({
    required this.imageUrl,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final path = (imageUrl != null && imageUrl!.trim().isNotEmpty)
        ? imageUrl!
        : (imageAsset ?? AppImage.carmen);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: SizeConfig.w(0.205).clamp(72.0, 88.0).toDouble(),
        height: SizeConfig.h(0.095).clamp(72.0, 88.0).toDouble(),
        child: CustomAppImage(
          path: path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _BottomOneLineRow extends StatelessWidget {
  final List<String> specialties;
  final int likesCount;
  final String publishedAgo;

  const _BottomOneLineRow({
    required this.specialties,
    required this.likesCount,
    required this.publishedAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(child: _ResponsiveSpecialties(specialties: specialties)),
        SizedBox(width: SizeConfig.w(0.014)),
        _InfoIcon(
          icon: Icons.favorite_border_rounded,
          value: likesCount.toString(),
        ),
        SizedBox(width: SizeConfig.w(0.024)),
        _InfoIcon(
          icon: Icons.access_time_rounded,
          value: publishedAgo,
        ),
      ],
    );
  }
}

class _ResponsiveSpecialties extends StatelessWidget {
  final List<String> specialties;

  const _ResponsiveSpecialties({
    required this.specialties,
  });

  @override
  Widget build(BuildContext context) {
    if (specialties.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final showSecondSpecialty =
            specialties.length > 1 && constraints.maxWidth >= 132;

        return Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: _SpecialtyChip(title: specialties.first)),
            if (specialties.length > 1) ...[
              SizedBox(width: SizeConfig.w(0.010)),
              _SpecialtyChip(
                title: showSecondSpecialty ? specialties[1] : '...',
                isDots: !showSecondSpecialty,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool isDark;
  final bool isBookmarked;

  const _BookmarkButton({
    required this.isDark,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.w(0.064).clamp(24.0, 32.0).toDouble(),
      height: SizeConfig.w(0.064).clamp(24.0, 32.0).toDouble(),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.fieldColorNDark : AppPalette.whiteToGrey,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(
        isBookmarked
            ? Icons.bookmark_rounded
            : Icons.bookmark_border_rounded,
        color: isBookmarked
            ? Theme.of(context).colorScheme.primary
            : (isDark ? AppPalette.grey2Dark : AppPalette.greyMedium),
        size: SizeConfig.text(0.052).clamp(18.0, 24.0).toDouble(),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String title;

  const _TypeBadge({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.03),
        vertical: SizeConfig.h(0.002),
      ),
      decoration: BoxDecoration(
        color: AppPalette.purple,
        borderRadius: BorderRadius.circular(5),
      ),
      child: CustomTextWidget(
        title,
        color: isDark ? AppPalette.black : AppPalette.white,
        fontSize: SizeConfig.text(0.028).clamp(10.0, 12.0).toDouble(),
        fontWeight: FontWeight.w700,
        fontFamily: AppFont.elMessiriRegular,
      ),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String title;
  final bool isDots;

  const _SpecialtyChip({
    required this.title,
    this.isDots = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isDots
            ? SizeConfig.w(0.085).clamp(28.0, 36.0).toDouble()
            : SizeConfig.w(0.185).clamp(58.0, 86.0).toDouble(),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.020),
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
        fontSize: SizeConfig.text(0.025).clamp(8.5, 11.0).toDouble(),
        fontWeight: FontWeight.w600,
        fontFamily: AppFont.elMessiriRegular,
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoIcon({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = SizeConfig.text(0.043).clamp(15.0, 22.0).toDouble();
    final fontSize = SizeConfig.text(0.026).clamp(9.0, 12.0).toDouble();

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            icon,
            color: AppPalette.greyMedium,
            size: iconSize,
          ),
          SizedBox(width: SizeConfig.w(0.006)),
          CustomTextWidget(
            value,
            color: AppPalette.greyMedium,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            fontFamily: AppFont.elMessiriRegular,
          ),
        ],
      ),
    );
  }
}