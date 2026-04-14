import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/top_container_auth.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/tow_text_row.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopContainerAuth(
                title: 'تسجيل الدخول',
                body:
                    'مرحبا بك مجددا !\nسجل دخولك لمتابعة خطتك الدراسية\nوتحويل المحتوى الدراسي الى تجربة\nتفاعلية ممتعة',
              ),
              SizedBox(height: 50),
              AuthFieldLabel(
                label: 'البريد الالكتروني',
                hint: 'ادخل بريدك الالكتروني...',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icons.email_outlined,
              ),
              SizedBox(height: 25),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return AuthFieldLabel(
                    label: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور الخاصة بك...',
                    suffixIcon: state.isPasswordObscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    obscureText: state.isPasswordObscure,
                    onSuffixTap: () {
                      context.read<LoginCubit>().togglePasswordVisibility();
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: InkWell(
                    onTap: () {
                      debugPrint("forgotPasswordEmail");
                      context.pushNamed(AppRouterName.forgotPasswordEmail);
                    },
                    child: CustomTextWidget(
                      "نسيت كلمة المرور ؟",
                      fontSize: SizeConfig.text(0.045),
                      color: appColors.primaryToPrimaryDark,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              CustomButtonWidget(
                width: double.infinity,
                backgroundColor: appColors.primaryToPrimaryDark,
                childHorizontalPad: SizeConfig.width * .07,
                childVerticalPad: SizeConfig.height * .012,
                borderRadius: 8,
                onTap: () {
                  context.pushNamed(AppRouterName.verifyEmail);

                  debugPrint(" verify Email ");
                },
                child: CustomTextWidget(
                  "تأكيد الإدخال",
                  fontSize: SizeConfig.text(0.055),
                  color: colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: SizeConfig.height * .02),

              TowTextRow(
                text: " ليس لديك حساب ؟ قم بإنشاء ",
                actionText: "حساب جديد ",
                onTap: () {
                  GoRouter.of(context).replaceNamed(AppRouterName.register);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
