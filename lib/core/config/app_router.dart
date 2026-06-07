import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
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
import 'package:quiz_app_grad/features/details_of_test/data/models/details_of_test_route_args.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/manager/details_of_test_cubit/details_of_test_cubit.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/views/shared_test_redirect_view.dart';
import 'package:quiz_app_grad/features/get_all_interests/domain/use_case/get_all_interests_use_case.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/managet/all_categories_cubit/all_interests_cubit.dart';
import 'package:quiz_app_grad/features/get_all_interests/presentation/view/get_all_categories.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommanded_test_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_interests_use_case.dart';
import 'package:quiz_app_grad/features/home/domain/use_cases/get_recommended_users_use_case.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/views/details_of_test_view.dart';
import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/view/home_page.dart';
import 'package:quiz_app_grad/features/intro/presentation/view/intro_view.dart';
import 'package:quiz_app_grad/features/laboratory/presentation/view/laboratory_page.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/manager/my_test_details_cubit/my_test_details_cubit.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/views/my_private_test_details_view.dart';
import 'package:quiz_app_grad/features/my_test_details/presentation/views/my_test_details_view.dart';
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
import 'package:quiz_app_grad/features/test_play_modes/data/models/test_play_modes_route_args.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/manager/test_play_mode/test_play_modes_cubit.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/CHALLENGE/challenge_setup_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/FLASHCARD/flashcard_session_view.dart';
import 'package:quiz_app_grad/features/test_play_modes/presentation/views/MCQ/mcq_test_session_view.dart';

class AppRouter {
  AppRouter._();

  static late final GoRouter router;

  static void init() {
    final authSession = sl<AuthSession>();

    router = GoRouter(
      initialLocation: AppRouterPath.splash,
      overridePlatformDefaultLocation: true,
      refreshListenable: authSession,
      redirect: _handleRedirect,
      routes: [
        GoRoute(
          path: AppRouterPath.sharedTestRedirect,
          name: AppRouterName.sharedTestRedirect,
          pageBuilder: (context, state) {
            final slug = state.pathParameters['slug'] ?? '';

            debugPrint("============ SharedTestRedirect Route ============");
            debugPrint("→ received slug: $slug");
            debugPrint("=================================================");

            return _slidePage(
              state: state,
              child: BlocProvider(
                create: (_) {
                  final cubit = sl<DetailsOfTestCubit>();

                  if (slug.trim().isNotEmpty) {
                    cubit.getSharedTestLink(slug: slug);
                  }

                  return cubit;
                },
                child: SharedTestRedirectView(slug: slug),
              ),
            );
          },
        ),

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
              create: (context) => HomeCubit(
                getRecommendedTestsUseCase: sl<GetRecommendedTestsUseCase>(),
                getRecommendedInterestsUseCase:
                    sl<GetRecommendedInterestsUseCase>(),
                getRecommendedUsersUseCase: sl<GetRecommendedUsersUseCase>(),
              )..getHomeData(),
              child: const HomePage(),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.allCategoriesPage,
          name: AppRouterName.allCategoriesPage,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => AllInterestsCubit(
                getAllInterestsUseCase: sl<GetAllInterestsUseCase>(),
              )..getAllInterests(),
              child: const AllCategoriesPage(),
            );
          },
        ),

        GoRoute(
          path: AppRouterPath.laboratoryPage,
          name: AppRouterName.laboratoryPage,
          builder: (context, state) {
            return const LaboratoryPage();
          },
        ),
        GoRoute(
          path: AppRouterPath.detailsOfTest,
          name: AppRouterName.detailsOfTest,
          pageBuilder: (context, state) {
            final args = state.extra as DetailsOfTestRouteArgs?;

            final testId = args?.testId ?? 0;

            debugPrint("============ DetailsOfTest Route ============");
            debugPrint("→ received testId: $testId");
            debugPrint("=================================================");

            return _slidePage(
              state: state,
              child: BlocProvider(
                //lazy: false,
                create: (_) {
                  final cubit = sl<DetailsOfTestCubit>();

                  if (testId > 0) {
                    // Future.microtask(
                    //   () => cubit.getOtherTestDetailsOverview(testId: testId),
                    // );
                    cubit.getOtherTestDetailsOverview(testId: testId);
                    cubit.getOtherTestDetailsSample(testId: testId);
                    cubit.getOtherTestDetailsReviews(
                      testId: testId,
                      rating: 'all',
                    );
                  } else {
                    debugPrint("✗ DetailsOfTest Route: invalid testId");
                  }

                  return cubit;
                },
                child: const DetailsOfTestView(),
              ),
            );
          },
        ),

