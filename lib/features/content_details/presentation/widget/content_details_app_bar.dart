import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class ContentDetailsAppBar extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int totalCount;
  final String targetLevel;
  final bool isOwner;
  final bool isPublic;

  const ContentDetailsAppBar({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.totalCount,
    required this.targetLevel,
    required this.isOwner,
    required this.isPublic,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.045),
          vertical: SizeConfig.h(0.012),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _CircleIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.maybePop(context),
                ),

                const Spacer(),

                CustomTextWidget(
                  title,
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  fontSize: SizeConfig.text(0.045).clamp(17.0, 21.0).toDouble(),
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFont.elMessiriRegular,
                ),

                const Spacer(),

                _CircleIconButton(
                  icon: isOwner
                      ? Icons.more_vert_rounded
                      : Icons.share_outlined,
                  onTap: () {},
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(0.012)),

            Row(
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOwner) ...[
                      _SmallOutlineBadge(
                        title: isPublic ? 'محتوى عام' : 'محتوى خاص',
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: SizeConfig.w(0.012)),
                    ],

                    _SmallOutlineBadge(title: targetLevel),
                  ],
                ),
                const Spacer(),
                _SmallOutlineBadge(title: '$currentIndex/$totalCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: SizeConfig.w(0.085),
        height: SizeConfig.w(0.085),
        decoration: BoxDecoration(
          color: isDark
              ? AppPalette.fieldColorNDark.withOpacity(0.85)
              : AppPalette.white.withOpacity(0.92),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: SizeConfig.text(0.042),
          color: isDark
              ? AppPalette.textWhiteINDark
              : AppPalette.textColorInHome,
        ),
      ),
    );
  }
}

class _SmallOutlineBadge extends StatelessWidget {
  final String title;
  final Color? color;

  const _SmallOutlineBadge({required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.025),
        vertical: SizeConfig.h(0.002),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppPalette.black.withOpacity(0.28)
            : AppPalette.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
      child: CustomTextWidget(
        title,
        color: color ?? Theme.of(context).colorScheme.primary,
        fontSize: SizeConfig.text(0.027).clamp(10.0, 12.0).toDouble(),
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
