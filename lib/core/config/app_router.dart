import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/api/dio_consumer.dart';
import 'package:quiz_app_grad/core/database/api/end_point.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:quiz_app_grad/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:quiz_app_grad/features/auth/domain/use_cases/register_use_case.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/login_cubit/login_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/register_cubit/register_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/managet/verify_register_cubit/verify_register_cubit.dart';
import 'package:quiz_app_grad/features/auth/presentation/view/forgot_password_email_page.dart';
import 'package:quiz_app_grad/features/auth/presentation/view/forgot_password_new_password_page.dart';
import 'package:quiz_app_grad/features/auth/presentation/view/forgot_password_otp_code_page.dart';
import 'package:quiz_app_grad/features/auth/presentation/view/login_page.dart';
import 'package:quiz_app_grad/features/auth/presentation/view/register_page.dart';
import 'package:quiz_app_grad/features/auth/presentation/view/verify_email_page.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/view/home_page.dart';
import 'package:quiz_app_grad/features/intro/presentation/view/intro_view.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_interests_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/get_onboarding_progress_preview_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_current_university_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_discovery_source_use_case.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:quiz_app_grad/features/main_layout/presentation/view/main_layout.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_education_level_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_graduate_academic_profile_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_school_stage_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/domain/use_cases/submit_user_interests_use_case.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/models/onboarding_route_args.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:quiz_app_grad/features/splash_welcome/presentation/view/splash_view.dart';
import 'package:quiz_app_grad/features/splash_welcome/presentation/view/welcome_view.dart';

class AppRouter {
  AppRouter._();

  static late final GoRouter router;

