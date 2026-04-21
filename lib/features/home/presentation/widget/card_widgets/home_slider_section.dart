import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'home_slider_card.dart';

class HomeSliderSection extends StatelessWidget {
  final PageController controller2;
  final bool isDark;
  final dynamic appColors;
  final dynamic colorScheme;

  const HomeSliderSection({
    super.key,
    required this.controller2,
    required this.isDark,
    required this.appColors,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.isSmallPhone
                ? SizeConfig.h(0.42)
                : SizeConfig.isMediumPhone
                ? SizeConfig.h(0.43)
                : SizeConfig.h(0.44),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PageView.builder(
                controller: controller2,
                padEnds: false,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return HomeSliderCard(
                    isDark: isDark,
                    appColors: appColors,
                    colorScheme: colorScheme,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}