import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart'
    show CustomButtonWidget;
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/common_top_part_forget_password.dart';

class ForgotPasswordEmailPage extends StatelessWidget {
  const ForgotPasswordEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final cubit = context.read<ForgetPasswordCubit>();

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) {
        return previous.requestOtpStatus != current.requestOtpStatus;
      },
      listener: (context, state) {
        if (state.requestOtpStatus == ForgotPasswordRequestOtpStatus.failure &&
            state.errorMessage != null) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'خطأ',
            message: state.errorMessage ?? 'حدث خطأ ما.',
            type: AppValidationSnackBarType.error,
          );
        }

        if (state.requestOtpStatus == ForgotPasswordRequestOtpStatus.success) {
          showValidationTopSnackBar(
            context,
            title: state.snackBarTitle ?? 'تمت العملية بنجاح',
            message: state.successMessage ?? 'تمت العملية بنجاح.',
            type: AppValidationSnackBarType.success,
          );

          context.pushNamed(
            AppRouterName.forgotPasswordOtpCode,
            extra: {
              'email': context
                  .read<ForgetPasswordCubit>()
                  .emailController
                  .text
                  .trim(),
            },
          );
        }
      },
      builder: (context, state) {
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
              final sectionGap = SizeConfig.sh(isSmall ? 0.03 : 0.06);

              final buttonBottomPadding = bottomSafe + 20;
              final buttonAreaHeight = 82.0 + buttonBottomPadding;

              return Stack(
                children: [
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 230),
                    curve: Curves.easeOut,
                    offset: isKeyboardOpen
                        ? const Offset(0, -0.16)
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
                                title: "نسيت كلمة المرور ؟",
                                bodyText:
                                    "يرجى ادخال عنوان بريدك\n الالكتروني لتتلقى رمز التحقق عليه",
                                img: AppImage.forgetPassword1,
                                imgHeight: SizeConfig.height * .27,
                              ),

                              SizedBox(height: sectionGap),

                              AuthFieldLabel(
                                label: 'البريد الالكتروني',
                                controller: cubit.emailController,
                                hint: 'ادخل بريدك الالكتروني...',
                                keyboardType: TextInputType.emailAddress,
                                suffixIcon: Icons.email_outlined,
                                compact: isSmall,
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
                        child: CustomButtonWidget(
                          width: double.infinity,
                          backgroundColor: appColors.primaryToPrimaryDark,
                          childHorizontalPad: SizeConfig.width * .07,
                          childVerticalPad:
                              SizeConfig.height * (isSmall ? .009 : .012),
                          borderRadius: 8,
                          onTap: () {
                            if (state.requestOtpStatus ==
                                ForgotPasswordRequestOtpStatus.loading) {
                              return;
                            }

                            context.read<ForgetPasswordCubit>().requestOtp();
                          },
                          child:
                              state.requestOtpStatus ==
                                  ForgotPasswordRequestOtpStatus.loading
                              ? SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onSecondary,
                                  ),
                                )
                              : CustomTextWidget(
                                  "تأكيد الإدخال",
                                  fontSize: SizeConfig.text(
                                    isSmall ? 0.045 : 0.055,
                                  ),
                                  color: colorScheme.onSecondary,
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