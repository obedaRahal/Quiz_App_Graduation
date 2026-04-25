import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
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
            title: state.snackBarTitle ?? 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }

        if (state.verifyOtpStatus == ForgotPasswordVerifyOtpStatus.success) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'تمت العملية بنجاح',
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
            title: state.snackBarTitle ?? 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }

        if (state.resendOtpStatus == ForgotPasswordResendOtpStatus.success &&
            state.resendSuccessMessage != null) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'تمت العملية بنجاح',
            message: state.successMessage ?? 'تمت العملية بنجاح.',
            type: AppValidationSnackBarType.success,
          );
        }
      },
      builder: (context, state) {
        // return Scaffold(
        //   body: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        //     child: SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           CommonTopPartForgetPassword(
        //             title: "تأكيد البريد المدخل",
        //             bodyText:
        //                 "الرجاء ادخال الرمز المكون من ستة \nأرقام الى بريدك الخاص",
        //             img: AppImage.forgetPasswordPng2,
        //             imgHeight: SizeConfig.height * .35,
        //           ),

        //           SizedBox(height: SizeConfig.height * .04),

        //           OtpInputSection(
        //             remainingSeconds: state.remainingSeconds,
        //             onSubmit: () {
        //               context.read<ForgetPasswordCubit>().verifyOtp();
        //             },
        //             onResend: () {
        //               if (state.resendOtpStatus ==
        //                   ForgotPasswordResendOtpStatus.loading) {
        //                 return;
        //               }

        //               context
        //                   .read<ForgetPasswordCubit>()
        //                   .resendForgotPasswordOtp();
        //             },
        //             onOtpChanged: (value) {
        //               context.read<ForgetPasswordCubit>().otpChanged(value);
        //             },
        //             isSubmitting:
        //                 state.verifyOtpStatus ==
        //                     ForgotPasswordVerifyOtpStatus.loading ||
        //                 state.resendOtpStatus ==
        //                     ForgotPasswordResendOtpStatus.loading,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // );
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              SizeConfig.init(context);

              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final bottomSafe = MediaQuery.of(context).padding.bottom;
              final isKeyboardOpen = keyboardHeight > 0;

              final isSmall =
                  SizeConfig.isSmallPhone || SizeConfig.height < 700;

              final horizontalPadding = SizeConfig.sw(isSmall ? 0.04 : 0.045);
              final topGap = SizeConfig.sh(isSmall ? 0.014 : 0.03);
              final sectionGap = SizeConfig.sh(isSmall ? 0.025 : 0.04);

              final buttonBottomPadding = bottomSafe + 20;
              final buttonAreaHeight = 82.0 + buttonBottomPadding;

              return Stack(
                children: [
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 230),
                    curve: Curves.easeOut,
                    offset: isKeyboardOpen
                        ? const Offset(0, -0.19)
                        : Offset.zero,
                    child: SafeArea(
                      bottom: false,
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: isKeyboardOpen
                            ? const BouncingScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top: topGap,
                          bottom: isKeyboardOpen
                              ? keyboardHeight + 40
                              : buttonAreaHeight,
                        ),
                        child: SizedBox(
                          height: isKeyboardOpen
                              ? null
                              : constraints.maxHeight - buttonAreaHeight,
                          child: Column(
                            children: [
                              CommonTopPartForgetPassword(
                                title: "تأكيد البريد المدخل",
                                bodyText:
                                    "الرجاء ادخال الرمز المكون من ستة \nأرقام الى بريدك الخاص",
                                img: AppImage.forgetPasswordPng2,
                                imgHeight:
                                    SizeConfig.height * (isSmall ? .29 : .3),
                              ),

                              SizedBox(height: sectionGap),

                              OtpInputSection(
                                compact: isSmall,
                                showSubmitButton: false,
                                remainingSeconds: state.remainingSeconds,
                                onSubmit: () {
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .verifyOtp();
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
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .otpChanged(value);
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
                    ),
                  ),

                  if (!isKeyboardOpen)
                    Positioned(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: buttonBottomPadding),
                        child:
                            state.verifyOtpStatus ==
                                    ForgotPasswordVerifyOtpStatus.loading ||
                                state.resendOtpStatus ==
                                    ForgotPasswordResendOtpStatus.loading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButtonWidget(
                                width: double.infinity,
                                backgroundColor:
                                    context.appColors.primaryToPrimaryDark,
                                childHorizontalPad: SizeConfig.width * .07,
                                childVerticalPad:
                                    SizeConfig.height * (isSmall ? .009 : .012),
                                borderRadius: 10,
                                onTap: () {
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .verifyOtp();
                                },
                                child: CustomTextWidget(
                                  "تأكيد الإدخال",
                                  fontSize: SizeConfig.text(
                                    isSmall ? 0.044 : 0.055,
                                  ),
                                  color: context.colorScheme.onSecondary,
                                ),
                              ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
