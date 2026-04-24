import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/common_top_part_forget_password.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/otp_input_section.dart';

class ForgotPasswordOtpCodePage extends StatelessWidget {
  const ForgotPasswordOtpCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) {
        return previous.verifyOtpStatus != current.verifyOtpStatus ||
            previous.resendOtpStatus != current.resendOtpStatus;
      },
      listener: (context, state) {
        if (state.verifyOtpStatus == ForgotPasswordVerifyOtpStatus.failure &&
            state.errorMessage != null) {
          showValidationTopSnackBar(
            context,
            title: 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }

        if (state.verifyOtpStatus == ForgotPasswordVerifyOtpStatus.success) {
          showValidationTopSnackBar(
            context,
            title: 'نجاح',
            message: state.successMessage ?? 'تمت العملية بنجاح.',
            type: AppValidationSnackBarType.success,
          );

          context.goNamed(
            AppRouterName.forgotPasswordNewPassword,
            extra: {
              'email': context.read<ForgetPasswordCubit>().email,
              'otpCode': state.otpCode,
            },
          );
        }
        if (state.resendOtpStatus == ForgotPasswordResendOtpStatus.failure &&
            state.errorMessage != null) {
          showValidationTopSnackBar(
            context,
            title: 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }

        if (state.resendOtpStatus == ForgotPasswordResendOtpStatus.success &&
            state.resendSuccessMessage != null) {
          showValidationTopSnackBar(
            context,
            title: 'نجاح',
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
                  CommonTopPartForgetPassword(
                    title: "تأكيد البريد المدخل",
                    bodyText:
                        "الرجاء ادخال الرمز المكون من ستة \nأرقام الى بريدك الخاص",
                    img: AppImage.forgetPassword2,
                    imgHeight: SizeConfig.height * .3,
                  ),

                  SizedBox(height: SizeConfig.height * .04),

                  OtpInputSection(
                    remainingSeconds: state.remainingSeconds,
                    onSubmit: () {
                      context.read<ForgetPasswordCubit>().verifyOtp();
                    },
                    onResend: () {
                      if (state.resendOtpStatus ==
                          ForgotPasswordResendOtpStatus.loading) {
                        return;
                      }

                      context
                          .read<ForgetPasswordCubit>()
                          .resendForgotPasswordOtp();
                    },
                    onOtpChanged: (value) {
                      context.read<ForgetPasswordCubit>().otpChanged(value);
                    },
                    isSubmitting:
                        state.verifyOtpStatus ==
                            ForgotPasswordVerifyOtpStatus.loading ||
                        state.resendOtpStatus ==
                            ForgotPasswordResendOtpStatus.loading,
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
