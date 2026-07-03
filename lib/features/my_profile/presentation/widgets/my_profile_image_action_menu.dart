import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

enum MyProfileImageAction {
  camera,
  gallery,
  view,
  delete,
}

Future<void> showMyProfileImageActionMenu({
  required BuildContext context,
  required String title,
  required bool hasCurrentImage,
  required VoidCallback onCamera,
  required VoidCallback onGallery,
  required VoidCallback onView,
  required VoidCallback onDelete,
}) async {
  final appColors = context.appColors;

  final selectedAction = await showMenu<MyProfileImageAction>(
    context: context,
    color: appColors.whiteToblack,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: appColors.primaryToPrimaryDark,
        width: 1.4,
      ),
    ),
    position: RelativeRect.fromLTRB(
      SizeConfig.w(0.1),
      SizeConfig.h(0.4),
      SizeConfig.w(0.09),
      0,
    ),
    items: [
      PopupMenuItem<MyProfileImageAction>(
        enabled: false,
        height: SizeConfig.h(0.045),
        padding: EdgeInsets.zero,
        child: _ImageMenuTitle(title: title),
      ),

      _divider(),

      PopupMenuItem<MyProfileImageAction>(
        value: MyProfileImageAction.camera,
        height: SizeConfig.h(0.042),
        padding: EdgeInsets.zero,
        child: const _ImageMenuItem(
          title: 'التقاط صورة من الكاميرا الخاصة بك',
          icon: Icons.camera_alt_outlined,
          color: AppPalette.greyMedium,
        ),
      ),

      _divider(),

      PopupMenuItem<MyProfileImageAction>(
        value: MyProfileImageAction.gallery,
        height: SizeConfig.h(0.042),
        padding: EdgeInsets.zero,
        child: const _ImageMenuItem(
          title: 'تحميل صورة من الاستديو',
          icon: Icons.file_upload_outlined,
          color: AppPalette.greyMedium,
        ),
      ),

      if (hasCurrentImage) ...[
        _divider(),

        PopupMenuItem<MyProfileImageAction>(
          value: MyProfileImageAction.view,
          height: SizeConfig.h(0.042),
          padding: EdgeInsets.zero,
          child: const _ImageMenuItem(
            title: 'عرض الصورة الحالية',
            icon: Icons.image_outlined,
            color: AppPalette.greyMedium,
          ),
        ),

        _divider(),

        PopupMenuItem<MyProfileImageAction>(
          value: MyProfileImageAction.delete,
          height: SizeConfig.h(0.042),
          padding: EdgeInsets.zero,
          child: const _ImageMenuItem(
            title: 'حذف الصورة الحالية',
            icon: Icons.delete_outline_rounded,
            color: AppPalette.red,
          ),
        ),
      ],
    ],
  );

  if (selectedAction == null) {
    debugPrint('→ image action menu dismissed');
    return;
  }

  switch (selectedAction) {
    case MyProfileImageAction.camera:
      onCamera();
      break;
    case MyProfileImageAction.gallery:
      onGallery();
      break;
    case MyProfileImageAction.view:
      onView();
      break;
    case MyProfileImageAction.delete:
      onDelete();
      break;
  }
}

PopupMenuItem<MyProfileImageAction> _divider() {
  return PopupMenuItem<MyProfileImageAction>(
    enabled: false,
    height: 2,
    padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.018)),
    child: Container(
      height: 1,
      color: AppPalette.greyBorderCart,
    ),
  );
}

class _ImageMenuTitle extends StatelessWidget {
  final String title;

  const _ImageMenuTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.w(0.72),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.008),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: CustomTextWidget(
            title,
            color: context.appColors.blackTogreyMedium,
            fontFamily: AppFont.elMessiriBold,
            fontSize: SizeConfig.text(0.032),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}

class _ImageMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _ImageMenuItem({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.w(0.72),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.03),
          vertical: SizeConfig.h(0.006),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              icon,
              color: color,
              size: SizeConfig.w(0.05),
            ),
            SizedBox(width: SizeConfig.w(0.025)),
            Expanded(
              child: CustomTextWidget(
                title,
                color: color,
                fontSize: SizeConfig.text(0.03),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}