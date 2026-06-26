import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class LibraryImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<String>> pickImagesFromGallery() async {
    try {
      final images = await _picker.pickMultiImage(imageQuality: 90, limit: 3);

      return images.map((image) => image.path).toList();
    } catch (error) {
      debugPrint('pickImagesFromGallery error: $error');
      return [];
    }
  }

  static Future<List<String>> captureImagesFromCamera(
    BuildContext context,
  ) async {
    final capturedImages = <String>[];

    try {
      while (capturedImages.length < 3) {
        final image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 90,
          preferredCameraDevice: CameraDevice.rear,
        );

        if (image == null) break;

        // هون لاحقاً منضيف معالجة قص الورقة وإزالة الخلفية
        final processedImagePath = await _processCapturedDocumentImage(
          image.path,
        );

        capturedImages.add(processedImagePath);

        if (capturedImages.length >= 3) break;

        final shouldCaptureMore = await _askToCaptureMore(
          context,
          currentCount: capturedImages.length,
        );

        if (!shouldCaptureMore) break;
      }

      return capturedImages;
    } catch (error) {
      debugPrint('captureImagesFromCamera error: $error');
      return capturedImages;
    }
  }

  static Future<String> _processCapturedDocumentImage(String imagePath) async {
    // حالياً بيرجع الصورة كما هي.
    // قص حدود الورقة وإزالة الخلفية يحتاج Document Scanner / OpenCV / Backend.
    return imagePath;
  }

  static Future<bool> _askToCaptureMore(
    BuildContext context, {
    required int currentCount,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark
              ? AppPalette.fieldColorNDark
              : AppPalette.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: CustomTextWidget(
            'التقاط صورة أخرى؟',
            color: isDark
                ? AppPalette.textWhiteINDark
                : AppPalette.textColorInHome,
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.text(0.038),
          ),
          content: CustomTextWidget(
            'تم التقاط $currentCount من أصل 3 صور.\nهل تريد التقاط صورة إضافية؟',
            textAlign: TextAlign.right,
            color: isDark ? AppPalette.grey2Dark : AppPalette.greyMedium,
            fontSize: SizeConfig.text(0.034),
            fontWeight: FontWeight.w500,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: CustomTextWidget(
                'لا',
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.text(0.032),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: CustomTextWidget(
                'نعم',
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.text(0.032),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
