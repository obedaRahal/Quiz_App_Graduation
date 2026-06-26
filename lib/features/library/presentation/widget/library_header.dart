import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/create_test/presentation/manager/create_test_cubit/create_test_initial_args.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_create_content_bottom_sheet.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_file_picker_helper.dart';
import 'package:quiz_app_grad/features/library/presentation/widget/library_gallery_picker_helper.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({super.key});

  Future<List<PlatformFile>> _pathsToPlatformFiles(List<String> paths) async {
    final files = <PlatformFile>[];

    for (final path in paths) {
      final file = File(path);

      if (!await file.exists()) continue;

      final name = path.split(RegExp(r'[\\/]+')).last;
      final size = await file.length();

      files.add(PlatformFile(name: name, size: size, path: path));
    }

    return files;
  }

  void _goToCreateContentImages({
    required BuildContext context,
    required List<PlatformFile> mediaFiles,
  }) {
    if (mediaFiles.isEmpty) return;

    context.pushNamed(
      AppRouterName.createTestPage,
      extra: CreateTestInitialArgs(
        mode: CreateTestCreationMode.contentImages,
        mediaFiles: mediaFiles,
      ),
    );
  }

  void _goToCreateContentFile({
    required BuildContext context,
    required PlatformFile file,
  }) {
    context.pushNamed(
      AppRouterName.createTestPage,
      extra: CreateTestInitialArgs(
        mode: CreateTestCreationMode.contentFile,
        mediaFiles: [file],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(0.04),
        vertical: SizeConfig.h(0.01),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: SizeConfig.h(0.055),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: CustomTextWidget(
                  'المكتبة',
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.text(0.052),
                  color: isDark
                      ? AppPalette.textWhiteINDark
                      : AppPalette.textColorInHome,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),

              InkWell(
                onTap: () {
                  LibraryCreateContentBottomSheet.show(
                    context,
                    onCamera: () async {
                      final images =
                          await LibraryImagePickerHelper.captureImagesFromCamera(
                            context,
                          );

                      if (images.isEmpty) {
                        debugPrint('لم يتم التقاط صور');
                        return;
                      }

                      final mediaFiles = await _pathsToPlatformFiles(images);

                      if (!context.mounted) return;

                      _goToCreateContentImages(
                        context: context,
                        mediaFiles: mediaFiles,
                      );
                    },
                    onGallery: () async {
                      final images =
                          await LibraryImagePickerHelper.pickImagesFromGallery();

                      if (images.isEmpty) {
                        debugPrint('لم يتم اختيار صور');
                        return;
                      }

                      final mediaFiles = await _pathsToPlatformFiles(images);

                      if (!context.mounted) return;

                      _goToCreateContentImages(
                        context: context,
                        mediaFiles: mediaFiles,
                      );
                    },
                    // onFile: () async {
                    //   final file =
                    //       await LibraryFilePickerHelper.pickSingleFile();

                    //   if (file == null) return;
                    //   if (!context.mounted) return;

                    //   _goToCreateContentFile(
                    //     context: context,
                    //     file: file,
                    //   );
                    // },
                    onFile: () async {
                      debugPrint('============ ON FILE TAP ============');

                      final file =
                          await LibraryFilePickerHelper.pickSingleFile();

                      if (file == null) {
                        debugPrint('file is null');
                        return;
                      }

                      debugPrint('تم اختيار الملف: ${file.name}');

                      if (!context.mounted) return;

                      context.pushNamed(
                        AppRouterName.createTestPage,
                        extra: CreateTestInitialArgs(
                          mode: CreateTestCreationMode.contentFile,
                          mediaFiles: [file],
                        ),
                      );
                    },
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: SizeConfig.w(0.095),
                  height: SizeConfig.w(0.095),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppPalette.fieldColorNDark
                        : const Color(0xFFF6F6F6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppPalette.borderFieldColorNDark
                          : AppPalette.borderFieldColorNLight,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    size: SizeConfig.text(0.045),
                    color: isDark
                        ? AppPalette.textWhiteINDark
                        : AppPalette.textColorInHome,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
