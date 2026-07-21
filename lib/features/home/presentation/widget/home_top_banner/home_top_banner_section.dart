import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:quiz_app_grad/features/home/presentation/manager/home_cubit/home_state.dart';

import 'home_top_banner_indicator.dart';
import 'home_top_banner_slider.dart';

class HomeTopBannerSection extends StatelessWidget {
  final PageController controller;
  final bool isDark;
  final dynamic colorScheme;
  final double circleSize;
  final double imageSize;

  const HomeTopBannerSection({
    super.key,
    required this.controller,
    required this.isDark,
    required this.colorScheme,
    required this.circleSize,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          textDirection: TextDirection.rtl,
          children: [
            HomeTopBannerSlider(
              controller: controller,
              isDark: isDark,
              colorScheme: colorScheme,
              circleSize: circleSize,
              imageSize: imageSize,
            ),
            SizedBox(height: SizeConfig.h(0.012).clamp(8.0, 12.0).toDouble()),
            HomeTopBannerIndicator(currentIndex: state.pageIndex),
          ],
        );
      },
    );
  }
}
