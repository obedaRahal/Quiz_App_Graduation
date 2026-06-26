import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LibraryMediaItem {
  final int id;
  final String title;
  final List<String> scientificSpecialties;
  final String? imageUrl;
  final String? imageAsset;
  final int likesCount;
  final int savesCount;
  final int downloadsCount;
  final int editsCount;
  final String publishedAgo;

  const LibraryMediaItem({
    required this.id,
    required this.title,
    required this.scientificSpecialties,
    this.imageUrl,
    this.imageAsset,
    required this.likesCount,
    required this.savesCount,
    required this.downloadsCount,
    required this.editsCount,
    required this.publishedAgo,
  });
  bool get hasMultipleSpecialties => scientificSpecialties.length > 1;

  String get specialtyLabel {
    if (scientificSpecialties.isEmpty) return '';
    if (scientificSpecialties.length == 1) return scientificSpecialties.first;

    return '${scientificSpecialties.first} ...';
  }
}

class LibraryMediaCarousel extends StatelessWidget {
  final List<LibraryMediaItem> items;
  final ValueChanged<LibraryMediaItem>? onItemTap;

  const LibraryMediaCarousel({super.key, required this.items, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final cardHeight = SizeConfig.h(0.205).clamp(156.0, 188.0).toDouble();

    return SizedBox(
      height: cardHeight + SizeConfig.h(0.014),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          padding: EdgeInsetsDirectional.only(
            start: SizeConfig.w(0.045),
            end: SizeConfig.w(0.045),
            bottom: SizeConfig.h(0.008),
          ),
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: SizeConfig.w(0.028)),
          itemBuilder: (context, index) {
            final item = items[index];

            return _LibraryMediaCard(
              item: item,
              cardHeight: cardHeight,
              onTap: () => onItemTap?.call(item),
            );
          },
        ),
      ),
    );
  }
}

class _LibraryMediaCard extends StatelessWidget {
  final LibraryMediaItem item;
  final double cardHeight;
  final VoidCallback? onTap;

  const _LibraryMediaCard({
    required this.item,
    required this.cardHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //final isDark = Theme.of(context).brightness == Brightness.dark;

    // final cardWidth = SizeConfig.w(0.285).clamp(104.0, 124.0).toDouble();
    final cardWidth = SizeConfig.w(0.36).clamp(132.0, 155.0).toDouble();
    final radius = SizeConfig.w(0.045).clamp(14.0, 18.0).toDouble();

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: _LibraryMediaImage(item: item)),

              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.42, 0.68, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.18),
                        Colors.black.withOpacity(0.78),
                      ],
                    ),
                  ),
                ),
              ),

              PositionedDirectional(
                start: SizeConfig.w(0.018),
                end: SizeConfig.w(0.018),
                bottom: SizeConfig.h(0.010),
                child: _LibraryMediaBottomInfo(item: item, maxWidth: cardWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryMediaImage extends StatelessWidget {
  final LibraryMediaItem item;

  const _LibraryMediaImage({required this.item});

  @override
  Widget build(BuildContext context) {
    final path = item.imageUrl != null && item.imageUrl!.trim().isNotEmpty
        ? item.imageUrl!
        : (item.imageAsset ?? AppImage.carmen);

    return SizedBox.expand(
      child: CustomAppImage(path: path, fit: BoxFit.cover),
    );
  }
}

// class _LibraryMediaPlaceholder extends StatelessWidget {
//   final LibraryMediaItem item;

//   const _LibraryMediaPlaceholder({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: CustomAppImage(path: AppImage.carmen, fit: BoxFit.cover),
//     );
//   }
// }

class _LibraryMediaBottomInfo extends StatelessWidget {
  final LibraryMediaItem item;
  final double maxWidth;

  const _LibraryMediaBottomInfo({required this.item, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _FeaturedSpecialtiesRow(
          specialties: item.scientificSpecialties,
          maxWidth: maxWidth,
        ),

        SizedBox(height: SizeConfig.h(0.006)),

        // Row(
        //   textDirection: TextDirection.rtl,
        //   children: [
        //     Expanded(
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           _LibraryMediaMetric(
        //             icon: Icons.favorite_rounded,
        //             value: _formatCount(item.likesCount),
        //           ),
        //           SizedBox(width: SizeConfig.w(0.010)),
        //           _LibraryMediaMetric(
        //             icon: Icons.bookmark_rounded,
        //             value: _formatCount(item.savesCount),
        //           ),
        //           SizedBox(width: SizeConfig.w(0.010)),
        //           _LibraryMediaMetric(
        //             icon: Icons.download_rounded,
        //             value: _formatCount(item.downloadsCount),
        //           ),
        //         ],
        //       ),
        //     ),

        //     SizedBox(width: SizeConfig.w(0.010)),

        //     _LibraryMediaMetric(
        //       icon: Icons.access_time_rounded,
        //       value: item.publishedAgo,
        //     ),
        //   ],
        // ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: _LibraryMediaMetric(
                      icon: Icons.favorite_rounded,
                      value: _formatCount(item.likesCount),
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.008)),

                  Flexible(
                    child: _LibraryMediaMetric(
                      icon: Icons.bookmark_rounded,
                      value: _formatCount(item.savesCount),
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.008)),

                  Flexible(
                    child: _LibraryMediaMetric(
                      icon: Icons.download_rounded,
                      value: _formatCount(item.downloadsCount),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: SizeConfig.w(0.006)),

            Flexible(
              child: _LibraryMediaMetric(
                icon: Icons.access_time_rounded,
                value: item.publishedAgo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}م';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}ألف';
    }
    return value.toString();
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String title;
  final double? maxWidth;

  const _SpecialtyChip({required this.title, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? SizeConfig.w(0.24)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.018),
        vertical: SizeConfig.h(0.0025),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.greyLightDark : AppPalette.primarySoft,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: SizeConfig.text(0.022).clamp(8.0, 10.0).toDouble(),
          fontFamily: AppFont.elMessiriRegular,
          fontWeight: FontWeight.w600,
          height: 1.15,
        ),
      ),
    );
  }
}

class _LibraryMediaMetric extends StatelessWidget {
  final IconData icon;
  final String value;

  const _LibraryMediaMetric({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.95),
            size: SizeConfig.text(0.026).clamp(8.0, 10.5).toDouble(),
          ),
          SizedBox(width: SizeConfig.w(0.002)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: SizeConfig.w(0.085).clamp(26.0, 38.0).toDouble(),
            ),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: SizeConfig.text(0.020).clamp(7.0, 9.0).toDouble(),
                fontFamily: AppFont.elMessiriRegular,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedSpecialtiesRow extends StatelessWidget {
  final List<String> specialties;
  final double maxWidth;

  const _FeaturedSpecialtiesRow({
    required this.specialties,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (specialties.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        final showSecond =
            specialties.length > 1 && availableWidth >= maxWidth * 0.78;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: _SpecialtyChip(
                  title: specialties.first,
                  maxWidth: maxWidth * 0.52,
                ),
              ),

              if (specialties.length > 1) ...[
                SizedBox(width: SizeConfig.w(0.008)),
                _SpecialtyChip(
                  title: showSecond ? specialties[1] : '...',
                  maxWidth: showSecond ? maxWidth * 0.38 : maxWidth * 0.18,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
