import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';

import '../../../../core/theme/assets/fonts.dart';
import '../../../../core/theme/color/app_colors.dart';
import '../../../../core/utils/media_query_config.dart';


class OnboardingImagePickerField extends StatelessWidget {
  final String title;
  final String hintText;
  final String? imagePath;
  final VoidCallback onTap;

  const OnboardingImagePickerField({
    super.key,
    required this.title,
    required this.hintText,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    final borderColor = hasImage ? AppPalette.primary : AppPalette.greyLight;
    final backgroundColor = hasImage ? AppPalette.primarySoft : AppPalette.grey;
    final iconColor = hasImage ? AppPalette.primary : AppPalette.greyMedium;
    final textColor = hasImage ? AppPalette.primary : AppPalette.greyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextWidget(
          title,
          color: AppPalette.black,
          fontSize: SizeConfig.text(0.045),
          fontFamily: AppFont.elMessiriSemiBold,
        ),
        SizedBox(height: SizeConfig.h(0.005)),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(0.035),
              vertical: SizeConfig.h(0.012),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: borderColor,
                width: hasImage ? 1.6 : 1.2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: iconColor,
                  size: 20,
                ),
                SizedBox(width: SizeConfig.w(0.03)),
                Expanded(
                  child: CustomTextWidget(
                    hasImage ? 'تم إرفاق الصورة بنجاح' : hintText,
                    textAlign: TextAlign.right,
                    color: textColor,
                    fontSize: SizeConfig.text(0.03),
                  ),
                ),
                if (hasImage) ...[
                  SizedBox(width: SizeConfig.w(0.02)),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showImagePreview(context, imagePath!),
                    child: Container(
                      padding: EdgeInsets.all(SizeConfig.w(0.015)),
                      decoration: BoxDecoration(
                        color: AppPalette.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppPalette.primary,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: AppPalette.primary,
                        size: 18,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(0.02)),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _showImagePreview(context, imagePath!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePath!),
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            width: 44,
                            height: 44,
                            color: AppPalette.white,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: AppPalette.greyMedium,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePreview(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return SizedBox(
                        height: 220,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppPalette.greyMedium,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20),
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
}