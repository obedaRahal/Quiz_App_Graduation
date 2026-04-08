import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/common_widgets/custom_app_image.dart';
import 'package:quiz_app_grad/features/intro/data/model/intro_page_item.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';

class IntroImagePager extends StatelessWidget {
  final PageController controller;
  final List<IntroPageItem> pages;
  final ValueChanged<int> onPageChanged;

  const IntroImagePager({
    super.key,
    required this.controller,
    required this.pages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: PageView.builder(
        controller: controller,
        itemCount: pages.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return CustomAppImage(
            path: pages[index].image,
            width: double.infinity,
            height: SizeConfig.h(.75),
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
