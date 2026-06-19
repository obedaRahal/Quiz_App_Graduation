// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quiz_app_grad/core/utils/media_query_config.dart';
// import 'package:quiz_app_grad/features/home/presentation/managet/home_cubit/home_cubit.dart';

// import 'home_top_banner_card.dart';

// class HomeTopBannerSlider extends StatelessWidget {
//   final PageController controller;
//   final bool isDark;
//   final dynamic colorScheme;
//   final double circleSize;
//   final double imageSize;

//   const HomeTopBannerSlider({
//     super.key,
//     required this.controller,
//     required this.isDark,
//     required this.colorScheme,
//     required this.circleSize,
//     required this.imageSize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: SizeConfig.h(0.178),
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: PageView.builder(
//           controller: controller,
//           itemCount: 3,
//           onPageChanged: (index) {
//             context.read<HomeCubit>().changePage(index);
//           },
//           itemBuilder: (context, index) {
//             return HomeTopBannerCard(
//               index: index,
//               isDark: isDark,
//               colorScheme: colorScheme,
//               circleSize: circleSize,
//               imageSize: imageSize,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_cubit.dart';

import 'home_top_banner_card.dart';

class HomeTopBannerSlider extends StatefulWidget {
  final PageController controller;
  final bool isDark;
  final dynamic colorScheme;
  final double circleSize;
  final double imageSize;

  const HomeTopBannerSlider({
    super.key,
    required this.controller,
    required this.isDark,
    required this.colorScheme,
    required this.circleSize,
    required this.imageSize,
  });

  @override
  State<HomeTopBannerSlider> createState() => _HomeTopBannerSliderState();
}

class _HomeTopBannerSliderState extends State<HomeTopBannerSlider> {
  static const int _bannerCount = 3;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer?.cancel();

    _autoSlideTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!mounted || !widget.controller.hasClients) return;

        final currentIndex = context.read<HomeCubit>().state.pageIndex;
        final nextIndex = (currentIndex + 1) % _bannerCount;

        widget.controller.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        context.read<HomeCubit>().changePage(nextIndex);
      },
    );
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.h(0.178),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: PageView.builder(
          controller: widget.controller,
          itemCount: _bannerCount,
          onPageChanged: (index) {
            context.read<HomeCubit>().changePage(index);
          },
          itemBuilder: (context, index) {
            return HomeTopBannerCard(
              index: index,
              isDark: widget.isDark,
              colorScheme: widget.colorScheme,
              circleSize: widget.circleSize,
              imageSize: widget.imageSize,
            );
          },
        ),
      ),
    );
  }
}