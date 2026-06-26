import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LibraryCreateContentBottomSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;

  const LibraryCreateContentBottomSheet({
    super.key,
    required this.onCamera,
    required this.onGallery,
    required this.onFile,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onCamera,
    required VoidCallback onGallery,
    required VoidCallback onFile,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppPalette.black.withOpacity(0.18),
      isScrollControlled: true,
      builder: (_) {
        return LibraryCreateContentBottomSheet(
          onCamera: onCamera,
          onGallery: onGallery,
          onFile: onFile,
        );
      },
    );
  }

  static void _showImagesSourceSheet(
    BuildContext context, {
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: AppPalette.black.withOpacity(0.18),
      isScrollControlled: true,
      builder: (_) {
        return _LibrarySheetContainer(
          title: 'اختر مصدر الصور',
          children: [
            _BottomSheetOption(
              title: 'التقاط صورة من الكاميرا',
              icon: Icons.photo_camera_outlined,
              onTap: onCamera,
            ),
            const _SheetDivider(),
            _BottomSheetOption(
              title: 'اختيار من صورة إلى 3 صور من الاستديو',
              icon: Icons.photo_library_outlined,
              onTap: onGallery,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _LibrarySheetContainer(
      title: 'اختر نوع المحتوى الذي تريد إنشاءه',
      children: [
        _BottomSheetOption(
          title: 'صور مجمعة من صورة إلى 3 صور',
          icon: Icons.image_outlined,
          onTap: () {
            Future.microtask(() {
              _showImagesSourceSheet(
                context,
                onCamera: onCamera,
                onGallery: onGallery,
              );
            });
          },
        ),
        const _SheetDivider(),
        _BottomSheetOption(
          title: 'ملف واحد من ملفاتي',
          icon: Icons.file_upload_outlined,
          onTap: onFile,
        ),
      ],
    );
  }
}

class _LibrarySheetContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _LibrarySheetContainer({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.w(0.035),
          right: SizeConfig.w(0.035),
          bottom: SizeConfig.h(0.030),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppPalette.fieldColorNDark : AppPalette.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.20),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: SizeConfig.h(0.018)),
              CustomTextWidget(
                title,
                color: isDark
                    ? AppPalette.textWhiteINDark
                    : AppPalette.textColorInHome,
                fontSize: SizeConfig.text(0.036).clamp(13.0, 16.0).toDouble(),
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: SizeConfig.h(0.012)),
              const _SheetDivider(),
              ...children,
              SizedBox(height: SizeConfig.h(0.006)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetDivider extends StatelessWidget {
  const _SheetDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 1,
      color: isDark
          ? AppPalette.borderFieldColorNDark
          : AppPalette.greyLight,
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(0.045),
          vertical: SizeConfig.h(0.014),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: CustomTextWidget(
                title,
                textAlign: TextAlign.right,
                color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
                fontSize: SizeConfig.text(0.030).clamp(11.0, 14.0).toDouble(),
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: SizeConfig.w(0.025)),
            Icon(
              icon,
              color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
              size: SizeConfig.text(0.052).clamp(18.0, 24.0).toDouble(),
            ),
          ],
        ),
      ),
    );
  }
}