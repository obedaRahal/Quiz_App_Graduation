import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  final IconData icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  final String confirmText;
  final String cancelText;

  final Color? confirmBackgroundColor;
  final Color? confirmTextColor;

  final Color? cancelBackgroundColor;
  final Color? cancelTextColor;

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  final bool barrierDismissible;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.onCancel,
    required this.onConfirm,
    this.iconColor,
    this.iconBackgroundColor,
    this.confirmText = 'تأكيد',
    this.cancelText = 'إلغاء',
    this.confirmBackgroundColor,
    this.confirmTextColor,
    this.cancelBackgroundColor,
    this.cancelTextColor,
    this.barrierDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.055)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: SizeConfig.h(0.32)),

        child: CustomBackgroundWithChild(
          width: double.infinity,
          backgroundColor: appColors.whiteToblack,
          borderRadius: BorderRadius.circular(18),
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.w(0.045),
            vertical: SizeConfig.h(0.022),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomBackgroundWithChild(
                width: SizeConfig.w(0.13),
                height: SizeConfig.w(0.13),
                alignment: Alignment.center,
                backgroundColor:
                    iconBackgroundColor ??
                    appColors.primarySoftTogreyLightDark,
                borderRadius: BorderRadius.circular(40),
                child: Icon(
                  icon,
                  color: iconColor ?? appColors.primaryToPrimaryDark,
                  size: SizeConfig.h(0.036),
                ),
              ),

              SizedBox(height: SizeConfig.h(0.016)),

              CustomTextWidget(
                title,
                color: appColors.blackToGrey2Dark,
                fontFamily: AppFont.elMessiriBold,
                fontSize: SizeConfig.text(0.038),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),

              SizedBox(height: SizeConfig.h(0.008)),

              CustomTextWidget(
                message,
                color: AppPalette.greyMedium,
                fontFamily: AppFont.elMessiriMedium,
                fontSize: SizeConfig.text(0.027),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),

              SizedBox(height: SizeConfig.h(0.024)),

              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      borderRadius: 6,
                      childVerticalPad: SizeConfig.h(0.012),
                      backgroundColor:
                          confirmBackgroundColor ??
                          appColors.primaryToPrimaryDark,
                      onTap: onConfirm,
                      child: CustomTextWidget(
                        confirmText,
                        color: confirmTextColor ?? AppPalette.white,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.03),
                      ),
                    ),
                  ),

                  SizedBox(width: SizeConfig.w(0.04)),

                  Expanded(
                    child: CustomButtonWidget(
                      borderRadius: 6,
                      childVerticalPad: SizeConfig.h(0.012),
                      backgroundColor:
                          cancelBackgroundColor ??
                          appColors.greyToGreyMediumDark,
                      onTap: onCancel,
                      child: CustomTextWidget(
                        cancelText,
                        color: cancelTextColor ?? appColors.blackToGrey2Dark,
                        fontFamily: AppFont.elMessiriBold,
                        fontSize: SizeConfig.text(0.03),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required VoidCallback onConfirm,
  String confirmText = 'تأكيد',
  String cancelText = 'إلغاء',
  Color? iconColor,
  Color? iconBackgroundColor,
  Color? confirmBackgroundColor,
  Color? confirmTextColor,
  Color? cancelBackgroundColor,
  Color? cancelTextColor,
  bool barrierDismissible = false,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      return CustomConfirmationDialog(
        title: title,
        message: message,
        icon: icon,
        iconColor: iconColor,
        iconBackgroundColor: iconBackgroundColor,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmBackgroundColor: confirmBackgroundColor,
        confirmTextColor: confirmTextColor,
        cancelBackgroundColor: cancelBackgroundColor,
        cancelTextColor: cancelTextColor,
        barrierDismissible: barrierDismissible,
        onCancel: () => Navigator.of(dialogContext).pop(),
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          onConfirm();
        },
      );
    },
  );
}
