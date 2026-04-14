import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/otp_input_section.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/top_container_auth.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/tow_text_row.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopContainerAuth(
                title: 'تأكيد البريد الالكتروني',
                body:
                    'عزيزي المستخدم يرجى منك تأكيد\n بريدك الالكتروني عن طريق ادخال الرمز\n المكون من ست ارقام علما انك ستفقد\n الرمز الخاص بك في حال نفاذ الوقت',
              ),
              SizedBox(height: 25),
              CustomBackgroundWithChild(
                borderRadius: BorderRadius.circular(20),
                width: double.infinity,
                backgroundColor: isDark
                    ? AppPalette.greyMediumDark
                    : AppPalette.primarySoft,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomTextWidget(
                    "نحن نقوم باجراء احترازي فقط",
                    fontSize: SizeConfig.text(0.05),
                    color: appColors.primaryToPrimaryDark,
                  ),
                ),
              ),
              SizedBox(height: 35),
              BlocBuilder<VerifyRegisterCubit, VerifyRegisterState>(
                builder: (context, state) {
                  return OtpInputSection(
                    // isSubmitting: state.isSubmitting,
                    remainingSeconds: state.remainingSeconds,
                    // onOtpChanged: (value) =>
                    //     context.read<VerifyRegisterCubit>().otpChanged(value),
                    onSubmit: () {
                      // context.read<VerifyRegisterCubit>().submitOtp();
                      // debugPrint("verifyy confirmmmm");
                    },
                    onResend: () {
                      // debugPrint("resend codeee ");
                      // debugPrint(
                      //   "email is ${context.read<VerifyRegisterCubit>().email}",
                      // );

                      // context.read<VerifyRegisterCubit>().resendCode();
                    },
                    onOtpChanged: (String value) {},
                    isSubmitting: false,
                  );
                },
              ),
              SizedBox(height: SizeConfig.height * .04),
              CustomTextWidget(
                "من خلال تأكيد بريدك فأنت توافق على شروط",
                fontSize: SizeConfig.diagonal * .018,
                color: AppPalette.greyMedium,
              ),
              TowTextRow(
                text: " تطبيق اختباراتي، ",
                actionText: "سياسة الخصوصية",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
