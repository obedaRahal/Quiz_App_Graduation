import 'package:flutter/material.dart';
import 'package:quiz_app_grad/core/theme/assets/images.dart';
import 'package:quiz_app_grad/core/theme/color/app_colors.dart';
import 'package:quiz_app_grad/core/utils/media_query_config.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/play_mode_card.dart';
import 'package:quiz_app_grad/features/details_of_test/presentation/widgets/test_details_card.dart';

class TestDetailsWithPlayModesSection extends StatelessWidget {
  const TestDetailsWithPlayModesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final detailsHeight = SizeConfig.h(0.21);
    const playCardHeight = 95.0;
    const overlapSpace = 40.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(0.03)),
      child: SizedBox(
        height: detailsHeight + playCardHeight - overlapSpace,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: detailsHeight,
                child: const TestDetailsCard(),
              ),
            ),

            Positioned(
              top: detailsHeight - overlapSpace,
              left: SizeConfig.w(0.22),
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayModeCard(
                    title: "التحدي 1VS1",
                    iconPath: AppImage.muscleIcon,
                    backgroundColor: AppPalette.violetMedium,
                    shadowColor: AppPalette.circleContainer3,
                    onTap: () => debugPrint("challenge"),
                  ),
                  PlayModeCard(
                    title: "اختيارات متعددة",
                    iconPath: "assets/icons/layers.svg",
                    backgroundColor: AppPalette.homeContainer3,
                    shadowColor: AppPalette.circleContainer3,
                    onTap: () => debugPrint("mcq"),
                  ),
                  PlayModeCard(
                    title: "بطاقات الاستذكار",
                    iconPath: "assets/icons/layers.svg",
                    backgroundColor: AppPalette.homeContainer2,
                    shadowColor: AppPalette.circleContainer1,
                    onTap: () => debugPrint("flashcards"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
