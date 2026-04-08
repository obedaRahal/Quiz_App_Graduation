// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quiz_app_grad/core/config/app_router_name.dart';
// import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
// import 'package:quiz_app_grad/core/di/service_locator.dart';
// import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
// import 'package:quiz_app_grad/core/theme/assets/images.dart';
// import 'package:quiz_app_grad/core/utils/auth_session.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/splash_welcome/presentation/widget/sliding_text.dart';

// class SplashViewBody extends StatefulWidget {
//   const SplashViewBody({super.key});

//   @override
//   State<SplashViewBody> createState() => _SplashViewbodyState();
// }

// class _SplashViewbodyState extends State<SplashViewBody>
//     with SingleTickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<Offset> slidingAnimation;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     initSlidingAnimation();
//     navigateToHome();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(
//             AppImage.logo,
//             height: SizeConfig.height * 0.25,
//             width: SizeConfig.width * .5,
//             errorBuilder: (context, error, stackTrace) =>
//                 const Icon(Icons.access_time_rounded),
//           ),
//         ),
//         Text(
//           "نيرد",
//           textAlign: TextAlign.center,

//           style: TextStyle(
//             fontSize: SizeConfig.height * 0.07,
//             fontFamily: AppFont.elMessiriBold,
//           ),
//         ),
//         Divider(
//           endIndent: SizeConfig.height * 0.12,
//           indent: SizeConfig.height * 0.12,
//         ),
//         SlidingText(slidingAnimation: slidingAnimation),
//       ],
//     );
//   }

//   void initSlidingAnimation() {
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     );

//     slidingAnimation = Tween<Offset>(
//       begin: const Offset(0, 5),
//       end: Offset.zero,
//     ).animate(animationController);

//     animationController.forward();
//   }

//   void navigateToHome() {
//     _timer = Timer(const Duration(seconds: 5), () {
//       if (!mounted) return;

//       final hasSeenIntro =
//           CacheHelper.getBool(key: CacheHelper.hasSeenIntroKey) ?? false;

//       sl<AuthSession>().markUnauthenticated();

//       if (hasSeenIntro) {
//         context.goNamed(AppRouterName.welcome);
//       } else {
//         context.goNamed(AppRouterName.intro);
//       }
//     });
//   }
// }

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/core/config/app_router_name.dart';
import 'package:quiz_app_grad/core/database/cache/cache_helper.dart';
import 'package:quiz_app_grad/core/di/service_locator.dart';
import 'package:quiz_app_grad/core/theme/assets/fonts.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/auth_session.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

// class SplashViewBody extends StatefulWidget {
//   const SplashViewBody({super.key});

//   @override
//   State<SplashViewBody> createState() => _SplashViewBodyState();
// }

// class _SplashViewBodyState extends State<SplashViewBody>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   late final Animation<double> _logoScaleAnimation;
//   late final Animation<double> _logoFadeAnimation;
//   late final Animation<Offset> _titleSlideAnimation;
//   late final Animation<double> _titleFadeAnimation;
//   late final Animation<double> _taglineFadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initAnimations();
//     _startSplashSequence();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _initAnimations() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );

//     _logoScaleAnimation = Tween<double>(begin: 0.82, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.35, curve: Curves.easeOutBack),
//       ),
//     );

//     _logoFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.00, 0.28, curve: Curves.easeIn),
//       ),
//     );

//     _titleSlideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: const Interval(0.22, 0.60, curve: Curves.easeOutCubic),
//           ),
//         );

//     _titleFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.20, 0.50, curve: Curves.easeIn),
//       ),
//     );

//     _taglineFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.45, 0.80, curve: Curves.easeIn),
//       ),
//     );
//   }

//   Future<void> _startSplashSequence() async {
//     await _controller.forward();

//     await Future.delayed(const Duration(milliseconds: 1200));

//     if (!mounted) return;

//     final hasSeenIntro =
//         CacheHelper.getBool(key: CacheHelper.hasSeenIntroKey) ?? false;

//     // انتبه: لا تضع markUnauthenticated هنا إلا إذا كان هذا مقصودًا فعلاً
//     sl<AuthSession>().markUnauthenticated();

//     if (hasSeenIntro) {
//       context.goNamed(AppRouterName.welcome);
//     } else {
//       context.goNamed(AppRouterName.intro);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig.init(context);

//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [AppColor.white, AppColor.primaryToWhiht],
//         ),
//       ),
//       child: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: SizeConfig.width * .08),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FadeTransition(
//                   opacity: _logoFadeAnimation,
//                   child: ScaleTransition(
//                     scale: _logoScaleAnimation,
//                     child: Container(
//                       padding: const EdgeInsets.all(18),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColor.primary.withOpacity(.25),
//                             blurRadius: 30,
//                             spreadRadius: 10,
//                           ),
//                         ],
//                       ),
//                       child: Image.asset(
//                         AppImage.logo,
//                         height: SizeConfig.height * .25,
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: SizeConfig.height * .025),

//                 FadeTransition(
//                   opacity: _titleFadeAnimation,
//                   child: SlideTransition(
//                     position: _titleSlideAnimation,
//                     child: Text(
//                       "نيرد",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: SizeConfig.height * 0.055,
//                         fontFamily: AppFont.elMessiriBold,
//                         color: AppColor.black,
//                       ),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: SizeConfig.height * .008),

//                 FadeTransition(
//                   opacity: _taglineFadeAnimation,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: SizeConfig.width * .04,
//                       vertical: SizeConfig.height * .008,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColor.white.withOpacity(.65),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       "اختبارات • خطة دراسية • محتوى تعليمي",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: SizeConfig.diagonal * .015,
//                         fontFamily: AppFont.elMessiriBold,
//                         color: AppColor.greyToDark,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

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

  Future<void> _startSequence() async {
    try {
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      final hasSeenIntro =
          CacheHelper.getBool(key: CacheHelper.hasSeenIntroKey) ?? false;

      sl<AuthSession>().markUnauthenticated();

      if (hasSeenIntro) {
        context.goNamed(AppRouterName.welcome);
      } else {
        context.goNamed(AppRouterName.intro);
      }
    } on TickerCanceled {
      // تجاهل الخطأ إذا تم التخلص من الـ controller قبل اكتمال الأنيميشن
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
                    AppColor.primaryToWhiht,

                    AppColor.white2,
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
                      color: AppColor.primary.withOpacity(
                        0.10 * _backgroundGlow.value,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: SizeConfig.h(0.07),
                    left: -SizeConfig.w(0.09),
                    child: _BlurCircle(
                      size: SizeConfig.w(0.44),
                      color: AppColor.primary.withOpacity(
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
                                      color: AppColor.primary.withOpacity(.2),
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
                          color: AppColor.black,
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
                        color: AppColor.white.withOpacity(.65),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColor.primary.withOpacity(.08),
                        ),
                      ),
                      child: Text(
                        "اختبارات • خطة دراسية • مكتبة علمية",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          fontFamily: AppFont.elMessiriMedium,
                          color: AppColor.greyToDark,
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
