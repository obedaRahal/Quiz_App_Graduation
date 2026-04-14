import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/tow_text_row.dart';

class OtpInputSection extends StatelessWidget {
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onSubmit;
  final VoidCallback onResend;
  final bool isSubmitting;
  final int remainingSeconds;
  final String buttonText;

  const OtpInputSection({
    super.key,
    required this.onOtpChanged,
    required this.onSubmit,
    required this.onResend,
    required this.isSubmitting,
    required this.remainingSeconds,
    this.buttonText = "تأكيد الإدخال",
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(1, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              "ادخل الرمز",
              color: isDark ? AppPalette.titleWhiteINDark : AppPalette.black,
            ),
            CustomTextWidget(
              "$minutes:$seconds",
              color: appColors.primaryToPrimaryDark,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: SizeConfig.height * .01),

        Directionality(
          textDirection: TextDirection.ltr,
          child: PinCodeTextField(
            errorTextDirection: TextDirection.rtl,
            appContext: context,
            length: 6,
            textStyle: TextStyle(
              fontSize: SizeConfig.height * .025,
              color: isDark ? AppPalette.titleWhiteINDark : AppPalette.black,
              fontFamily: AppFont.reemKufi,
            ),
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              fieldHeight: SizeConfig.height * .075,
              fieldWidth: SizeConfig.height * .068,
              activeFillColor: isDark
                  ? AppPalette.greyMediumDark
                  : AppPalette.greyBorder,
              selectedFillColor: isDark
                  ? AppPalette.greyMediumDark
                  : AppPalette.greyBorder,
              inactiveFillColor: isDark
                  ? AppPalette.greyMediumDark
                  : AppPalette.greyBorder,
              inactiveColor: isDark
                  ? AppPalette.greyMediumDark
                  : AppPalette.primarySoft,
              selectedColor: appColors.primaryToPrimaryDark,
              activeColor: appColors.primaryToPrimaryDark,
              errorBorderColor: Colors.red,
            ),
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            onChanged: onOtpChanged,
            validator: (value) {
              if (value == null || value.length != 6) {
                return 'أدخل الرمز المؤلف من 6 أرقام';
              }
              return null;
            },
          ),
        ),

        SizedBox(height: SizeConfig.height * .04),
        TowTextRow(
          text: "لم تستلم رمز بعد ؟ ",
          actionText: "إعادة ارسال الرمز",
          onTap: onResend,
        ),
        SizedBox(height: SizeConfig.height * .04),
        isSubmitting
            ? const Center(child: CircularProgressIndicator())
            : CustomButtonWidget(
                width: double.infinity,
                backgroundColor: appColors.primaryToPrimaryDark,
                childHorizontalPad: SizeConfig.width * .07,
                childVerticalPad: SizeConfig.height * .012,
                borderRadius: 10,
                onTap: onSubmit,
                child: CustomTextWidget(
                  buttonText,
                  fontSize: SizeConfig.height * .025,
                  color: colorScheme.onSecondary,
                ),
              ),
      ],
    );
  }
}
