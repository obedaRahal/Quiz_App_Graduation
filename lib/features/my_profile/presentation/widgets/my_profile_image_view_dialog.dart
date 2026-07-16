import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

Future<void> showMyProfileImageViewer({
  required BuildContext context,
  required String imageUrl,
}) async {
  if (imageUrl.trim().isEmpty) return;

  await showDialog(
    context: context,
    barrierColor: Colors.black87,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            CustomAppImage(path: imageUrl),
            // PhotoView(
            //   imageProvider: CustomAppImage(path: imageUrl),
            //   backgroundDecoration: const BoxDecoration(
            //     color: Colors.transparent,
            //   ),
            //   minScale: PhotoViewComputedScale.contained,
            //   maxScale: PhotoViewComputedScale.covered * 3,
            // ),

            Positioned(
              top: SizeConfig.h(0.01),
              left: SizeConfig.h(0.01),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppPalette.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}