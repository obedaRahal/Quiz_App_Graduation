// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart'
//     show CustomButtonWidget;
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/config/app_router_name.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
// import 'package:quiz_app_grad/features/auth/presentation/widget/common_top_part_forget_password.dart';

// class ForgotPasswordEmailPage extends StatelessWidget {
//   const ForgotPasswordEmailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = context.colorScheme;
//     final appColors = context.appColors;
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               CommonTopPartForgetPassword(
//                 title: "نسيت كلمة المرور ؟",
//                 bodyText:
//                     "يرجى ادخال عنوان بريدك\n الالكتروني لتتلقى رمز التحقق عليه",
//                 img: AppImage.forgetPassword1,
//                 imgHeight: SizeConfig.height * .27,
//               ),
//               SizedBox(height: SizeConfig.height * .08),
//               AuthFieldLabel(
//                 label: 'البريد الالكتروني',
//                 hint: 'ادخل بريدك الالكتروني...',
//                 keyboardType: TextInputType.emailAddress,
//                 suffixIcon: Icons.email_outlined,
//               ),
//               SizedBox(height: SizeConfig.height * .099),
//               CustomButtonWidget(
//                 width: double.infinity,
//                 backgroundColor: appColors.primaryToPrimaryDark,
//                 childHorizontalPad: SizeConfig.width * .07,
//                 childVerticalPad: SizeConfig.height * .012,
//                 borderRadius: 8,
//                 onTap: () {
//                   context.pushNamed(AppRouterName.forgotPasswordOtpCode);

//                   // debugPrint(" verify Email ");
//                 },
//                 child: CustomTextWidget(
//                   "تأكيد الإدخال",
//                   fontSize: SizeConfig.text(0.055),
//                   color: colorScheme.onSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart'
    show CustomButtonWidget;
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.requestOtpStatus == ForgotPasswordRequestOtpStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.successMessage ?? 'تم إرسال رمز التحقق بنجاح.',
              ),
              backgroundColor: Colors.green,
            ),
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CommonTopPartForgetPassword(
                    title: "نسيت كلمة المرور ؟",
                    bodyText:
                        "يرجى ادخال عنوان بريدك\n الالكتروني لتتلقى رمز التحقق عليه",
                    img: AppImage.forgetPassword1,
                    imgHeight: SizeConfig.height * .27,
                  ),

                  SizedBox(height: SizeConfig.height * .08),

                  AuthFieldLabel(
                    label: 'البريد الالكتروني',
                    controller: cubit.emailController,
                    hint: 'ادخل بريدك الالكتروني...',
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icons.email_outlined,
                  ),

                  SizedBox(height: SizeConfig.height * .099),

                  CustomButtonWidget(
                    width: double.infinity,
                    backgroundColor: appColors.primaryToPrimaryDark,
                    childHorizontalPad: SizeConfig.width * .07,
                    childVerticalPad: SizeConfig.height * .012,
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
                            fontSize: SizeConfig.text(0.055),
                            color: colorScheme.onSecondary,
                          ),
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
