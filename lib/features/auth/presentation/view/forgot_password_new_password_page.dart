import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonTopPartForgetPassword(
                title: "انشاء كلمة مرور جديدة",
                bodyText: "يجب أن تكون كلمة المرور الجديدة\n مختلفة عن السابقة",
                img: AppImage.forgetPassword3,
                imgHeight: SizeConfig.height * .3,
              ),

              SizedBox(height: SizeConfig.height * .04),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                builder: (context, state) {
                  return AuthFieldLabel(
                    label: 'كلمة المرور',
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
                  );
                },
              ),
              SizedBox(height: SizeConfig.height * .03),
              BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
                builder: (context, state) {
                  return AuthFieldLabel(
                    label: 'تأكيد كلمة المرور',
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
                  );
                },
              ),
              SizedBox(height: 40),
              CustomButtonWidget(
                width: double.infinity,
                backgroundColor: appColors.primaryToPrimaryDark,
                childHorizontalPad: SizeConfig.width * .07,
                childVerticalPad: SizeConfig.height * .012,
                borderRadius: 8,
                onTap: () {},
                child: CustomTextWidget(
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
  }
}
