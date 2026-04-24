// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
// import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
// import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';
// import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
// import 'package:quiz_app_grad/features/auth/presentation/widget/common_top_part_forget_password.dart';

// class ForgotPasswordNewPasswordPage extends StatelessWidget {
//   const ForgotPasswordNewPasswordPage({super.key});

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
//                 title: "انشاء كلمة مرور جديدة",
//                 bodyText: "يجب أن تكون كلمة المرور الجديدة\n مختلفة عن السابقة",
//                 img: AppImage.forgetPassword3,
//                 imgHeight: SizeConfig.height * .3,
//               ),

//               SizedBox(height: SizeConfig.height * .04),
//               BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
//                 builder: (context, state) {
//                   return AuthFieldLabel(
//                     label: 'كلمة المرور',
//                     hint: 'ادخل كلمة المرور الجديدة...',
//                     suffixIcon: state.isPasswordObscure
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                     obscureText: state.isPasswordObscure,
//                     onSuffixTap: () {
//                       context
//                           .read<ForgetPasswordCubit>()
//                           .togglePasswordVisibility();
//                     },
//                   );
//                 },
//               ),
//               SizedBox(height: SizeConfig.height * .03),
//               BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
//                 builder: (context, state) {
//                   return AuthFieldLabel(
//                     label: 'تأكيد كلمة المرور',
//                     hint: 'ادخل كلمة المرور مرة أخرة...',
//                     suffixIcon: state.isPasswordObscure
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                     obscureText: state.isPasswordObscure,
//                     onSuffixTap: () {
//                       context
//                           .read<ForgetPasswordCubit>()
//                           .togglePasswordVisibility();
//                     },
//                   );
//                 },
//               ),
//               SizedBox(height: 40),
//               CustomButtonWidget(
//                 width: double.infinity,
//                 backgroundColor: appColors.primaryToPrimaryDark,
//                 childHorizontalPad: SizeConfig.width * .07,
//                 childVerticalPad: SizeConfig.height * .012,
//                 borderRadius: 8,
//                 onTap: () {},
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
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/common_top_part_forget_password.dart';

class ForgotPasswordNewPasswordPage extends StatelessWidget {
  const ForgotPasswordNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final appColors = context.appColors;
    final cubit = context.read<ForgetPasswordCubit>();

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (previous, current) {
        return previous.resetStatus != current.resetStatus;
      },
      listener: (context, state) {
        if (state.resetStatus == ForgotPasswordResetStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state.resetStatus == ForgotPasswordResetStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.resetSuccessMessage ??
                    'تم إعادة تعيين كلمة المرور بنجاح.',
              ),
              backgroundColor: Colors.green,
            ),
          );

          context.goNamed(AppRouterName.login);
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
                    title: "انشاء كلمة مرور جديدة",
                    bodyText:
                        "يجب أن تكون كلمة المرور الجديدة\n مختلفة عن السابقة",
                    img: AppImage.forgetPassword3,
                    imgHeight: SizeConfig.height * .3,
                  ),

                  SizedBox(height: SizeConfig.height * .04),

                  AuthFieldLabel(
                    label: 'كلمة المرور',
                    controller: cubit.passwordController,
                    hint: 'ادخل كلمة المرور الجديدة...',
                    suffixIcon: state.isPasswordObscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    obscureText: state.isPasswordObscure,
                    onSuffixTap: () {
                      context
                          .read<ForgetPasswordCubit>()
                          .togglePasswordVisibility();
                    },
                  ),

                  SizedBox(height: SizeConfig.height * .03),

                  AuthFieldLabel(
                    label: 'تأكيد كلمة المرور',
                    controller: cubit.passwordConfirmationController,
                    hint: 'ادخل كلمة المرور مرة أخرة...',
                    suffixIcon: state.isPasswordObscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    obscureText: state.isPasswordObscure,
                    onSuffixTap: () {
                      context
                          .read<ForgetPasswordCubit>()
                          .togglePasswordVisibility();
                    },
                  ),

                  const SizedBox(height: 40),

                  CustomButtonWidget(
                    width: double.infinity,
                    backgroundColor: appColors.primaryToPrimaryDark,
                    childHorizontalPad: SizeConfig.width * .07,
                    childVerticalPad: SizeConfig.height * .012,
                    borderRadius: 8,
                    onTap: () {
                      if (state.resetStatus ==
                          ForgotPasswordResetStatus.loading) {
                        return;
                      }

                      context.read<ForgetPasswordCubit>().resetPassword();
                    },
                    child:
                        state.resetStatus == ForgotPasswordResetStatus.loading
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