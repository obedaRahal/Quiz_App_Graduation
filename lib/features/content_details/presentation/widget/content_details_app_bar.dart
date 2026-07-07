import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/content_details/presentation/manager/other_content_details_cubit/other_content_details_cubit.dart';

class ContentDetailsAppBar extends StatelessWidget {
  final String title;
  final int currentIndex;
  final int totalCount;
  final String targetLevel;
  final bool isOwner;
  final bool isPublic;
final VoidCallback? onEditContentTap;
  const ContentDetailsAppBar({
    super.key,
  required this.title,
  required this.currentIndex,
  required this.totalCount,
  required this.targetLevel,
  required this.isOwner,
  required this.isPublic,
  this.onEditContentTap,
  });
  void _showOwnerMenu(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = Theme.of(
      context,
    ).dividerColor.withOpacity(isDark ? 0.45 : 0.9);

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width,
        kToolbarHeight + 20,
        12,
        0,
      ),
      color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: dividerColor, width: 1),
      ),
      constraints: BoxConstraints(
        minWidth: SizeConfig.w(0.46),
        maxWidth: SizeConfig.w(0.52),
      ),
      items: [
        PopupMenuItem<String>(
          value: 'edit',
          height: SizeConfig.h(0.040),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
          child: _OwnerMenuText(title: 'تعديل المحتوى', isDark: isDark),
        ),

        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          padding: EdgeInsets.zero,
          child: Divider(height: 1, thickness: 1, color: dividerColor),
        ),

        PopupMenuItem<String>(
          value: 'delete',
          height: SizeConfig.h(0.040),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.035)),
          child: _OwnerMenuText(title: 'حذف المحتوى', isDark: isDark),
        ),
      ],
    );

   switch (result) {
  case 'edit':
    onEditContentTap?.call();
    break;

  case 'delete':
    _showDeleteConfirmDialog(context);
    break;
}
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: isDark
                ? AppPalette.fieldColorNDark
                : AppPalette.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: CustomTextWidget(
              'حذف المحتوى',
              textAlign: TextAlign.right,
              color: isDark
                  ? AppPalette.textWhiteINDark
                  : AppPalette.textColorInHome,
              fontSize: SizeConfig.text(0.042),

              fontWeight: FontWeight.w700,
              fontFamily: AppFont.elMessiriRegular,
            ),
            content: CustomTextWidget(
              'هل أنت متأكد أنك تريد حذف هذا المحتوى؟',
              textAlign: TextAlign.right,
              color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
              fontSize: SizeConfig.text(0.038),

              fontFamily: AppFont.elMessiriRegular,
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: CustomTextWidget(
                  'إلغاء',
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : const Color.fromARGB(255, 64, 74, 78),
                  fontSize: SizeConfig.text(0.042),

                  fontFamily: AppFont.elMessiriRegular,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<OtherContentDetailsCubit>().deleteMyContent();
                },
                child: CustomTextWidget(
                  'حذف',
                  color: AppPalette.red,
                  fontSize: SizeConfig.text(0.042),

                  fontFamily: AppFont.elMessiriRegular,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                  onTap: () {
                    if (isOwner) {
                      _showOwnerMenu(context);
                      return;
                    }

                    // لاحقاً منضيف مشاركة المحتوى
                  },
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

class _OwnerMenuText extends StatelessWidget {
  final String title;
  final bool isDark;

  const _OwnerMenuText({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomTextWidget(
        title,
        textAlign: TextAlign.right,
        fontSize: SizeConfig.text(0.034).clamp(13.0, 16.0).toDouble(),
        color: isDark ? AppPalette.textWhiteINDark : AppPalette.textColorInHome,

        fontFamily: AppFont.elMessiriRegular,
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
