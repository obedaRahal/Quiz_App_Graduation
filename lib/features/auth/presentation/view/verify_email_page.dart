// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_background_with_child.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/otp_input_section.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/top_container_auth.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/tow_text_row.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/models/onboarding_route_args.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<VerifyRegisterCubit, VerifyRegisterState>(
      // listener: (context, state) {
      //   if (state.verifyStatus == VerifyRegisterStatus.failure &&
      //       state.errorMessage != null) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: 'خطأ',
      //       message: state.errorMessage ?? 'حدث خطأ ما.',
      //       type: AppValidationSnackBarType.error,
      //     );
      //   }

      //   if (state.verifyStatus == VerifyRegisterStatus.success) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: 'نجاح',
      //       message: state.successMessage ?? 'تمت العملية بنجاح.',
      //       type: AppValidationSnackBarType.success,
      //     );

      //     context.goNamed(AppRouterName.mainLayout);
      //   }
      //   if (state.resendStatus == VerifyResendStatus.success &&
      //       state.resendSuccessMessage != null) {
      //     showValidationTopSnackBar(
      //       context,
      //       title: 'نجاح',
      //       message: state.resendSuccessMessage ?? 'تمت العملية بنجاح.',
      //       type: AppValidationSnackBarType.success,
      //     );
      //   }
      // },
      listener: (context, state) {
        if (state.verifyStatus == VerifyRegisterStatus.failure &&
            state.errorMessage != null) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }

        // if (state.verifyStatus == VerifyRegisterStatus.success) {
        //   showValidationTopSnackBar(
        //     context,
        //     title: 'نجاح',
        //     message: state.successMessage ?? 'تمت العملية بنجاح.',
        //     type: AppValidationSnackBarType.success,
        //   );

        //   context.goNamed(AppRouterName.mainLayout);
        // }

        if (state.verifyStatus == VerifyRegisterStatus.success) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'تمت العملية بنجاح',
            message: state.successMessage ?? 'تمت العملية بنجاح.',
            type: AppValidationSnackBarType.success,
          );
          final verifiedEmail = context
              .read<VerifyRegisterCubit>()
              .email
              .trim();
          if (verifiedEmail.isEmpty) {
            showValidationTopSnackBar(
              context,
              title: 'خطأ',
              message: 'تعذر تحديد البريد الإلكتروني للمتابعة.',
              type: AppValidationSnackBarType.error,
            );
            return;
          }
          debugPrint("emais is : $verifiedEmail");
          context.goNamed(
            AppRouterName.onboarding,
            extra: OnboardingRouteArgs(email: verifiedEmail),
          );
        }
        if (state.resendStatus == VerifyResendStatus.failure &&
            state.errorMessage != null) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }
        if (state.resendStatus == VerifyResendStatus.success &&
            state.resendSuccessMessage != null) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'تمت العملية بنجاح',
            message: state.resendSuccessMessage ?? 'تمت العملية بنجاح.',
            type: AppValidationSnackBarType.success,
          );
        }
      },
      builder: (context, state) {
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
                  const SizedBox(height: 25),

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

                  const SizedBox(height: 35),

                  OtpInputSection(
                    remainingSeconds: state.remainingSeconds,
                    onSubmit: () {
                      context.read<VerifyRegisterCubit>().submitVerifyEmail();
                    },
                    onResend: () {
                      if (state.resendStatus == VerifyResendStatus.loading)
                        return;
                      context.read<VerifyRegisterCubit>().resendCode();
                    },
                    onOtpChanged: (value) {
                      context.read<VerifyRegisterCubit>().otpChanged(value);
                    },
                    isSubmitting:
                        state.verifyStatus == VerifyRegisterStatus.loading,
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
      },
    );
  }
}
