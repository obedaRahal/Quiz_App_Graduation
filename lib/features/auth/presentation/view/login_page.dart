import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/core/utils/customer_snackbar_validation.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/top_container_auth.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/tow_text_row.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/models/onboarding_route_args.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final colorScheme = context.colorScheme;
    final cubit = context.read<LoginCubit>();

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.failure &&
            state.errorMessage != null) {
          final title = state.errorTitle ?? 'خطأ';

          switch (state.failureType) {
            case LoginFailureType.permanentBan:
              showValidationTopSnackBar(
                context,
                title: title,
                message: state.errorMessage!,
                type: AppValidationSnackBarType.error,
                reason: state.reason,
                startsAt: state.startsAt,
                displayDuration: const Duration(seconds: 6),
              );
              break;

            case LoginFailureType.temporaryBan:
              showValidationTopSnackBar(
                context,
                title: title,
                message: state.errorMessage!,
                type: AppValidationSnackBarType.error,
                reason: state.reason,
                startsAt: state.startsAt,
                endsAt: state.endsAt,
                displayDuration: const Duration(seconds: 6),
              );
              break;

            case LoginFailureType.emailNotVerified:
              showValidationTopSnackBar(
                context,
                title: title,
                message: state.errorMessage!,
                type: AppValidationSnackBarType.error,
                actionText: 'الذهاب إلى صفحة التحقق من البريد',
                onActionTap: () {
                  context.read<LoginCubit>().resendVerifyEmailOtp();

                  context.pushNamed(
                    AppRouterName.verifyEmail,
                    extra: {'email': cubit.emailController.text.trim()},
                  );
                },
                displayDuration: const Duration(seconds: 6),
              );
              break;

            // case LoginFailureType.onboardingNotCompleted:
            //   showValidationTopSnackBar(
            //     context,
            //     title: title,
            //     message: state.errorMessage!,
            //     type: AppValidationSnackBarType.error,
            //     actionText: 'الذهاب لاستكمال المعلومات',
            //     onActionTap: () {
            //       debugPrint(
            //         'Go to onboarding step: ${state.lastCompletedStep}',
            //       );
            //       debugPrint(
            //         'and email is : ${cubit.emailController.text}',
            //       );
            //     },
            //     displayDuration: const Duration(seconds: 6),
            //   );
            //   break;

            case LoginFailureType.onboardingNotCompleted:
              showValidationTopSnackBar(
                context,
                title: title,
                message: state.errorMessage!,
                type: AppValidationSnackBarType.error,
                actionText: 'الذهاب لاستكمال المعلومات',
                onActionTap: () {
                  final email = cubit.emailController.text.trim();
                  final lastCompletedStep = state.lastCompletedStep;

                  debugPrint('Go to onboarding step: $lastCompletedStep');
                  debugPrint('and email is: $email');

                  if (email.isEmpty) {
                    showValidationTopSnackBar(
                      context,
                      title: 'خطأ',
                      message: 'تعذر تحديد البريد الإلكتروني للمتابعة.',
                      type: AppValidationSnackBarType.error,
                    );
                    return;
                  }

                  context.goNamed(
                    AppRouterName.onboarding,
                    extra: OnboardingRouteArgs(
                      email: email,
                      lastCompletedStep: lastCompletedStep,
                    ),
                  );
                },
                displayDuration: const Duration(seconds: 6),
              );
              break;

            case LoginFailureType.general:
            case LoginFailureType.none:
              showValidationTopSnackBar(
                context,
                title: title,
                message: state.errorMessage!,
                type: AppValidationSnackBarType.error,
              );
              break;
          }
        }
        if (state.loginStatus == LoginStatus.success) {
          showValidationTopSnackBar(
            context,
            title: 'نجاح',
            message: state.successMessage ?? 'تمت العملية بنجاح.',
            type: AppValidationSnackBarType.success,
          );

          sl<AuthSession>().markAuthenticated();
          context.goNamed(AppRouterName.mainLayout);
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
                    title: 'تسجيل الدخول',
                    body:
                        'مرحبا بك مجددا !\nسجل دخولك لمتابعة خطتك الدراسية\nوتحويل المحتوى الدراسي الى تجربة\nتفاعلية ممتعة',
                  ),
                  const SizedBox(height: 50),

                  AuthFieldLabel(
                    label: 'البريد الالكتروني',
                    controller: cubit.emailController,
                    hint: 'ادخل بريدك الالكتروني...',
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 25),

                  AuthFieldLabel(
                    label: 'كلمة المرور',
                    controller: cubit.passwordController,
                    hint: 'ادخل كلمة المرور الخاصة بك...',
                    suffixIcon: state.isPasswordObscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    obscureText: state.isPasswordObscure,
                    onSuffixTap: () {
                      context.read<LoginCubit>().togglePasswordVisibility();
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

                  const SizedBox(height: 40),

                  CustomButtonWidget(
                    width: double.infinity,
                    backgroundColor: appColors.primaryToPrimaryDark,
                    childHorizontalPad: SizeConfig.width * .07,
                    childVerticalPad: SizeConfig.height * .012,
                    borderRadius: 8,
                    onTap: () {
                      if (state.loginStatus == LoginStatus.loading) {
                        return;
                      }

                      context.read<LoginCubit>().submitLogin();
                    },
                    child: state.loginStatus == LoginStatus.loading
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
      },
    );
  }
}
