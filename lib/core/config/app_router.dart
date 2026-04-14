import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/features/intro/presentation/view/intro_view.dart';
import 'package:quiz_app_grad/features/onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
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
          pageBuilder: (context, state) => _slidePage(
            state: state,
            child: BlocProvider(
              create: (_) => sl<OnboardingCubit>(),
              child: const OnboardingView(),
            ),
          ),
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

      case AuthSessionStatus.needsEmailVerification:
        return null;

      case AuthSessionStatus.needsOnboarding:
        return _needsOnboardingAllowedRoutes.contains(currentLocation)
            ? null
            : AppRouterPath.onboarding;

      case AuthSessionStatus.authenticated:
        return null;
    }
  }

  static const Set<String> _guestAllowedRoutes = {
    AppRouterPath.splash,
    AppRouterPath.welcome,
    AppRouterPath.intro,
  };

  static const Set<String> _needsOnboardingAllowedRoutes = {
    AppRouterPath.onboarding,
    AppRouterPath.welcome,
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
