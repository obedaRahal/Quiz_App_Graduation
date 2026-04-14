import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_button_widget.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_text_widget.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/theme/theme/theme_extensions.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_state.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/auth_feild_lable.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/top_container_auth.dart';
import 'package:quiz_app_grad/features/auth/presentation/widget/tow_text_row.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TopContainerAuth(
                title: 'انشاء حساب',
                body:
                    'انضم الينا وابدأ رحلتك في التطوير في \nشتّى المجالات الأكادمية بكل سهولة\n وسرعة حيث أن كل شيء اصبح في\n مكان واحد',
              ),
              SizedBox(height: 25),
              AuthFieldLabel(
                label: 'الاسم',
                hint: 'ادخل اسمك باللغة التي تريدها...',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icons.person_outlined,
              ),
              SizedBox(height: 25),
              AuthFieldLabel(
                label: 'البريد الالكتروني',
                hint: 'ادخل بريدك الالكتروني...',
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Icons.email_outlined,
              ),
              SizedBox(height: 25),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return AuthFieldLabel(
                    label: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور الخاصة بك...',
                    suffixIcon: state.isPasswordObscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    obscureText: state.isPasswordObscure,
                    onSuffixTap: () {
                      context.read<RegisterCubit>().togglePasswordVisibility();
                    },
                  );
                },
              ),
              SizedBox(height: 25),
              CustomTextWidget(
                'الجنس',

                fontSize: SizeConfig.text(0.05),
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: SizeConfig.height * .01),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<RegisterCubit>().selectGender(
                            Gender.male,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? state.selectedGender == Gender.male
                                      ? AppPalette.primaryDark
                                      : AppPalette.fieldColorNDark
                                : AppPalette.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: state.selectedGender == Gender.male
                                  ? isDark
                                        ? AppPalette.primaryDark
                                        : AppPalette.primary
                                  : isDark
                                  ? AppPalette.borderFieldColorNDark
                                  : AppPalette.greyBorder,
                              width: 2,
                            ),
                          ),
                          child: SvgPicture.asset(
                            AppImage.male,
                            color: state.selectedGender == Gender.male
                                ? isDark
                                      ? AppPalette.black
                                      : AppPalette.primary
                                : AppPalette.greyMedium,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      GestureDetector(
                        onTap: () {
                          context.read<RegisterCubit>().selectGender(
                            Gender.female,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDark
                                ? state.selectedGender == Gender.female
                                      ? AppPalette.primaryDark
                                      : AppPalette.fieldColorNDark
                                : AppPalette.white,
                            border: Border.all(
                              color: state.selectedGender == Gender.female
                                  ? isDark
                                        ? AppPalette.primaryDark
                                        : AppPalette.primary
                                  : isDark
                                  ? AppPalette.borderFieldColorNDark
                                  : AppPalette.greyBorder,
                              width: 2,
                            ),
                          ),
                          child: SvgPicture.asset(
                            AppImage.female,
                            color: state.selectedGender == Gender.female
                                ? isDark
                                      ? AppPalette.black
                                      : AppPalette.primary
                                : AppPalette.greyMedium,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 30),
              CustomButtonWidget(
                width: double.infinity,
                backgroundColor: AppPalette.primary,
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
                text: " لديك حساب فعلا، قم ",
                actionText: "تسجيل الدخول ",
                onTap: () {
                  GoRouter.of(context).replaceNamed(AppRouterName.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
