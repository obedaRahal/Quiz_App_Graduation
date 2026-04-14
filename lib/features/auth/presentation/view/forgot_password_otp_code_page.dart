import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/common_top_part_forget_password.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/otp_input_section.dart';

class ForgotPasswordOtpCodePage extends StatelessWidget {
  const ForgotPasswordOtpCodePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                builder: (context, state) {
                  return OtpInputSection(
                    // isSubmitting: state.isSubmitting,
                    remainingSeconds: state.remainingSeconds,
                    // onOtpChanged: (value) =>
                    //     context.read<VerifyRegisterCubit>().otpChanged(value),
                    onSubmit: () {
                      context.pushNamed(
                        AppRouterName.forgotPasswordNewPassword,
                      );

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
            ],
          ),
        ),
      ),
    );
  }
}
