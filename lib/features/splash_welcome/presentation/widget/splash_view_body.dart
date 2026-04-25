import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/database/cache/token_storage.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/auth/domain/repositories/auth_repository.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<Offset> _logoSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _subtitleFade;

  late final Animation<double> _pulse;
  late final Animation<double> _backgroundGlow;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.00, 1.0, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.30, curve: Curves.easeOutBack),
      ),
    );

    _logoSlide = Tween<Offset>(begin: const Offset(0, -6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.00, 0.32, curve: Curves.easeOutCubic),
          ),
        );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.45, curve: Curves.easeIn),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.52, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.72, curve: Curves.easeIn),
    );

    _pulse =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 1.0,
              end: 1.035,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: 1.035,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.85),
          ),
        );

    _backgroundGlow = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.00, 0.65, curve: Curves.easeOut),
      ),
    );
  }

  // Future<void> _startSequence() async {
  //   try {
  //     await _controller.forward();
  //     await Future.delayed(const Duration(milliseconds: 700));

  //     if (!mounted) return;

  //     final hasSeenIntro =
  //         CacheHelper.getBool(key: CacheHelper.hasSeenIntroKey) ?? false;

  //     sl<AuthSession>().markUnauthenticated();

  //     if (hasSeenIntro) {
  //       context.goNamed(AppRouterName.welcome);
  //     } else {
  //       context.goNamed(AppRouterName.intro);
  //     }
  //   } on TickerCanceled {
  //     // تجاهل الخطأ إذا تم التخلص من الـ controller قبل اكتمال الأنيميشن
  //   }
  // }

  Future<void> _startSequence() async {
    try {
      debugPrint("============ SplashViewBody._startSequence ============");

      await _controller.forward();
      debugPrint("✓ splash animation finished");

      await Future.delayed(const Duration(milliseconds: 700));
      debugPrint("✓ splash delay finished");

      if (!mounted) {
        debugPrint("✗ SplashViewBody not mounted anymore");
        debugPrint("=================================================");
        return;
      }

      await _resolveStartupFlow();
    } on TickerCanceled {
      debugPrint("✗ splash animation cancelled");
    } catch (e, s) {
      debugPrint("✗ SplashViewBody._startSequence error => $e");
      debugPrint("✗ SplashViewBody._startSequence stack => $s");

      await TokenStorage.clear();
      sl<AuthSession>().markUnauthenticated();

      if (!mounted) return;
      context.goNamed(AppRouterName.welcome);
    }
  }

  Future<void> _resolveStartupFlow() async {
    debugPrint("============ SplashViewBody._resolveStartupFlow ============");

    final hasSeenIntro =
        CacheHelper.getBool(key: CacheHelper.hasSeenIntroKey) ?? false;

    debugPrint("→ hasSeenIntro: $hasSeenIntro");

    if (!hasSeenIntro) {
      debugPrint("→ user did not see intro yet");
      sl<AuthSession>().markUnauthenticated();

      if (!mounted) return;
      context.goNamed(AppRouterName.intro);
      debugPrint("→ navigated to intro");
      debugPrint("=================================================");
      return;
    }

    debugPrint("→ intro already seen, checking auth session...");
    await _restoreSessionAndNavigate();
  }

  Future<void> _restoreSessionAndNavigate() async {
    debugPrint(
      "============ SplashViewBody._restoreSessionAndNavigate ============",
    );

    final authSession = sl<AuthSession>();
    final authRepository = sl<AuthRepository>();

    try {
      authSession.markChecking();
      debugPrint("→ auth session marked as checking");

      final hasAccessToken = await TokenStorage.hasAccessToken();
      final currentToken = await TokenStorage.getAccessToken();
      final expiryAt = await TokenStorage.getAccessTokenExpiry();

      debugPrint("→ hasAccessToken: $hasAccessToken");
      debugPrint("→ token length: ${currentToken?.length ?? 0}");
      debugPrint("→ expiryAt: ${expiryAt?.toIso8601String() ?? 'null'}");

      if (!hasAccessToken || currentToken == null || currentToken.isEmpty) {
        debugPrint("→ no stored access token found");
        await TokenStorage.clear();
        authSession.markUnauthenticated();

        if (!mounted) return;
        context.goNamed(AppRouterName.welcome);
        debugPrint("→ navigated to welcome");
        debugPrint("=================================================");
        return;
      }

      final hasValidAccessToken = await TokenStorage.hasValidAccessToken(
        buffer: const Duration(minutes: 2),
      );

      debugPrint("→ hasValidAccessToken(buffer 2m): $hasValidAccessToken");

      if (hasValidAccessToken) {
        debugPrint("→ stored token is still valid");
        authSession.markAuthenticated();

        if (!mounted) return;
        context.goNamed(AppRouterName.mainLayout);
        debugPrint("→ navigated to mainLayout");
        debugPrint("=================================================");
        return;
      }

      debugPrint("→ token expired or expiring soon, trying refresh...");

      final refreshSucceeded = await authRepository.refreshAccessToken();

      debugPrint("→ refreshSucceeded: $refreshSucceeded");

      if (refreshSucceeded) {
        final refreshedToken = await TokenStorage.getAccessToken();
        final refreshedExpiry = await TokenStorage.getAccessTokenExpiry();

        debugPrint("✓ refresh succeeded");
        debugPrint("→ refreshed token length: ${refreshedToken?.length ?? 0}");
        debugPrint(
          "→ refreshed expiryAt: ${refreshedExpiry?.toIso8601String() ?? 'null'}",
        );

        authSession.markAuthenticated();

        if (!mounted) return;
        context.goNamed(AppRouterName.mainLayout);
        debugPrint("→ navigated to mainLayout after refresh");
        debugPrint("=================================================");
        return;
      }

      debugPrint("✗ refresh returned false");
      await TokenStorage.clear();
      authSession.markUnauthenticated();

      if (!mounted) return;
      context.goNamed(AppRouterName.welcome);
      debugPrint("→ navigated to welcome after failed refresh");
    } catch (e, s) {
      debugPrint("✗ Splash restore session error => $e");
      debugPrint("✗ Splash restore session stack => $s");

      await TokenStorage.clear();
      authSession.markUnauthenticated();

      if (!mounted) return;
      context.goNamed(AppRouterName.welcome);
      debugPrint("→ navigated to welcome after exception");
    } finally {
      debugPrint("=================================================");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final logoSize = SizeConfig.height * 0.16;
    final titleSize = SizeConfig.text(0.1);
    final subtitleSize = SizeConfig.text(0.03);

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _backgroundGlow,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    //  AppColor.white2,
                    // AppColor.primary,
                    AppPalette.primarySoft,

                    AppPalette.whiteSoft,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -SizeConfig.h(0.04),
                    right: -SizeConfig.w(0.1),
                    child: _BlurCircle(
                      size: SizeConfig.w(0.52),
                      color: AppPalette.primary.withOpacity(
                        0.10 * _backgroundGlow.value,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: SizeConfig.h(0.07),
                    left: -SizeConfig.w(0.09),
                    child: _BlurCircle(
                      size: SizeConfig.w(0.44),
                      color: AppPalette.primary.withOpacity(
                        0.06 * _backgroundGlow.value,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.08)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: SlideTransition(
                      position: _logoSlide,
                      child: ScaleTransition(
                        scale: _pulse,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: logoSize * 1.35,
                                height: logoSize * 1.35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppPalette.primary.withOpacity(.2),
                                      blurRadius: 30,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              CustomAppImage(
                                path: AppImage.logo,
                                height: logoSize,
                                width: 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.h(0.04)),

                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        "نيرد",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontFamily: AppFont.elMessiriBold,
                          color: AppPalette.black,
                          height: 1.1,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.height * .010),

                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(0.04),
                        vertical: SizeConfig.h(0.009),
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.white.withOpacity(.65),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppPalette.primary.withOpacity(.08),
                        ),
                      ),
                      child: Text(
                        "اختبارات • خطة دراسية • مكتبة علمية",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          fontFamily: AppFont.elMessiriMedium,
                          color: AppPalette.greyMedium,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 70, spreadRadius: 18),
          ],
        ),
      ),
    );
  }
}