        GoRoute(
          path: AppRouterPath.mcqTestSessionView,
          name: AppRouterName.mcqTestSessionView,
          builder: (context, state) {
            debugPrint("============ mcqTestSessionView Route ============");

            final args = state.extra as TestPlayModesRouteArgs;

            debugPrint("→ received testId: ${args.testId}");
            debugPrint("=================================================");

            return BlocProvider(
              create: (_) => sl<TestPlayModesCubit>(),
              child: McqTestSessionView(testId: args.testId),
            );
          },
        ),
        GoRoute(
          path: AppRouterPath.challengeSetupView,
          name: AppRouterName.challengeSetupView,
          builder: (context, state) {
            debugPrint("============ challengeSetupView Route ============");

            final args = state.extra as TestPlayModesRouteArgs;

            debugPrint("→ received testId: ${args.testId}");
            debugPrint("=================================================");

            return BlocProvider(
              create: (_) => sl<TestPlayModesCubit>(),
              child: ChallengeSetupView(testId: args.testId),
            );
          },
        ),

        GoRoute(
          path: AppRouterPath.flashcardView,
          name: AppRouterName.flashcardView,
          builder: (context, state) {
            debugPrint("============ flashcardView Route ============");

            final args = state.extra as TestPlayModesRouteArgs;

            debugPrint("→ received testId: ${args.testId}");
            debugPrint("=================================================");

            return BlocProvider(
              create: (_) => sl<TestPlayModesCubit>(),
              child: FlashcardSessionView(testId: args.testId),
            );
          },
        ),

        //////////////////
        GoRoute(
          path: AppRouterPath.myTestDetails,
          name: AppRouterName.myTestDetails,
          builder: (context, state) {
            debugPrint("============ myTestDetails Route ============");

            final args = state.extra as DetailsOfTestRouteArgs;

            debugPrint("→ received testId: ${args.testId}");
            debugPrint("=================================================");

            return MultiBlocProvider(
              providers: [
                BlocProvider<MyTestDetailsCubit>(
                  create: (_) => sl<MyTestDetailsCubit>(),
                ),
                BlocProvider<DetailsOfTestCubit>(
                  create: (_) => sl<DetailsOfTestCubit>(),
                ),
              ],
              child: MyTestDetailsView(testId: args.testId),
            );
          },
        ),

        GoRoute(
          path: AppRouterPath.myPrivateTestDetails,
          name: AppRouterName.myPrivateTestDetails,
          builder: (context, state) {
            debugPrint("============ myPrivateTestDetails Route ============");

            final args = state.extra as DetailsOfTestRouteArgs;

            debugPrint("→ received testId: ${args.testId}");
            debugPrint("=================================================");

            return BlocProvider<MyTestDetailsCubit>(
              create: (_) => sl<MyTestDetailsCubit>(),
              child: MyPrivateTestDetailsView(testId: args.testId),
            );
          },
        ),
      ],
    );
  }

  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final uri = state.uri;

    if (uri.scheme == 'nerd' && uri.host == 'tests') {
      final slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';

      debugPrint("============ Router Deep Link Redirect ============");
      debugPrint("→ original uri: $uri");
      debugPrint("→ slug: $slug");
      debugPrint("===================================================");

      if (slug.isNotEmpty) {
        return AppRouterPath.sharedTestRedirectPath(slug);
      }
    }

    final currentLocation = state.matchedLocation;
    final status = sl<AuthSession>().status;

    debugPrint("============ Router Redirect ============");
    debugPrint("→ matchedLocation: ${state.matchedLocation}");
    debugPrint("→ uri: ${state.uri}");
    debugPrint("→ authStatus: $status");
    debugPrint("=========================================");

    if (currentLocation == AppRouterPath.sharedTestRedirect) {
      return null;
    }

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

    AppRouterPath.home,
    AppRouterPath.mainLayout,
    AppRouterPath.detailsOfTest,

    AppRouterPath.sharedTestRedirect,
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
