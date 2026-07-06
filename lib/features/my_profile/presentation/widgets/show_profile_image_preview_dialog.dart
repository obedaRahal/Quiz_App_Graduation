import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

Future<void> showMyProfileImagePreviewDialog({
  required BuildContext context,
  required String imagePath,
  required Future<bool> Function() onSubmit,
  required VoidCallback onChangeImage,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return _MyProfileImagePreviewDialog(
        imagePath: imagePath,
        onSubmit: onSubmit,
        onChangeImage: onChangeImage,
      );
    },
  );
}

class _MyProfileImagePreviewDialog extends StatefulWidget {
  final String imagePath;
  final Future<bool> Function() onSubmit;
  final VoidCallback onChangeImage;

  const _MyProfileImagePreviewDialog({
    required this.imagePath,
    required this.onSubmit,
    required this.onChangeImage,
  });

  @override
  State<_MyProfileImagePreviewDialog> createState() =>
      _MyProfileImagePreviewDialogState();
}

class _MyProfileImagePreviewDialogState
    extends State<_MyProfileImagePreviewDialog> {
  bool isSubmitting = false;

  Future<void> _submit() async {
    if (isSubmitting) return;

    setState(() => isSubmitting = true);

    final success = await widget.onSubmit();

    if (!mounted) return;

    setState(() => isSubmitting = false);

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(SizeConfig.w(0.04)),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.w(0.035)),
        decoration: BoxDecoration(
          color: AppPalette.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(widget.imagePath),
                height: SizeConfig.h(0.34),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: SizeConfig.h(0.018)),

            Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    onTap: isSubmitting ? () {} : _submit,
                    backgroundColor: AppPalette.primary,
                    borderRadius: 8,
                    childVerticalPad: SizeConfig.h(0.01),
                    child: isSubmitting
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppPalette.white,
                          )
                        : CustomTextWidget(
                            'إرسال',
                            color: AppPalette.white,
                            fontFamily: AppFont.elMessiriBold,
                          ),
                  ),
                ),
                SizedBox(width: SizeConfig.w(0.02)),
                Expanded(
                  child: CustomButtonWidget(
                    onTap: isSubmitting ? () {} : widget.onChangeImage,
                    backgroundColor: AppPalette.greyLight,
                    borderRadius: 8,
                    childVerticalPad: SizeConfig.h(0.01),
                    child: CustomTextWidget(
                      'تغيير الصورة',
                      color: AppPalette.greyMedium,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(0.01)),

            CustomButtonWidget(
              width: double.infinity,
              onTap: isSubmitting ? () {} : () => Navigator.pop(context),
              backgroundColor: AppPalette.greyLight,
              borderRadius: 8,
              childVerticalPad: SizeConfig.h(0.01),
              child: CustomTextWidget(
                'إلغاء',
                color: AppPalette.greyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}