  static void init() {
    final authSession = sl<AuthSession>();

    router = GoRouter(
      initialLocation: AppRouterPath.splash,
      refreshListenable: authSession,
      redirect: _handleRedirect,
      routes: [
        GoRoute(
          path: AppRouterPath.splash,
          name: AppRouterName.splash,
          pageBuilder: (context, state) =>
              _fadePage(state: state, child: const SplashView()),
        ),
        GoRoute(
          path: AppRouterPath.welcome,
          name: AppRouterName.welcome,
          pageBuilder: (context, state) =>
              _slidePage(state: state, child: const WelcomeView()),
        ),

        GoRoute(
          path: AppRouterPath.intro,
          name: AppRouterName.intro,
          pageBuilder: (context, state) =>
              _slidePage(state: state, child: const IntroView()),
        ),

        GoRoute(
          path: AppRouterPath.onboarding,
          name: AppRouterName.onboarding,
          pageBuilder: (context, state) {
            final args = state.extra as OnboardingRouteArgs?;
            final email = args?.email.trim() ?? '';

            if (email.isEmpty) {
              return _slidePage(state: state, child: const WelcomeView());
            }

            final lastCompletedStep = args?.lastCompletedStep;

            return _slidePage(
              state: state,
              child: BlocProvider(
                create: (_) {
                  final cubit = OnboardingCubit(
                    onboardingEmail: email,
                    submitDiscoverySourceUseCase:
                        sl<SubmitDiscoverySourceUseCase>(),
                    submitEducationLevelUseCase:
                        sl<SubmitEducationLevelUseCase>(),
                    submitSchoolStageUseCase: sl<SubmitSchoolStageUseCase>(),
                    submitCurrentUniversityProfileUseCase:
                        sl<SubmitCurrentUniversityProfileUseCase>(),
                    submitGraduateAcademicProfileUseCase:
                        sl<SubmitGraduateAcademicProfileUseCase>(),
                    getOnboardingInterestsUseCase:
                        sl<GetOnboardingInterestsUseCase>(),
                    submitUserInterestsUseCase:
                        sl<SubmitUserInterestsUseCase>(),
                    getOnboardingProgressPreviewUseCase:
                        sl<GetOnboardingProgressPreviewUseCase>(),
                  );

                  if (lastCompletedStep != null) {
                    cubit.initializeProgressPreviewIfNeeded(
                      lastCompletedStep: lastCompletedStep,
                    );
                  }

                  return cubit;
                },
                child: const OnboardingView(),
              ),
            );
          },
        ),

        GoRoute(
          path: AppRouterPath.login,
          name: AppRouterName.login,
          // pageBuilder: (context, state) =>
          //       _slidePage(state: state, child: const LoginPage()),
          //  builder: (context, state) => const LoginPage(),
          builder: (context, state) {
            return BlocProvider(
              create: (_) => sl<LoginCubit>(),
              child: const LoginPage(),
            );
          },
        ),

        // GoRoute(
        //   path: AppRouterPath.register,
        //   name: AppRouterName.register,
        //   builder: (context, state) {
        //     final dio = Dio(
        //       BaseOptions(
        //         baseUrl: EndPoints.baseUrl,
        //         receiveDataWhenStatusError: true,
        //       ),
        //     );
        //     final apiConsumer = DioConsumer(dio: dio);
        //     final authRemoteDataSource = AuthRemoteDataSourceImpl(
        //       apiConsumer: apiConsumer,
        //       refreshDio: sl<Dio>(instanceName: 'refresh_dio')
        //     );

        //     final authRepository = AuthRepositoryImpl(
        //       authRemoteDataSource: authRemoteDataSource,
        //     );

        //     final registerUseCase = RegisterUseCase(authRepository);
        //     return BlocProvider(
        //       create: (_) => RegisterCubit(registerUseCase),
        //       child: const RegisterPage(),
        //     );
        //   },
        // ),
        GoRoute(
          path: AppRouterPath.register,
          name: AppRouterName.register,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => sl<RegisterCubit>(),
              child: const RegisterPage(),
            );
          },
        ),

        GoRoute(
          path: AppRouterPath.verifyEmail,
          name: AppRouterName.verifyEmail,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final email = extra?['email'] as String? ?? '';

            final cubit = sl<VerifyRegisterCubit>();
            cubit.setEmail(email);

            return BlocProvider(
              create: (_) => cubit,
              child: const VerifyEmailPage(),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.forgotPasswordEmail,
          name: AppRouterName.forgotPasswordEmail,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => sl<ForgetPasswordCubit>(),
              child: const ForgotPasswordEmailPage(),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.forgotPasswordOtpCode,
          name: AppRouterName.forgotPasswordOtpCode,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final email = extra?['email'] as String? ?? '';

            final cubit = sl<ForgetPasswordCubit>();
            cubit.setEmail(email);

            return BlocProvider(
              create: (_) => cubit,
              child: const ForgotPasswordOtpCodePage(),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.forgotPasswordNewPassword,
          name: AppRouterName.forgotPasswordNewPassword,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final email = extra?['email'] as String? ?? '';
            final otpCode = extra?['otpCode'] as String? ?? '';

            final cubit = sl<ForgetPasswordCubit>();
            cubit.setEmail(email);
            cubit.setOtpCode(otpCode);

            return BlocProvider(
              create: (_) => cubit,
              child: const ForgotPasswordNewPasswordPage(),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.mainLayout,
          name: AppRouterName.mainLayout,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => BottomNavCubit(),
              child: const MainLayoutBody(),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.home,
          name: AppRouterName.home,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => HomeCubit(),
              child: const HomePage(),
            );
          },
        ),
      ],
    );
  }

  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final currentLocation = state.matchedLocation;
    final status = sl<AuthSession>().status;

    switch (status) {
      case AuthSessionStatus.unknown:
        return currentLocation == AppRouterPath.splash
            ? null
            : AppRouterPath.splash;

      case AuthSessionStatus.unauthenticated:
        return _guestAllowedRoutes.contains(currentLocation)
            ? null
            : AppRouterPath.welcome;

      case AuthSessionStatus.authenticated:
        return _authBlockedRoutes.contains(currentLocation)
            ? AppRouterPath.mainLayout
            : null;
    }
  }

  static const Set<String> _guestAllowedRoutes = {
    AppRouterPath.splash,
    AppRouterPath.welcome,
    AppRouterPath.intro,
    AppRouterPath.login,
    AppRouterPath.register,
    AppRouterPath.verifyEmail,
    AppRouterPath.onboarding,
    AppRouterPath.forgotPasswordEmail,
    AppRouterPath.forgotPasswordOtpCode,
    AppRouterPath.forgotPasswordNewPassword,

    // AppRouterPath.home,
    // AppRouterPath.mainLayout,
  };

  static const Set<String> _authBlockedRoutes = {
    AppRouterPath.splash,
    AppRouterPath.welcome,
    AppRouterPath.intro,
    AppRouterPath.login,
    AppRouterPath.register,
    AppRouterPath.verifyEmail,
    AppRouterPath.onboarding,
    AppRouterPath.forgotPasswordEmail,
    AppRouterPath.forgotPasswordOtpCode,
    AppRouterPath.forgotPasswordNewPassword,
  };

  static CustomTransitionPage<void> _slidePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  static CustomTransitionPage<void> _fadePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
