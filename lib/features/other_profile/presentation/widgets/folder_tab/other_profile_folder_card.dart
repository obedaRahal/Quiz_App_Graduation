import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/other_profile/domain/entities/other_profile_folders_entity.dart';
import 'package:quiz_app_grad/features/other_profile/presentation/manager/other_profile_cubit/other_profile_state.dart';

class OtherProfileFolderCard extends StatelessWidget {
  final OtherProfileFolderItemEntity folder;
  final VoidCallback onSaveTap;

  const OtherProfileFolderCard({
    super.key,
    required this.folder,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomBackgroundWithChild(
        width: double.infinity,
        backgroundColor: appColors.whiteToblack,
        borderRadius: BorderRadius.circular(14),
        padding: EdgeInsets.symmetric(
          //horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.012),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _FolderImage(),
            ColoredFolderSvg(
              assetPath: AppImage.folderIcon,
              topColor: _parseHexColor(folder.colorCode),
              width: SizeConfig.w(0.16),
              height: SizeConfig.w(0.16),
            ),

            SizedBox(width: SizeConfig.w(0.03)),

            Expanded(child: _FolderInfo(folder: folder)),

            SizedBox(width: SizeConfig.w(0.02)),

            _SaveButton(isSaved: folder.viewerHasBookmarked, onTap: onSaveTap),
          ],
        ),
      ),
    );
  }

  Color _parseHexColor(String value, {Color fallback = AppPalette.greyMedium}) {
    var hex = value.trim();

    if (hex.isEmpty) return fallback;

    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }

    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    final colorValue = int.tryParse(hex, radix: 16);
    if (colorValue == null) return fallback;

    return Color(colorValue);
  }
}

class ColoredFolderSvg extends StatelessWidget {
  final String assetPath;
  final Color topColor;
  final double width;
  final double height;

  const ColoredFolderSvg({
    super.key,
    required this.assetPath,
    required this.topColor,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadColoredSvg(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: width, height: height);
        }

        return SvgPicture.string(
          snapshot.data!,
          width: width,
          height: height,
          fit: BoxFit.contain,
        );
      },
    );
  }

  Future<String> _loadColoredSvg() async {
    final rawSvg = await rootBundle.loadString(assetPath);

    return rawSvg.replaceAll('__TOP_COLOR__', _colorToHex(topColor));
  }

  String _colorToHex(Color color) {
    final red = color.red.toRadixString(16).padLeft(2, '0');
    final green = color.green.toRadixString(16).padLeft(2, '0');
    final blue = color.blue.toRadixString(16).padLeft(2, '0');

    return '#$red$green$blue'.toUpperCase();
  }
}

class _FolderInfo extends StatelessWidget {
  final OtherProfileFolderItemEntity folder;

  const _FolderInfo({required this.folder});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          folder.name,
          color: appColors.blackToGrey2Dark,
          fontFamily: AppFont.elMessiriBold,
          fontSize: SizeConfig.text(0.038),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),

        SizedBox(height: SizeConfig.h(0.004)),

        Row(
          textDirection: TextDirection.rtl,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: _SmallInfo(
                svgIcon: AppImage.feather,
                text: '${folder.testsCount} اختبارات',
                maxTextWidth: SizeConfig.w(0.22),
              ),
            ),

            SizedBox(width: SizeConfig.w(0.025)),

            Flexible(
              child: _SmallInfo(
                svgIcon: AppImage.timer,
                text: folder.publishedAt,
                maxTextWidth: SizeConfig.w(0.28),
              ),
            ),
          ],
        ),

        SizedBox(height: SizeConfig.h(0.008)),

        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            height: SizeConfig.h(0.026),
            child: ListView.separated(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: folder.scientificInterests.length,
              separatorBuilder: (_, __) => SizedBox(width: SizeConfig.w(0.012)),
              itemBuilder: (context, index) {
                final tag = folder.scientificInterests[index];

                return CustomBackgroundWithChild(
                  backgroundColor: AppPalette.primarySoft,
                  borderRadius: BorderRadius.circular(5),
                  childHorizontalPad: SizeConfig.w(0.018),
                  childVerticalPad: SizeConfig.h(0.002),
                  child: CustomTextWidget(
                    '# $tag',
                    color: appColors.primaryToPrimaryDark,
                    fontSize: SizeConfig.text(0.023),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallInfo extends StatelessWidget {
  final String svgIcon;
  final String text;
  final double maxTextWidth;

  const _SmallInfo({
    required this.svgIcon,
    required this.text,
    required this.maxTextWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        CustomAppImage(
          path: svgIcon,
          width: SizeConfig.w(0.035),
          height: SizeConfig.w(0.035),
          color: AppPalette.black,
        ),

        SizedBox(width: SizeConfig.w(0.006)),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxTextWidth),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: CustomTextWidget(
                text,
                color: AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.027),
                maxLines: 1,
                overflow: TextOverflow.visible,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        ),
      ],
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
        padding: EdgeInsets.all(SizeConfig.w(0.01)),
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
